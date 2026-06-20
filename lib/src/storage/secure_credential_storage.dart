import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/credentials.dart';

class SecureCredentialStorage {
  final FlutterSecureStorage _storage;

  SecureCredentialStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _keyCredentialsPrefix = 'session_auth_auto_credentials_';
  static const String _keyActiveUserId = 'session_auth_auto_active_user_id';

  Future<void> saveCredentials(String userId, Credentials credentials) async {
    final jsonStr = json.encode(credentials.toJson());
    await _storage.write(key: '$_keyCredentialsPrefix$userId', value: jsonStr);
  }

  Future<Credentials?> getCredentials(String userId) async {
    final jsonStr = await _storage.read(key: '$_keyCredentialsPrefix$userId');
    if (jsonStr == null) return null;
    try {
      final Map<String, dynamic> decoded = json.decode(jsonStr) as Map<String, dynamic>;
      return Credentials.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteCredentials(String userId) async {
    await _storage.delete(key: '$_keyCredentialsPrefix$userId');
  }

  Future<void> saveActiveUserId(String userId) async {
    await _storage.write(key: _keyActiveUserId, value: userId);
  }

  Future<String?> getActiveUserId() async {
    return await _storage.read(key: _keyActiveUserId);
  }

  Future<void> deleteActiveUserId() async {
    await _storage.delete(key: _keyActiveUserId);
  }

  Future<void> clearAll() async {
    final allKeys = await _storage.readAll();
    for (final key in allKeys.keys) {
      if (key.startsWith(_keyCredentialsPrefix) || key == _keyActiveUserId) {
        await _storage.delete(key: key);
      }
    }
  }
}
