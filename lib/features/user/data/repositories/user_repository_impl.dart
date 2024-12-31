import 'dart:developer';

import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/user/data/models/user_model.dart';
import 'package:chat_location/features/user/domain/entities/user.dart';
import 'package:chat_location/features/user/domain/repositories/user_repository.dart';

// 실제 api 호출 로직이 작성되어있습니다.
const signupStatusCode = 31;

// api를 추가하고 싶으면 UserRepository 에서 함수 인터페이스 작성 후 작성할것!!!
class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl(this.apiClient);

  Future<AppUser> getUserProfile() async {
    try {
      final response = await apiClient.get(endpoint: '/user');
      // return UserModel.fromJson(response);
      return AppUser(
          memberId: 'memberId',
          oauthId: "oauthId",
          nickname: "nickname",
          oauthProvider: "oauthProvider");
    } catch (error, stackTrace) {
      log('Error in getUserProfile: $error', stackTrace: stackTrace);

      throw Exception('Failed to fetch user profile');
    }
  }

  @override
  Future<AppUser?> signIn(Map<String, dynamic> body) async {
    try {
      final response = await apiClient.post(
          endpoint: 'auth/login', data: body, setToken: true);
      final status = response['status'];
      // signin
      if (status == signupStatusCode) {
        // 회원가입 폼으로 이동
        log("회원가입");
        return null;
      }
      // login
      final res = UserModel.fromJson(response['data']);
      final appUser = AppUser.fromUserModel(res);
      log("loginuser : ${response.toString()}");
      return appUser;
    } catch (error, stackTrace) {
      log('Error in signIn: $error', stackTrace: stackTrace);

      throw Exception('Failed to fetch user profile');
    }
  }

  @override
  Future<void> signUp(Map<String, dynamic> body) async {
    try {
      final response = await apiClient.post(
          endpoint: 'auth/signup', data: body, setToken: true);
      // login
      // final res = UserModel.fromJson(response['data']);
      // final appUser = AppUser.fromUserModel(res);
      log("loginuser : ${response.toString()}");
      return;
    } catch (error, stackTrace) {
      log('Error in getUserProfile: $error', stackTrace: stackTrace);

      throw Exception('Failed to fetch user profile');
    }
  }

  @override
  Future<void> updateUser(AppUser user) async {
    try {
      final userJson = user.toJson();
      log("user Info: ${userJson}");
      final response = await apiClient.patch(
          endpoint: 'user', data: userJson, setToken: true);
      log("updateuser : ${response.toString()}");
    } catch (error, stackTrace) {
      log('Error in getUserProfile: $error', stackTrace: stackTrace);

      throw Exception('Failed to fetch user profile');
    }
  }
}
