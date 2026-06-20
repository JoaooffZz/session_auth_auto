import 'dart:async';

import 'auto_refresh_scheduler.dart';
import 'config/session_auth_auto_config.dart';
import 'database/session_database.dart';
import 'exceptions/session_exceptions.dart';
import 'models/auth_token.dart';
import 'models/auth_user.dart';
import 'models/credentials.dart';
import 'storage/secure_credential_storage.dart';
import 'session_controller.dart';

class SessionAuthAuto {
  static SessionController? _controller;
  static bool _initialized = false;

  /// Inicializa a biblioteca, carregando o estado anterior e agendando/checando o auto-refresh.
  static Future<void> init({
    required Future<AuthToken> Function(Credentials credentials) onLogin,
    required Future<AuthToken> Function(String refreshToken) onRefresh,
    SessionAuthAutoConfig config = const SessionAuthAutoConfig(),
    SessionDatabase? database,
    SecureCredentialStorage? secureStorage,
  }) async {
    final db = database ?? SessionDatabase.create(databaseName: config.databaseName);
    final storage = secureStorage ?? SecureCredentialStorage();

    final controller = SessionController(
      db: db,
      secureStorage: storage,
      onLogin: onLogin,
      onRefresh: onRefresh,
      config: config,
    );

    await controller.load();
    _controller = controller;

    final scheduler = AutoRefreshScheduler(controller, config);
    await scheduler.checkAndRun();

    _initialized = true;
  }

  static SessionController _getController() {
    if (!_initialized || _controller == null) {
      throw const SessionNotInitializedException();
    }
    return _controller!;
  }

  /// Retorna o token de acesso ativo. Se estiver expirado (aplicando o buffer configurado),
  /// tenta renová-lo silenciosamente antes de retornar.
  static Future<String> getToken() {
    return _getController().getToken();
  }

  /// Renova manualmente a sessão atual usando o refresh token (ou login de fallback).
  static Future<void> refresh() {
    return _getController().refresh(triggeredBy: 'manual');
  }

  /// Define o usuário ativo atual (fazendo login inicial e persistindo credenciais e metadados).
  static Future<void> setUser(AuthUser user) {
    return _getController().setUser(user);
  }

  /// Encerra a sessão ativa, limpando todos os dados da memória, do banco local e do Secure Storage.
  static Future<void> logout() {
    return _getController().logout();
  }

  /// Retorna o usuário autenticado atualmente, ou `null` caso não haja sessão ativa.
  static AuthUser? get currentUser {
    if (!_initialized) return null;
    return _controller?.currentUser;
  }

  /// Indica se há um usuário autenticado ativo no momento.
  static bool get isAuthenticated {
    if (!_initialized) return false;
    return _controller?.hasActiveSession ?? false;
  }

  /// Horário agendado para o próximo auto-refresh proativo de segurança.
  static DateTime? get nextScheduledRefreshAt {
    if (!_initialized) return null;
    return _controller?.nextScheduledRefreshAt;
  }

  /// Data/hora do último refresh realizado com sucesso.
  static DateTime? get lastRefreshedAt {
    if (!_initialized) return null;
    return _controller?.lastRefreshedAt;
  }

  /// Retorna os logs de refresh do banco local para auditoria ou depuração na UI.
  static Future<List<RefreshLog>> getRefreshLogs() async {
    if (!_initialized) return [];
    return _getController().getRefreshLogs();
  }

  /// Reseta o estado interno de inicialização. Útil para testes unitários.
  static void reset() {
    _controller = null;
    _initialized = false;
  }
}
