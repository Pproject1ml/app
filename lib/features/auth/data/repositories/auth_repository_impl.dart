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
      log("api signIn : ${e.toString()}");
      throw '로그인에 실패하였습니다.';
    }
  }

  @override
  Future<dynamic> signUp(SignUpModel user) async {
    try {
      final response = await apiClient.post(
          endpoint: '/auth/signup', data: user.toJson(), setToken: true);
      log("loginuser : ${response.toString()}");
      if (response['data'] == null) {
        return null;
      }
      return jsonDecode(response);
    } catch (e) {
      log(e.toString());
      throw e.toString();
    }
  }
}
