import 'dart:developer';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/user/data/models/member.dart';
import 'package:chat_location/features/user/data/models/profile.dart';
import 'package:chat_location/features/user/domain/repositories/user_repository.dart';

// 실제 api 호출 로직이 작성되어있습니다.
const signupStatusCode = 31;

// api를 추가하고 싶으면 UserRepository 에서 함수 인터페이스 작성 후 작성할것!!!
class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl(this.apiClient);

  @override
  Future<MemeberModel> getUserProfile() async {
    try {
      final response = await apiClient.get(endpoint: '/user');
      // return UserModel.fromJson(response);
      throw Error;
    } catch (error, stackTrace) {
      log('Error in getUserProfile: $error', stackTrace: stackTrace);

      throw Exception('Failed to fetch user profile');
    }
  }

  @override
  Future<void> updateUser(ProfileModel user) async {
    try {
      final userJson = user.toJson();
      await apiClient.patch(endpoint: '/user', data: userJson, setToken: true);
    } catch (e) {
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
