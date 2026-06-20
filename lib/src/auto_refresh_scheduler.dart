import 'config/session_auth_auto_config.dart';
import 'session_controller.dart';

class AutoRefreshScheduler {
  final SessionController _controller;
  final SessionAuthAutoConfig _config;

  AutoRefreshScheduler(this._controller, this._config);

  /// Chamado no init(). Verifica se o auto-refresh deve ser executado agora.
  Future<void> checkAndRun() async {
    if (!_controller.hasActiveSession) return;

    final token = _controller.currentToken;
    final lastRefreshed = token?.lastRefreshedAt;
    final nextScheduled = token?.nextScheduledRefreshAt;

    final now = DateTime.now();

    // Caso 1: nunca foi feito um auto-refresh → executar agora
    if (lastRefreshed == null) {
      await _runAutoRefresh();
      return;
    }

    // Caso 2: nextScheduledRefreshAt já passou → executar agora
    if (nextScheduled != null && now.isAfter(nextScheduled)) {
      await _runAutoRefresh();
      return;
    }

    // Caso 3: ainda dentro do intervalo → não fazer nada
  }

  Future<void> _runAutoRefresh() async {
    try {
      await _controller.refresh(triggeredBy: 'auto');
      final currentToken = _controller.currentToken;
      if (currentToken != null) {
        _config.onAutoRefreshSuccess?.call(currentToken);
      }
    } catch (error, stack) {
      // Falha silenciosa: mantém token atual, agenda próxima tentativa
      await _controller.scheduleNextRefresh();
      _config.onAutoRefreshFailed?.call(error, stack);
    }
  }
}
