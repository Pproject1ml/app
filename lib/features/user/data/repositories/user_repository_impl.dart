import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/user/data/models/member.dart';
import 'package:chat_location/features/user/data/models/profile.dart';
import 'package:chat_location/features/user/domain/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

// 실제 api 호출 로직이 작성되어있습니다.
const signupStatusCode = 31;

// api를 추가하고 싶으면 UserRepository 에서 함수 인터페이스 작성 후 작성할것!!!
class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl(this.apiClient);

  @override
  Future<ProfileModel> getUserProfile() async {
    try {
      final response = await apiClient.get(endpoint: '/user');
      return ProfileModel.fromJson(response);
    } catch (error, stackTrace) {
      throw Exception('Failed to fetch user profile');
    }
  }

  @override
  Future<ProfileModel> updateUser(
      {required ProfileModel user, XFile? profileImage}) async {
    try {
      Map<String, dynamic> rawData = {
        "profile": MultipartFile.fromString(
          jsonEncode(user.toJson()),
          contentType: MediaType.parse('application/json'),
        ),
      };
      if (profileImage != null) {
        rawData['profileImage'] = await MultipartFile.fromFile(
            File(profileImage.path).path,
            filename: "userProfileImage",
            contentType: MediaType.parse('image/jpeg'));
      }
      final data = FormData.fromMap(rawData);

      final res =
          await apiClient.multipartPatch(endpoint: '/user', formdata: data);

      return ProfileModel.fromJson(res);
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw "유저업데이트에 실패하였습니다.";
    }
  }

  @override
  Future<List<ChatRoomHiveModel>> fetchRoomList() {
    // TODO: implement fetchRoomList
    throw UnimplementedError();
  }

  @override
  Future<MemeberModel> fetchUser() {
    // TODO: implement fetchUser
    throw UnimplementedError();
  }
}
