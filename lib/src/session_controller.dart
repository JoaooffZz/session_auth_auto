import 'dart:async';

import 'config/session_auth_auto_config.dart';
import 'database/session_database.dart';
import 'exceptions/session_exceptions.dart';
import 'models/auth_token.dart';
import 'models/auth_user.dart';
import 'models/credentials.dart';
import 'storage/secure_credential_storage.dart';

class SessionController {
  final SessionDatabase _db;
  final SecureCredentialStorage _secureStorage;
  final Future<AuthToken> Function(Credentials) _onLogin;
  final Future<AuthToken> Function(String) _onRefresh;
  final SessionAuthAutoConfig _config;

  AuthUser? _currentUser;
  AuthToken? _currentToken;

  SessionController({
    required SessionDatabase db,
    required SecureCredentialStorage secureStorage,
    required Future<AuthToken> Function(Credentials) onLogin,
    required Future<AuthToken> Function(String) onRefresh,
    required SessionAuthAutoConfig config,
  })  : _db = db,
        _secureStorage = secureStorage,
        _onLogin = onLogin,
        _onRefresh = onRefresh,
        _config = config;

  bool get hasActiveSession => _currentUser != null;
  AuthUser? get currentUser => _currentUser;
  AuthToken? get currentToken => _currentToken;
  DateTime? get lastRefreshedAt => _currentToken?.lastRefreshedAt;
  DateTime? get nextScheduledRefreshAt => _currentToken?.nextScheduledRefreshAt;

  /// Carrega o estado a partir do Drift e do Secure Storage.
  Future<void> load() async {
    final activeUserId = await _secureStorage.getActiveUserId();
    if (activeUserId == null) {
      _currentUser = null;
      _currentToken = null;
      return;
    }

    final credentials = await _secureStorage.getCredentials(activeUserId);
    if (credentials == null) {
      await logout();
      return;
    }

    final metadata = await _db.getUserMetadata(activeUserId) ?? {};
    _currentUser = AuthUser(
      id: activeUserId,
      credentials: credentials,
      metadata: metadata,
    );

    _currentToken = await _db.getActiveToken();
  }

  /// Retorna o token de acesso. Se expirado, executa refresh ou re-login.
  Future<String> getToken() async {
    if (!hasActiveSession) {
      throw const NoActiveSessionException();
    }

    final token = _currentToken;
    if (token == null) {
      await refresh(triggeredBy: 'expiry');
    } else if (token.isExpired(clockSkewSeconds: _config.tokenExpiryBufferSeconds)) {
      await refresh(triggeredBy: 'expiry');
    }

    final finalToken = _currentToken;
    if (finalToken == null) {
      throw const SessionRefreshFailedException('No valid token retrieved.');
    }
    return finalToken.accessToken;
  }

  /// Executa o refresh do token.
  Future<void> refresh({String triggeredBy = 'manual'}) async {
    if (!hasActiveSession) {
      throw const NoActiveSessionException();
    }

    final user = _currentUser!;
    final token = _currentToken;

    try {
      AuthToken newToken;
      if (token?.refreshToken != null) {
        try {
          newToken = await _onRefresh(token!.refreshToken!);
        } catch (e) {
          if (_config.autoReloginOnRefreshFailure) {
            newToken = await _doLogin(user.credentials);
          } else {
            rethrow;
          }
        }
      } else {
        newToken = await _doLogin(user.credentials);
      }

      final now = DateTime.now();
      final updatedToken = newToken.copyWith(
        lastRefreshedAt: now,
        nextScheduledRefreshAt: now.add(Duration(hours: _config.refreshIntervalHours)),
      );

      await _persistToken(updatedToken, triggeredBy: triggeredBy);
      await _db.insertRefreshLog(triggeredBy, true, null, maxLogEntries: _config.maxRefreshLogEntries);
    } catch (e, stack) {
      await _db.insertRefreshLog(triggeredBy, false, e.toString(), maxLogEntries: _config.maxRefreshLogEntries);
      if (triggeredBy == 'auto') {
        rethrow;
      }
      throw SessionRefreshFailedException(
        'Failed to refresh session token. Triggered by: $triggeredBy',
        e,
        stack,
      );
    }
  }

  Future<AuthToken> _doLogin(Credentials credentials) async {
    final token = await _onLogin(credentials);
    return token;
  }

  Future<void> _persistToken(AuthToken token, {required String triggeredBy}) async {
    _currentToken = token;
    await _db.saveToken(token);
  }

  /// Salva o próximo auto-refresh sem alterar o last_refreshed_at (ex. quando falha o auto-refresh).
  Future<void> scheduleNextRefresh() async {
    final token = _currentToken;
    if (token != null) {
      final updatedToken = token.copyWith(
        nextScheduledRefreshAt: DateTime.now().add(Duration(hours: _config.refreshIntervalHours)),
      );
      await _persistToken(updatedToken, triggeredBy: 'auto_reschedule');
    }
  }

  /// Define um novo usuário ativo e executa o login inicial.
  Future<void> setUser(AuthUser user) async {
    await logout();

    await _secureStorage.saveActiveUserId(user.id);
    await _secureStorage.saveCredentials(user.id, user.credentials);
    await _db.saveUserMetadata(user.id, user.metadata);

    _currentUser = user;

    try {
      final token = await _doLogin(user.credentials);
      final now = DateTime.now();
      final updatedToken = token.copyWith(
        lastRefreshedAt: now,
        nextScheduledRefreshAt: now.add(Duration(hours: _config.refreshIntervalHours)),
      );

      await _persistToken(updatedToken, triggeredBy: 'set_user');
      await _db.insertRefreshLog('set_user', true, null, maxLogEntries: _config.maxRefreshLogEntries);
    } catch (e) {
      await _db.insertRefreshLog('set_user', false, e.toString(), maxLogEntries: _config.maxRefreshLogEntries);
      await logout();
      throw SessionRefreshFailedException('Initial login failed during setUser()', e);
    }
  }

  /// Logout completo.
  Future<void> logout() async {
    final activeUserId = _currentUser?.id ?? await _secureStorage.getActiveUserId();
    
    _currentUser = null;
    _currentToken = null;

    if (activeUserId != null) {
      await _secureStorage.deleteCredentials(activeUserId);
      await _db.deleteUserMetadata(activeUserId);
    }
    await _secureStorage.deleteActiveUserId();
    await _db.deleteToken();
  }

  /// Retorna os logs de refresh do banco local.
  Future<List<RefreshLog>> getRefreshLogs() {
    return _db.getRefreshLogs();
  }
}
