import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:session_auth_auto/session_auth_auto.dart';
import 'package:session_auth_auto/src/database/session_database.dart';
import 'package:session_auth_auto/src/storage/secure_credential_storage.dart';

class MemoryCredentialStorage extends SecureCredentialStorage {
  final Map<String, String> _data = {};

  @override
  Future<void> saveCredentials(String userId, Credentials credentials) async {
    _data['credentials_$userId'] = json.encode(credentials.toJson());
  }

  @override
  Future<Credentials?> getCredentials(String userId) async {
    final str = _data['credentials_$userId'];
    if (str == null) return null;
    return Credentials.fromJson(json.decode(str) as Map<String, dynamic>);
  }

  @override
  Future<void> deleteCredentials(String userId) async {
    _data.remove('credentials_$userId');
  }

  @override
  Future<void> saveActiveUserId(String userId) async {
    _data['active_user_id'] = userId;
  }

  @override
  Future<String?> getActiveUserId() async {
    return _data['active_user_id'];
  }

  @override
  Future<void> deleteActiveUserId() async {
    _data.remove('active_user_id');
  }

  @override
  Future<void> clearAll() async {
    _data.clear();
  }
}

void main() {
  late SessionDatabase database;
  late MemoryCredentialStorage secureStorage;

  setUp(() {
    SessionAuthAuto.reset();
    database = SessionDatabase(NativeDatabase.memory());
    secureStorage = MemoryCredentialStorage();
  });

  tearDown(() async {
    await database.close();
  });

  group('SessionAuthAuto - Inicialização e Fluxo Básico', () {
    test('Não inicializado deve lançar exceção ao chamar métodos', () async {
      expect(() => SessionAuthAuto.getToken(), throwsA(isA<SessionNotInitializedException>()));
      expect(() => SessionAuthAuto.refresh(), throwsA(isA<SessionNotInitializedException>()));
    });

    test('Inicialização sem sessão anterior ativa', () async {
      await SessionAuthAuto.init(
        onLogin: (_) async => const AuthToken(accessToken: 'token'),
        onRefresh: (_) async => const AuthToken(accessToken: 'token'),
        database: database,
        secureStorage: secureStorage,
      );

      expect(SessionAuthAuto.isAuthenticated, isFalse);
      expect(SessionAuthAuto.currentUser, isNull);
    });

    test('setUser realiza login inicial e persiste dados', () async {
      int loginCalls = 0;
      await SessionAuthAuto.init(
        onLogin: (creds) async {
          loginCalls++;
          return AuthToken(
            accessToken: 'token_${creds.username}',
            refreshToken: 'refresh_123',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          );
        },
        onRefresh: (_) async => const AuthToken(accessToken: 'new_token'),
        database: database,
        secureStorage: secureStorage,
      );

      final user = AuthUser(
        id: 'user_1',
        credentials: const Credentials(username: 'user@test.com', password: 'password123'),
        metadata: {'name': 'User Test'},
      );

      await SessionAuthAuto.setUser(user);

      expect(loginCalls, 1);
      expect(SessionAuthAuto.isAuthenticated, isTrue);
      expect(SessionAuthAuto.currentUser?.id, 'user_1');
      expect(SessionAuthAuto.currentUser?.metadata['name'], 'User Test');

      final token = await SessionAuthAuto.getToken();
      expect(token, 'token_user@test.com');

      final activeUserId = await secureStorage.getActiveUserId();
      expect(activeUserId, 'user_1');
      final creds = await secureStorage.getCredentials('user_1');
      expect(creds?.username, 'user@test.com');

      final dbToken = await database.getActiveToken();
      expect(dbToken?.accessToken, 'token_user@test.com');
      expect(dbToken?.refreshToken, 'refresh_123');
    });
  });

  group('SessionAuthAuto - Renovação de Token (getToken / refresh)', () {
    test('getToken retorna token cached se não estiver expirado', () async {
      int loginCalls = 0;
      int refreshCalls = 0;

      await SessionAuthAuto.init(
        onLogin: (_) async {
          loginCalls++;
          return AuthToken(
            accessToken: 'token_initial',
            refreshToken: 'refresh_initial',
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
          );
        },
        onRefresh: (_) async {
          refreshCalls++;
          return const AuthToken(accessToken: 'token_refreshed');
        },
        database: database,
        secureStorage: secureStorage,
      );

      await SessionAuthAuto.setUser(AuthUser(
        id: 'user_1',
        credentials: const Credentials(username: 'test', password: 'pwd'),
        metadata: {},
      ));

      final t1 = await SessionAuthAuto.getToken();
      expect(t1, 'token_initial');
      expect(loginCalls, 1);
      expect(refreshCalls, 0);

      final t2 = await SessionAuthAuto.getToken();
      expect(t2, 'token_initial');
      expect(refreshCalls, 0);
    });

    test('getToken faz refresh automático se estiver expirado', () async {
      int refreshCalls = 0;

      await SessionAuthAuto.init(
        onLogin: (_) async {
          return AuthToken(
            accessToken: 'token_initial',
            refreshToken: 'refresh_initial',
            expiresAt: DateTime.now().subtract(const Duration(minutes: 5)),
          );
        },
        onRefresh: (rt) async {
          refreshCalls++;
          expect(rt, 'refresh_initial');
          return AuthToken(
            accessToken: 'token_refreshed',
            refreshToken: 'refresh_new',
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
          );
        },
        database: database,
        secureStorage: secureStorage,
      );

      await SessionAuthAuto.setUser(AuthUser(
        id: 'user_1',
        credentials: const Credentials(username: 'test', password: 'pwd'),
        metadata: {},
      ));

      final token = await SessionAuthAuto.getToken();
      expect(token, 'token_refreshed');
      expect(refreshCalls, 1);

      final token2 = await SessionAuthAuto.getToken();
      expect(token2, 'token_refreshed');
      expect(refreshCalls, 1);
    });

    test('Fallback de login se o refresh falhar', () async {
      int loginCalls = 0;
      int refreshCalls = 0;

      await SessionAuthAuto.init(
        onLogin: (creds) async {
          loginCalls++;
          return AuthToken(
            accessToken: 'token_login_$loginCalls',
            refreshToken: 'refresh_login',
            expiresAt: DateTime.now().subtract(const Duration(minutes: 5)),
          );
        },
        onRefresh: (_) async {
          refreshCalls++;
          throw Exception('Network error during refresh');
        },
        database: database,
        secureStorage: secureStorage,
        config: const SessionAuthAutoConfig(autoReloginOnRefreshFailure: true),
      );

      await SessionAuthAuto.setUser(AuthUser(
        id: 'user_1',
        credentials: const Credentials(username: 'test', password: 'pwd'),
        metadata: {},
      ));

      final token = await SessionAuthAuto.getToken();
      expect(token, 'token_login_2');
      expect(loginCalls, 2);
      expect(refreshCalls, 1);
    });
  });

  group('SessionAuthAuto - Auto-Refresh Proativo (Scheduler)', () {
    test('Scheduler executa auto-refresh se nextScheduledRefreshAt já passou', () async {
      int refreshCalls = 0;
      final now = DateTime.now();

      await secureStorage.saveActiveUserId('user_1');
      await secureStorage.saveCredentials('user_1', const Credentials(username: 'test', password: 'pwd'));
      await database.saveUserMetadata('user_1', {});
      await database.saveToken(AuthToken(
        accessToken: 'old_access_token',
        refreshToken: 'old_refresh_token',
        expiresAt: now.add(const Duration(hours: 10)),
        lastRefreshedAt: now.subtract(const Duration(hours: 25)),
        nextScheduledRefreshAt: now.subtract(const Duration(minutes: 10)),
      ));

      bool successCalled = false;
      await SessionAuthAuto.init(
        onLogin: (_) async => const AuthToken(accessToken: 'login_token'),
        onRefresh: (rt) async {
          refreshCalls++;
          return AuthToken(
            accessToken: 'refreshed_by_auto',
            refreshToken: 'new_rt',
            expiresAt: DateTime.now().add(const Duration(hours: 5)),
          );
        },
        database: database,
        secureStorage: secureStorage,
        config: SessionAuthAutoConfig(
          refreshIntervalHours: 12,
          onAutoRefreshSuccess: (token) {
            successCalled = true;
            expect(token.accessToken, 'refreshed_by_auto');
          },
        ),
      );

      expect(refreshCalls, 1);
      expect(successCalled, isTrue);
      expect(SessionAuthAuto.isAuthenticated, isTrue);

      final token = await SessionAuthAuto.getToken();
      expect(token, 'refreshed_by_auto');
    });

    test('Scheduler falha silenciosamente sem deslogar o usuário em erro de rede', () async {
      int refreshCalls = 0;
      final now = DateTime.now();

      await secureStorage.saveActiveUserId('user_1');
      await secureStorage.saveCredentials('user_1', const Credentials(username: 'test', password: 'pwd'));
      await database.saveUserMetadata('user_1', {});
      await database.saveToken(AuthToken(
        accessToken: 'existing_token',
        refreshToken: 'existing_rt',
        expiresAt: now.add(const Duration(hours: 10)),
        lastRefreshedAt: now.subtract(const Duration(hours: 25)),
        nextScheduledRefreshAt: now.subtract(const Duration(minutes: 10)),
      ));

      bool failureCalled = false;
      await SessionAuthAuto.init(
        onLogin: (_) async => const AuthToken(accessToken: 'login_token'),
        onRefresh: (_) async {
          refreshCalls++;
          throw Exception('No Internet connection');
        },
        database: database,
        secureStorage: secureStorage,
        config: SessionAuthAutoConfig(
          refreshIntervalHours: 24,
          autoReloginOnRefreshFailure: false,
          onAutoRefreshFailed: (err, stack) {
            failureCalled = true;
            expect(err.toString(), contains('No Internet connection'));
          },
        ),
      );

      expect(refreshCalls, 1);
      expect(failureCalled, isTrue);
      expect(SessionAuthAuto.isAuthenticated, isTrue);

      final token = await SessionAuthAuto.getToken();
      expect(token, 'existing_token');

      final nextScheduled = SessionAuthAuto.nextScheduledRefreshAt;
      expect(nextScheduled, isNotNull);
      expect(nextScheduled!.isAfter(DateTime.now().add(const Duration(hours: 23))), isTrue);
    });
  });

  group('SessionAuthAuto - Logout', () {
    test('logout limpa todos os dados', () async {
      await SessionAuthAuto.init(
        onLogin: (_) async => const AuthToken(accessToken: 'token'),
        onRefresh: (_) async => const AuthToken(accessToken: 'token'),
        database: database,
        secureStorage: secureStorage,
      );

      await SessionAuthAuto.setUser(AuthUser(
        id: 'user_1',
        credentials: const Credentials(username: 'user@test.com', password: 'pwd'),
        metadata: {'name': 'John'},
      ));

      expect(SessionAuthAuto.isAuthenticated, isTrue);

      await SessionAuthAuto.logout();

      expect(SessionAuthAuto.isAuthenticated, isFalse);
      expect(SessionAuthAuto.currentUser, isNull);

      expect(await secureStorage.getActiveUserId(), isNull);
      expect(await secureStorage.getCredentials('user_1'), isNull);
      expect(await database.getActiveToken(), isNull);
      expect(await database.getUserMetadata('user_1'), isNull);
    });
  });
}
