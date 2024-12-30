// flutter 에서 사용하는 User 모델입니다.
import 'package:chat_location/features/user/data/models/user_model.dart';

class AppUser {
  final String memberId;
  final String oauthId;
  final String nickname;
  final String? email;
  final String? profileImage;
  final String? introduction;
  final int? age;
  final String? gender;
  final String role;
  final String oauthProvider;
  final bool isDeleted;

  AppUser({
    required this.memberId,
    required this.oauthId,
    required this.nickname,
    this.email,
    this.profileImage,
    this.introduction,
    this.age,
    this.gender,
    this.role = "USER",
    required this.oauthProvider,
    this.isDeleted = false,
  });

  // JSON 변환용 메서드
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'oauthId': oauthId,
      'nickname': nickname,
      'email': email,
      'profileImage': profileImage,
      'introduction': introduction,
      'age': age,
      'gender': gender,
      'role': role, // 열거형을 문자열로 저장
      'oauthProvider': oauthProvider,
      'isDeleted': isDeleted,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      memberId: json['memberId'] as String,
      oauthId: json['oauthId'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      introduction: json['introduction'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      role: json['role'] as String ?? 'USER',
      oauthProvider: json['oauthProvider'] as String,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  // copyWith 메서드 추가
  AppUser copyWith({
    String? memberId,
    String? oauthId,
    String? nickname,
    String? email,
    String? profileImage,
    String? introduction,
    int? age,
    String? gender,
    String? role,
    String? oauthProvider,
    bool? isDeleted,
  }) {
    return AppUser(
      memberId: memberId ?? this.memberId,
      oauthId: oauthId ?? this.oauthId,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      introduction: introduction ?? this.introduction,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      oauthProvider: oauthProvider ?? this.oauthProvider,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  factory AppUser.fromUserModel(UserModel userModel) {
    return AppUser(
      memberId: userModel.memberId,
      oauthId: userModel.oauthId,
      nickname: userModel.nickname,
      email: userModel.email,
      profileImage: userModel.profileImage,
      introduction: userModel.introduction,
      age: userModel.age,
      gender: userModel.gender,
      role: userModel.role,
      oauthProvider: userModel.oauthProvider,
      isDeleted: userModel.isDeleted,
    );
  }

  UserModel toUserModel(DateTime createdAt, DateTime updatedAt) {
    return UserModel(
      memberId: memberId,
      nickname: nickname,
      email: email,
      profileImage: profileImage,
      introduction: introduction,
      age: age,
      gender: gender,
      role: role,
      oauthId: oauthId,
      oauthProvider: oauthProvider,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }
}
