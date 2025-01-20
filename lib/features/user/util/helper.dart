import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLoginHelper {
  Future<String> getKakaoKeyHash() async {
    var key = await KakaoSdk.origin;
    return key;
  }

  Future<User?> login() async {
    var key = await getKakaoKeyHash();

    if (await isKakaoTalkInstalled()) {
      log('카카오톡 설치됨');
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        // 카카오 로그인의 경우 토큰을 가지고 kakao에 정보가져오기 api 호출(백엔드) 하여 정보를 받아올 수 있음
        final info = await UserApi.instance.me();
        // log("User: ${info.toString()}");
        // log('카카오톡으로 로그인 성공 : ${token.toString()}');

        return info; //토큰 정보
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          final info = await UserApi.instance.me();
          // log('카카오계정으로 로그인 성공 : ${token.toString()}');
          return info; //토큰 정보
        } catch (error) {
          log('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      log('카카오톡 설치 안됨');
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        final info = await UserApi.instance.me();
        log('카카오계정으로 로그인 성공 : ${token.toString()}');
        return info; //토큰 정보
      } catch (error) {
        log('카카오계정으로 로그인 실패 $error');
      }
    }
    return null;
  }

  Future<void> logout() async {
    try {
      UserApi.instance.logout();
    } catch (error) {
      print('카카오 로그인 실패 $error');
    }
  }
}

class GoogleLoginHelper {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile']);

  Future<GoogleSignInAccount?> login() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      // final GoogleSignInAuthentication googleSignInAuthentication =
      //     await googleSignInAccount!.authentication;
      // log(googleSignInAccount.toString());
      // print(googleSignInAuthentication.accessToken);

      return googleSignInAccount;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
    return null;
  }

  Future<void> logout(
      // String? accessToken
      ) async {
    // await revokeToken(accessToken!);

    await googleSignIn.signOut();
    print('User signed out');
  }

  Future<void> revokeToken(String token) async {
    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/revoke'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'token=$token',
    );

    if (response.statusCode == 200) {
      print('Token revoked successfully');
    } else {
      print('Failed to revoke token');
    }
  }
}
