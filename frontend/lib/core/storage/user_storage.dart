import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveUser({
    required String fullName,
    required String email,
    required int role,
  }) async {
    await _storage.write(key: 'fullName', value: fullName);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'role', value: role.toString());
  }

  static Future<String?> getFullName() async {
    return _storage.read(key: 'fullName');
  }
}
