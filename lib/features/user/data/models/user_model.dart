//DB 에서 사용하는 유저이 모델입니다.
import 'package:chat_location/features/user/domain/entities/user.dart';

class UserModel {
  final String memberId;
  final String nickname;
  final String? email;
  final String? profileImage;
  final String? introduction;
  final int? age;
  final String? gender;
  final String role;
  final String oauthId;
  final String oauthProvider;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVisible;
  final bool isDeleted;

  UserModel({
    required this.memberId,
    required this.nickname,
    this.email,
    this.profileImage,
    this.introduction,
    this.age,
    this.gender,
    required this.role,
    required this.oauthId,
    required this.oauthProvider,
    required this.createdAt,
    required this.updatedAt,
    required this.isVisible,
    required this.isDeleted,
  });

  // JSON 데이터를 UserModel 객체로 변환
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      memberId: json['memberId'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      introduction: json['introduction'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      role: json['role'] as String,
      oauthId: json['oauthId'] as String,
      oauthProvider: json['oauthProvider'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isVisible: json['isVisible'] as bool,
      isDeleted: json['isDeleted'] as bool,
    );
  }

  // UserModel 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': memberId,
      'nickname': nickname,
      'email': email,
      'profileImage': profileImage,
      'introduction': introduction,
      'age': age,
      'gender': gender,
      'role': role,
      'oauthId': oauthId,
      'oauthProvider': oauthProvider,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isVisible': isVisible,
      'isDeleted': isDeleted,
    };
  }

  // copyWith 메서드 (객체 복사와 업데이트를 위한 메서드)

  UserModel copyWith({
    String? memberId,
    String? nickname,
    String? email,
    String? profileImage,
    String? introduction,
    int? age,
    String? gender,
    String? role,
    String? oauthId,
    String? oauthProvider,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVisible,
    bool? isDeleted,
  }) {
    return UserModel(
      memberId: memberId ?? this.memberId,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      introduction: introduction ?? this.introduction,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      oauthId: oauthId ?? this.oauthId,
      oauthProvider: oauthProvider ?? this.oauthProvider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVisible: isVisible ?? this.isVisible,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  AppUser toAppUser() {
    return AppUser(
      memberId: memberId,
      oauthId: oauthId,
      nickname: nickname,
      email: email,
      profileImage: profileImage,
      introduction: introduction,
      age: age,
      gender: gender,
      role: role,
      oauthProvider: oauthProvider,
      isVisible: isVisible,
      isDeleted: isDeleted,
    );
  }
}
