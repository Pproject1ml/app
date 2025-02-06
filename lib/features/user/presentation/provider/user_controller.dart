import 'dart:developer';
import 'dart:io';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/shared_preference.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/user/data/repositories/user_repository_impl.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController extends StateNotifier<MemberInterface?> {
  final UserRepositoryImpl userRepository;

  UserController(this.userRepository) : super(null);

  void setUser(MemberInterface user) {
    state = user;
  }

  Future<void> updateUserInfo(
      {required MemberInterface profileInfo, XFile? profileImage}) async {
    assert(state != null);
    try {
      // 유저 정보 변경 api
      final res = await userRepository.updateUser(
          user: profileInfo.profile.toProfileModel(),
          profileImage: profileImage);

      final ProfileInterface _savedUser =
          ProfileInterface.fromProfileModel(res);

      // 기존 유저 정보를 복사하면서 새로운 정보를 업데이트

      final updatedUser = state!.copyWith(profile: _savedUser);
      // SharedPreferences에 업데이트된 유저 저장
      await SharedPreferencesHelper.saveUser(updatedUser);

      // 상태 업데이트
      state = state!.copyWith(profile: _savedUser);
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw "user 정보 변경에 실패하였습니다.";
    }
  }

  Future<void> fetchUser() async {
    try {
      final res = await userRepository.fetchUser();
    } catch (e) {
      throw "유저정보를 가져오는데 실패하였습니다";
    }
  }

  Future<void> fetchRoomList() async {
    assert(state != null);
    try {
      final res = await userRepository.fetchRoomList();
      // roomList lastMessage, 등...
      state = state!.copyWith(roomList: res);
    } catch (e) {
      throw "채팅방 정보를 가져오는데 실패하였습니다";
    }
  }
}

final userProvider =
    StateNotifierProvider<UserController, MemberInterface?>((ref) {
  final userRepository = ref.read(userRepositoryProvider);

  ref.onDispose(
    () {},
  );
  return UserController(userRepository);
});

// base Url입력하면 됩니다.
final apiClientProvider =
    Provider((ref) => ApiClient(BASE_URL, HTTPS_BASE_URL));

// user 관련 provider
final userRepositoryProvider =
    Provider((ref) => UserRepositoryImpl(ref.read(apiClientProvider)));
