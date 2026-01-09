import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  static const _storage = FlutterSecureStorage();
  static const _userIdKey = 'userId';
  static const _fullNameKey = 'fullName';
  static const _emailKey = 'email';
  static const _roleKey = 'role';

  static Future<void> saveUser({
    required int userId,
    required String fullName,
    required String email,
    required int role,
  }) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(key: _fullNameKey, value: fullName);
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _roleKey, value: role.toString());
  }

  static Future<int?> getUserId() async {
    final v = await _storage.read(key: _userIdKey);
    if (v == null) return null;
    return int.tryParse(v);
  }

  static Future<String?> getFullName() async {
    return _storage.read(key: _fullNameKey);
  }
}
