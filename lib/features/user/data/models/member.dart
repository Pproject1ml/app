//DB 에서 사용하는 유저이 모델입니다.
import 'package:chat_location/features/user/data/models/profile.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';

class MemeberModel {
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String memberId;
  final String oauthId;
  final String oauthProvider;
  final String role;
  final ProfileModel profile;

  MemeberModel({
    required this.memberId,
    required this.role,
    required this.oauthId,
    required this.oauthProvider,
    this.createdAt,
    this.updatedAt,
    required this.isDeleted,
    required this.profile,
  });

  // JSON 데이터를 UserModel 객체로 변환
  factory MemeberModel.fromJson(Map<String, dynamic> json) {
    return MemeberModel(
        memberId: json['memberId'] as String,
        role: json['role'] as String,
        oauthId: json['oauthId'] as String,
        oauthProvider: json['oauthProvider'] as String,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        isDeleted: json['isDeleted'] as bool,
        profile: ProfileModel.fromJson(json['profile']));
  }

  // UserModel 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'role': role,
      'oauthId': oauthId,
      'oauthProvider': oauthProvider,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'profile': profile.toJson()
    };
  }

  // copyWith 메서드 (객체 복사와 업데이트를 위한 메서드)

  MemeberModel copyWith(
      {String? memberId,
      String? role,
      String? oauthId,
      String? oauthProvider,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isDeleted,
      ProfileModel? profile}) {
    return MemeberModel(
        memberId: memberId ?? this.memberId,
        role: role ?? this.role,
        oauthId: oauthId ?? this.oauthId,
        oauthProvider: oauthProvider ?? this.oauthProvider,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
        profile: profile ?? this.profile);
  }

  // data -> entitiy 변환

  MemberInterface toMemberInterface() {
    return MemberInterface(
        memberId: memberId,
        oauthId: oauthId,
        oauthProvider: oauthProvider,
        profile: profile.toProfileInterface());
  }
}
