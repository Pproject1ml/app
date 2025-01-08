import 'package:chat_location/features/auth/data/models/signup.dart';
import 'package:chat_location/features/auth/dmain/entities/oauth.dart';

class SignUpInterface {
  final String oauthId;
  final String nickname;
  final String oauthProvider;
  final String? profileImage;
  final String? email;
  final int? age;
  final String? gender;
  final bool? isVisible;
  final String? introduction;

  SignUpInterface({
    required this.oauthId,
    required this.nickname,
    required this.oauthProvider,
    this.profileImage,
    this.email,
    this.age,
    this.gender,
    this.isVisible = false,
    this.introduction,
  });

  // JSON 변환용 메서드
  Map<String, dynamic> toJson() {
    return {
      'oauthId': oauthId,
      'nickname': nickname,
      'oauthProvider': oauthProvider,
      'profileImage': profileImage,
      'email': email,
      'age': age,
      'gender': gender,
      'isVisible': isVisible,
      'introduction': introduction
    };
  }

  factory SignUpInterface.fromJson(Map<String, dynamic> json) {
    return SignUpInterface(
      oauthId: json['oauthId'] as String,
      nickname: json['nickname'] as String,
      oauthProvider: json['oauthProvider'] as String,
      profileImage: json['profileImage'] as String?,
      email: json['email'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      isVisible: json['isVisible'] as bool?,
      introduction: json['introduction'] as String?,
    );
  }

  // copyWith 메서드 추가
  SignUpInterface copyWith({
    String? oauthId,
    String? nickname,
    String? oauthProvider,
    String? profileImage,
    String? email,
    int? age,
    String? gender,
    bool? isVisible,
    String? introduction,
  }) {
    return SignUpInterface(
      oauthId: oauthId ?? this.oauthId,
      nickname: nickname ?? this.nickname,
      oauthProvider: oauthProvider ?? this.oauthProvider,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      isVisible: isVisible ?? this.isVisible,
      introduction: introduction ?? this.introduction,
    );
  }

  // OauthUser로부터 SignUpUser 생성
  factory SignUpInterface.fromOauth(OauthInterface user) {
    assert(user.oauthId != null &&
        user.nickname != null &&
        user.oauthProvider != null);
    return SignUpInterface(
      oauthId: user.oauthId!,
      nickname: user.nickname!,
      oauthProvider: user.oauthProvider!,
      profileImage: user.profileImage,
      email: user.email,
      age: null, // OauthUser에 없는 값은 기본값(null)으로 설정
      gender: null,
      isVisible: false,
      introduction: null,
    );
  }

  SignUpModel toSignUpModel() {
    return SignUpModel(
        oauthId: oauthId,
        nickname: nickname,
        oauthProvider: oauthProvider,
        profileImage: profileImage,
        email: email,
        age: age,
        gender: gender,
        isVisible: isVisible,
        introduction: introduction);
  }
}
