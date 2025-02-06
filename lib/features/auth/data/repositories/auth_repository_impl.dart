import 'dart:convert';
import 'dart:developer';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/auth/data/models/oauth.dart';
import 'package:chat_location/features/auth/data/models/signup.dart';
import 'package:chat_location/features/auth/dmain/repositories/auth_repository.dart';
import 'package:chat_location/features/user/data/models/member.dart';

const signupStatusCode = 31;

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  AuthRepositoryImpl(this.apiClient);

  @override
  Future<MemeberModel> isJwtValid(String jwtToken) async {
    try {
      final Map<String, String> query = {'jwt': jwtToken};

      // api 수정 요청하기
      final response = await apiClient.get(
          endpoint: "/auth/check-jwt", queryParameters: query, withAuth: false);
      final res = MemeberModel.fromJson(response['data']);
      return res;
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw '유효하지 않은 토큰입니다';
    }
  }

  @override
  Future<bool> isFcmValid(String fcmToken, String profileId) async {
    try {
      final Map<String, String> query = {'id': profileId, "fcm": fcmToken};

      final response = await apiClient.get(
          endpoint: "/auth/check-fcm", queryParameters: query, withAuth: false);
      return true;
    } catch (e, s) {
      log(e.toString() + s.toString());
      return false;
    }
  }

  @override
  Future<void> saveFcmToken(String fcmToken) async {
    try {
      final Map<String, String> data = {
        'token': fcmToken,
      };

      final response = await apiClient.post(
        endpoint: "/fcm",
        data: data,
      );
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw 'fcm 토큰을 저장할 수 없습니다.';
    }
  }

  @override
  Future<bool> isNicknameValid(String nickname) async {
    try {
      final Map<String, String> data = {'nickname': nickname};

      // api 수정 요청하기
      await apiClient.post(endpoint: "/auth/check-nickname", data: data);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      final response = await apiClient.post(endpoint: '/logout');
    } catch (e) {
      log(e.toString());
      throw '로그아웃에 에 실패하였습니다.';
    }
  }

  @override
  Future<MemeberModel?> signIn(OauthModel user) async {
    try {
      final response = await apiClient.post(
          endpoint: '/auth/login', data: user.toJson(), setToken: true);
      final status = response['status'];
      if (status == signupStatusCode) {
        return null;
      }

      final res = MemeberModel.fromJson(response['data']);

      return res;
    } catch (e) {
      throw '로그인에 실패하였습니다.';
    }
  }

  @override
  Future<dynamic> signUp(SignUpModel user) async {
    try {
      final response = await apiClient.post(
          endpoint: '/auth/signup', data: user.toJson(), setToken: true);

      if (response['data'] == null) {
        return null;
      }
      return jsonDecode(response);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await apiClient.delete(endpoint: '/user');
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw '회원탈퇴를 하는데 오류가 발생하였습니다.';
    }
  }
}
