import 'dart:developer';

import 'package:chat_location/features/user/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileNotifier extends StateNotifier<AppUser> {
  UserProfileNotifier(AppUser initialUser) : super(initialUser);

  // 이름 업데이트
  void updateName(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  // 사진 URL 업데이트
  void updatePhoto(String photoUrl) {
    state = state.copyWith(profileImage: photoUrl);
  }

  // 성별 공개 여부 업데이트
  void toggleGenderVisibility(bool isVisible) {
    // state = state.copyWith(isGenderVisible: isVisible);
  }

  // 랜드마크 공개 여부 업데이트
  void toggleLandmarkVisibility(bool isVisible) {
    // state = state.copyWith(isLandmarkVisible: isVisible);
  }

  // 한줄 소개 업데이트
  void updateIntroduction(String introduction) {
    state = state.copyWith(introduction: introduction);
  }
}

final userProfileProvider = StateNotifierProvider.autoDispose
    .family<UserProfileNotifier, AppUser, AppUser>(
  (ref, initialUser) {
    log("provider start");
    ref.onDispose(
      () => {log("dispose provider")},
    );
    return UserProfileNotifier(initialUser);
  },
);
