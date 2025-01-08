//DB 에서 사용하는 유저이 모델입니다.
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';

class ProfileModel {
  final String profileId;
  final String nickname;
  final String? email;
  final String? profileImage;
  final String? introduction;
  final int? age;
  final String? gender;

  final bool isVisible;

  ProfileModel({
    required this.profileId,
    required this.nickname,
    this.email,
    this.profileImage,
    this.introduction,
    this.age,
    this.gender,
    required this.isVisible,
  });

  // JSON 데이터를 UserModel 객체로 변환
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profileId: json['profileId'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      introduction: json['introduction'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      isVisible: json['isVisible'] as bool,
    );
  }

  // UserModel 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'nickname': nickname,
      'email': email,
      'profileImage': profileImage,
      'introduction': introduction,
      'age': age,
      'gender': gender,
      'isVisible': isVisible,
    };
  }

  // copyWith 메서드 (객체 복사와 업데이트를 위한 메서드)

  ProfileModel copyWith({
    String? profileId,
    String? nickname,
    String? email,
    String? profileImage,
    String? introduction,
    int? age,
    String? gender,
    bool? isVisible,
  }) {
    return ProfileModel(
      profileId: profileId ?? this.profileId,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      introduction: introduction ?? this.introduction,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  // data -> entitiy 변환

  ProfileInterface toProfileInterface() {
    return ProfileInterface(
        profileId: profileId,
        nickname: nickname,
        email: email,
        profileImage: profileImage,
        introduction: introduction,
        age: age,
        gender: gender,
        isVisible: isVisible);
  }
}
