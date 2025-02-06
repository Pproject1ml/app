import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // 암호화된 SharedPreferences 사용
    ),
  );
  static const String _authTokenKey = 'authToken';
  static const String _fcmTokenKey = "fcmToken";
  // 인증 토큰 저장
  static Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: _authTokenKey, value: token);
  }

  // 인증 토큰 가져오기
  static Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _authTokenKey);
  }

  // 인증 토큰 삭제
  static Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: _authTokenKey);
  }

  // 인증 토큰 저장
  static Future<void> saveFcmToken(String token) async {
    await _secureStorage.write(key: _fcmTokenKey, value: token);
  }

  // 인증 토큰 가져오기
  static Future<String?> getFcmToken() async {
    return await _secureStorage.read(key: _fcmTokenKey);
  }

  // 인증 토큰 삭제
  static Future<void> clearFcmToken() async {
    await _secureStorage.delete(key: _fcmTokenKey);
  }

  // 모든 데이터 삭제 (로그아웃 시)
  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
