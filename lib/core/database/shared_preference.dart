import 'dart:convert';
import 'dart:developer';

import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;
  static const String _userKey = 'user';

  // 초기화 메서드
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    log('shared preferenceinitial 완료');
  }

  // 로그아웃 시 모든 데이터 삭제
  static Future<void> clear() async {
    await clearUser();
  }

  static Future<void> saveUser(MemberInterface user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  static Future<MemberInterface?> loadUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return MemberInterface.fromJson(jsonDecode(userJson));
  }

  static Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
}
