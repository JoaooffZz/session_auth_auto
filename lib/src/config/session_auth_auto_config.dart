import '../models/auth_token.dart';

class SessionAuthAutoConfig {
  /// Intervalo em horas entre cada auto-refresh proativo.
  /// Default: 24
  final int refreshIntervalHours;

  /// Buffer em segundos antes de expiresAt para considerar o token expirado.
  /// Default: 30
  final int tokenExpiryBufferSeconds;

  /// Se true, ao falhar o refresh, tenta re-login com credentials como fallback.
  /// Default: true
  final bool autoReloginOnRefreshFailure;

  /// Callback chamado quando o auto-refresh falha (sem internet, servidor fora, etc).
  /// O token atual é mantido e o próximo auto-refresh é agendado para
  /// DateTime.now() + refreshIntervalHours.
  /// Default: null (silencioso)
  final void Function(Object error, StackTrace stackTrace)? onAutoRefreshFailed;

  /// Callback chamado quando o auto-refresh é bem-sucedido.
  /// Útil para logging ou atualização de UI.
  /// Default: null
  final void Function(AuthToken newToken)? onAutoRefreshSuccess;

  /// Número máximo de entradas mantidas na tabela refresh_log.
  /// Default: 50
  final int maxRefreshLogEntries;

  /// Nome do arquivo SQLite.
  /// Default: 'session_auth_auto.sqlite'
  final String databaseName;

  const SessionAuthAutoConfig({
    this.refreshIntervalHours = 24,
    this.tokenExpiryBufferSeconds = 30,
    this.autoReloginOnRefreshFailure = true,
    this.onAutoRefreshFailed,
    this.onAutoRefreshSuccess,
    this.maxRefreshLogEntries = 50,
    this.databaseName = 'session_auth_auto.sqlite',
  });
}
