class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final DateTime? lastRefreshedAt;
  final DateTime? nextScheduledRefreshAt;

  const AuthToken({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.lastRefreshedAt,
    this.nextScheduledRefreshAt,
  });

  /// Verifica se o token está expirado, aplicando um buffer de segurança (`clockSkewSeconds`).
  bool isExpired({int clockSkewSeconds = 30}) {
    if (expiresAt == null) return false;
    return DateTime.now()
        .add(Duration(seconds: clockSkewSeconds))
        .isAfter(expiresAt!);
  }

  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    DateTime? lastRefreshedAt,
    DateTime? nextScheduledRefreshAt,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
      nextScheduledRefreshAt: nextScheduledRefreshAt ?? this.nextScheduledRefreshAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthToken &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken &&
          expiresAt == other.expiresAt &&
          lastRefreshedAt == other.lastRefreshedAt &&
          nextScheduledRefreshAt == other.nextScheduledRefreshAt;

  @override
  int get hashCode =>
      accessToken.hashCode ^
      refreshToken.hashCode ^
      expiresAt.hashCode ^
      lastRefreshedAt.hashCode ^
      nextScheduledRefreshAt.hashCode;

  @override
  String toString() {
    return 'AuthToken(accessToken: ${accessToken.substring(0, Math.min(10, accessToken.length))}..., refreshToken: ${refreshToken != null ? "present" : "null"}, expiresAt: $expiresAt, lastRefreshedAt: $lastRefreshedAt, nextScheduledRefreshAt: $nextScheduledRefreshAt)';
  }
}

// Pequeno helper para evitar importação do dart:math apenas para Math.min
class Math {
  static int min(int a, int b) => a < b ? a : b;
}
