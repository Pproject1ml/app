import 'dart:convert';
import 'dart:developer';

import 'package:chat_location/features/user/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;
  static const String _userKey = 'user';

  // 초기화 메서드
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    log('shared preferenceinitial 완료');
  }

  // 로그인 상태 설정
  static Future<void> setIsLoggedIn(bool value) async {
    await _prefs.setBool('isLoggedIn', value);
  }

  // 로그인 상태 가져오기
  static bool getIsLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false; // 기본값은 false
  }

  // 로그아웃 시 모든 데이터 삭제
  static Future<void> clear() async {
    await _prefs.remove('isLoggedIn');

    await clearUser();
  }

  static Future<void> saveUser(AppUser user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  static Future<AppUser?> loadUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return AppUser.fromJson(jsonDecode(userJson));
  }

  static Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
}
