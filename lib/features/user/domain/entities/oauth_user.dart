class OauthUser {
  final String oauthId;
  final String nickname;
  final String oauthProvider;
  final String? profileImage;
  final String? email;

  OauthUser({
    required this.oauthId,
    required this.nickname,
    required this.oauthProvider,
    this.profileImage,
    this.email,
  });

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

  factory OauthUser.fromJson(Map<String, dynamic> json) {
    return OauthUser(
      oauthId: json['oauthId'] as String,
      nickname: json['nickname'] as String,
      oauthProvider: json['oauthProvider'] as String,
      profileImage: json['profileImage'] as String?,
      email: json['email'] as String?,
    );
  }

  // copyWith 메서드 추가
  OauthUser copyWith({
    String? oauthId,
    String? nickname,
    String? oauthProvider,
    String? profileImage,
    String? email,
  }) {
    return OauthUser(
      oauthId: oauthId ?? this.oauthId,
      nickname: nickname ?? this.nickname,
      oauthProvider: oauthProvider ?? this.oauthProvider,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
    );
  }
}
