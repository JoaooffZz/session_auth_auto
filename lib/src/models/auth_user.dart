import 'credentials.dart';

class AuthUser {
  final String id;
  final Credentials credentials;
  final Map<String, String> metadata;

  const AuthUser({
    required this.id,
    required this.credentials,
    required this.metadata,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          credentials == other.credentials &&
          _mapEquals(metadata, other.metadata);

  @override
  int get hashCode => id.hashCode ^ credentials.hashCode ^ metadata.hashCode;

  @override
  String toString() => 'AuthUser(id: $id, metadata: $metadata)';

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (b[key] != a[key]) return false;
    }
    return true;
  }
}
