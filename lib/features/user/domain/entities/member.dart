// flutter 에서 사용하는 User 모델입니다.

import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/features/user/data/models/member.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class MemberInterface {
  final String memberId;
  final String oauthId;
  final String role;
  final String oauthProvider;
  final bool isDeleted;
  final ProfileInterface profile;
  final List<ChatRoom> roomList;
  MemberInterface(
      {required this.memberId,
      required this.oauthId,
      this.role = "USER",
      required this.oauthProvider,
      this.isDeleted = false,
      this.roomList = const [],
      required this.profile});

  // JSON 변환용 메서드
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'oauthId': oauthId,
      'role': role, // 열거형을 문자열로 저장
      'oauthProvider': oauthProvider,
      'isDeleted': isDeleted,
      'profile': profile.toJson()
    };
  }

  factory MemberInterface.fromJson(Map<String, dynamic> json) {
    return MemberInterface(
        memberId: json['memberId'] as String,
        oauthId: json['oauthId'] as String,
        role: json['role'] as String ?? 'USER',
        oauthProvider: json['oauthProvider'] as String,
        isDeleted: json['isDeleted'] as bool? ?? false,
        profile: ProfileInterface.fromJson(json['profile']));
  }

  // copyWith 메서드 추가
  MemberInterface copyWith(
      {String? memberId,
      String? oauthId,
      String? role,
      String? oauthProvider,
      bool? isDeleted,
      List<ChatRoom>? roomList,
      ProfileInterface? profile}) {
    return MemberInterface(
        memberId: memberId ?? this.memberId,
        oauthId: oauthId ?? this.oauthId,
        role: role ?? this.role,
        oauthProvider: oauthProvider ?? this.oauthProvider,
        isDeleted: isDeleted ?? this.isDeleted,
        roomList: roomList ?? this.roomList,
        profile: profile ?? this.profile);
  }

  factory MemberInterface.fromMermerModel(MemeberModel userModel) {
    return MemberInterface(
        memberId: userModel.memberId,
        oauthId: userModel.oauthId,
        role: userModel.role,
        oauthProvider: userModel.oauthProvider,
        isDeleted: userModel.isDeleted,
        profile: userModel.profile.toProfileInterface());
  }

  MemeberModel toMemberModel() {
    return MemeberModel(
        memberId: memberId,
        role: role,
        oauthId: oauthId,
        oauthProvider: oauthProvider,
        isDeleted: isDeleted,
        profile: profile.toProfileModel());
  }
}
