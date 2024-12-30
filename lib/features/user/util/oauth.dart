import 'package:chat_location/features/user/util/helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<GoogleSignInAccount?> googleLogin() async {
  var googleLoginHelper = GoogleLoginHelper();

  GoogleSignInAccount? googleAccount = await googleLoginHelper.login();
  if (googleAccount != null) {
    return googleAccount;
  } else {
    EasyLoading.showError('로그인/회원가입에 실패했습니다.',
        duration: const Duration(seconds: 3),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
  }
  // autoLogin(accessToken, LoginPlatform.GOOGLE)
  //     .then((value) => afterLogin(value))
  //     .then((value) => googleLoginHelper.logout(accessToken));
}

Future<User?> kakaoLogin() async {
  var kakaoLoginHelper = KakaoLoginHelper();

  User? _kakaoAccount = await kakaoLoginHelper.login();

  if (_kakaoAccount != null) {
    return _kakaoAccount;
  } else {
    EasyLoading.showError('로그인/회원가입에 실패했습니다.',
        duration: const Duration(seconds: 3),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  }
}

Future<void> oauthLogOut() async {
  var kakaoLoginHelper = KakaoLoginHelper();
  await kakaoLoginHelper.logout();
  var googleLoginHelper = GoogleLoginHelper();
  await googleLoginHelper.logout();
}
