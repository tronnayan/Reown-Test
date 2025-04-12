import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../features/auth/models/auth_response.dart';

class StorageService {
  static const _authKey = 'auth_data';
  static final _storage = FlutterSecureStorage();

  // Save auth data
  static Future<void> saveAuthData(AuthResponse authData) async {
    await _storage.write(
      key: _authKey,
      value: jsonEncode(authData.toJson()),
    );
    log('🟣 StorageService: Saved auth data: ${authData.toJson()}');
  }

  // Get saved auth data
  static Future<AuthResponse?> getAuthData() async {
    final data = await _storage.read(key: _authKey);
    log('🟣 StorageService: Get auth data: $data');
    if (data != null) {
      return AuthResponse.fromJson(jsonDecode(data));
    }
    return null;
  }

  // Clear auth data
  static Future<void> clearAuthData() async {
    await _storage.delete(key: _authKey);
  }
}
