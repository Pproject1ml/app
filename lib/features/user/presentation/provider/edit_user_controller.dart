import 'dart:developer';

import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileNotifier extends StateNotifier<MemberInterface> {
  late final TextEditingController nicknameController;
  late final FocusNode nickNameFocusNode;
  late final TextEditingController descriptionController;
  late final FocusNode descriptionFocusNode;
  UserProfileNotifier(MemberInterface initialUser) : super(initialUser) {
    nicknameController =
        TextEditingController(text: initialUser.profile.nickname);
    descriptionController =
        TextEditingController(text: initialUser.profile.introduction);
    nicknameController.addListener(_nickeNameEventListener);
    descriptionController.addListener(_descriptionEventListener);

    nickNameFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
  }
  @override
  void dispose() {
    nicknameController.dispose();
    descriptionController.dispose();
    nicknameController.removeListener(_nickeNameEventListener);
    descriptionController.removeListener(_descriptionEventListener);
    nickNameFocusNode.dispose();
    descriptionFocusNode.dispose();
    log("dispose");
    super.dispose();
  }

  void _nickeNameEventListener() {
    updateName(nicknameController.text);
  }

  void _descriptionEventListener() {
    updateIntroduction(descriptionController.text);
  }

  // 이름 업데이트
  void updateName(String nickname) {
    ProfileInterface _profile = state.profile;
    _profile = _profile.copyWith(nickname: nickname);
    state = state.copyWith(profile: _profile);
  }

  // 사진 URL 업데이트
  void updatePhoto(String photoUrl) {
    ProfileInterface _profile = state.profile;
    _profile = _profile.copyWith(profileImage: photoUrl);
    state = state.copyWith(profile: _profile);
  }

  // 성별 공개 여부 업데이트
  void toggleGenderVisibility(bool isVisible) {
    ProfileInterface _profile = state.profile;
    _profile = _profile.copyWith(isVisible: isVisible);
    state = state.copyWith(profile: _profile);
  }

  // 랜드마크 공개 여부 업데이트
  void toggleLandmarkVisibility(bool isVisible) {
    // state = state.copyWith(isLandmarkVisible: isVisible);
  }

  // 한줄 소개 업데이트
  void updateIntroduction(String introduction) {
    ProfileInterface _profile = state.profile;
    _profile = _profile.copyWith(introduction: introduction);
    state = state.copyWith(profile: _profile);
  }
}

final userProfileProvider = StateNotifierProvider.autoDispose
    .family<UserProfileNotifier, MemberInterface, MemberInterface>(
  (ref, initialUser) {
    return UserProfileNotifier(initialUser);
  },
);
