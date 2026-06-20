class Credentials {
  final String username;
  final String password;

  const Credentials({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  factory Credentials.fromJson(Map<String, dynamic> json) => Credentials(
        username: json['username'] as String,
        password: json['password'] as String,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Credentials &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          password == other.password;

  @override
  int get hashCode => username.hashCode ^ password.hashCode;

  @override
  String toString() => 'Credentials(username: $username)';
}
