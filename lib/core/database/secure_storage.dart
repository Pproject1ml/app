import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _secureStorage = FlutterSecureStorage();
  static const String _authTokenKey = 'authToken';

  // 인증 토큰 저장
  static Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: _authTokenKey, value: token);
    log('Auth token saved in secure storage');
  }

  // 인증 토큰 가져오기
  static Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _authTokenKey);
  }

  // 인증 토큰 삭제
  static Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: _authTokenKey);
    log('Auth token removed from secure storage');
  }

  // 모든 데이터 삭제 (로그아웃 시)
  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    log('All secure storage data cleared');
  }
}
