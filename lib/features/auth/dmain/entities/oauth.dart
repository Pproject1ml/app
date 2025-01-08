// oauth State

import 'package:chat_location/features/auth/data/models/oauth.dart';

enum AuthStateT { initial, authenticating, authenticated, unauthenticated }

class OauthInterface {
  final String? oauthId;
  final String? nickname;
  final String? oauthProvider;
  final String? profileImage;
  final String? email;
  final AuthStateT authState;
  OauthInterface(
      {this.oauthId,
      this.nickname,
      this.oauthProvider,
      this.profileImage,
      this.email,
      this.authState = AuthStateT.initial});

  // JSON 변환용 메서드
  Map<String, dynamic> toJson() {
    return {
      'oauthId': oauthId,
      'nickname': nickname,
      'oauthProvider': oauthProvider,
      'profileImage': profileImage,
      'email': email,
    };
  }

  factory OauthInterface.fromJson(Map<String, dynamic> json) {
    return OauthInterface(
      oauthId: json['oauthId'] as String,
      nickname: json['nickname'] as String,
      oauthProvider: json['oauthProvider'] as String,
      profileImage: json['profileImage'] as String?,
      email: json['email'] as String?,
    );
  }

  // copyWith 메서드 추가
  OauthInterface copyWith(
      {String? oauthId,
      String? nickname,
      String? oauthProvider,
      String? profileImage,
      String? email,
      AuthStateT? authState}) {
    return OauthInterface(
        oauthId: oauthId ?? this.oauthId,
        nickname: nickname ?? this.nickname,
        oauthProvider: oauthProvider ?? this.oauthProvider,
        profileImage: profileImage ?? this.profileImage,
        email: email ?? this.email,
        authState: authState ?? this.authState);
  }

  // entiti to model

  OauthModel toOauthModel() {
    assert(oauthId != null && nickname != null && oauthProvider != null);
    return OauthModel(
        oauthId: oauthId!,
        nickname: nickname!,
        oauthProvider: oauthProvider!,
        profileImage: profileImage,
        email: email);
  }
}
