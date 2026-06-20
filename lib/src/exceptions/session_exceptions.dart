class SessionNotInitializedException implements Exception {
  final String message;

  const SessionNotInitializedException([this.message = 'SessionAuthAuto.init() must be called before using the library.']);

  @override
  String toString() => 'SessionNotInitializedException: $message';
}

class NoActiveSessionException implements Exception {
  final String message;

  const NoActiveSessionException([this.message = 'No active session found. Call setUser() to authenticate a user first.']);

  @override
  String toString() => 'NoActiveSessionException: $message';
}

class SessionRefreshFailedException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? originalStackTrace;

  const SessionRefreshFailedException([
    this.message = 'Session refresh failed and recovery login fallback was unsuccessful.',
    this.originalError,
    this.originalStackTrace,
  ]);

  @override
  String toString() {
    if (originalError != null) {
      return 'SessionRefreshFailedException: $message. Original error: $originalError';
    }
    return 'SessionRefreshFailedException: $message';
  }
}

class InvalidTokenResponseException implements Exception {
  final String message;

  const InvalidTokenResponseException([this.message = 'Login or refresh callbacks returned an invalid or null token.']);

  @override
  String toString() => 'InvalidTokenResponseException: $message';
}
