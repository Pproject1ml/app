import 'dart:developer';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:chat_location/core/database/secure_storage.dart';
import 'package:chat_location/core/database/shared_preference.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chat_location/features/auth/dmain/entities/oauth.dart';
import 'package:chat_location/features/auth/dmain/entities/signup.dart';
import 'package:chat_location/features/auth/presentaation/screen/login_screen.dart';
import 'package:chat_location/features/auth/presentaation/screen/sign_up_screen.dart';
import 'package:chat_location/features/initialize/screen/splashScreen.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:chat_location/features/user/util/oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

enum LoginPlatform { GOOGLE, KAKAO }

enum RUNTIMEMODE { normal, passLogin, toSignUp }

const RUNTIMEMODE mode = RUNTIMEMODE.normal;

class AuthController with ChangeNotifier {
  OauthInterface authState = OauthInterface();
  final UserController userNotifier;
  final AuthRepositoryImpl authRepository;
  String routeNameFrom = MapScreen.routeName;
  AuthController(this.userNotifier, this.authRepository);

  // 닉네임 중복확인
  Future<bool> isNickNameValid(String nickname) async {
    try {
      return await authRepository.isNicknameValid(nickname);
    } catch (e) {
      throw '닉네임 중복확인에 실패하였습니다.';
    }
  }

  // 인가된 유저인지 확인
  Future<MemberInterface?> checkIfAuthenticated() async {
    authState = authState.copyWith(authState: AuthStateT.authenticating);
    //1. local에 유저 정보가 있는지 확인
    final _user = await SharedPreferencesHelper.loadUser();
    //1-1. 있다면 서버에서 확인
    if (_user != null) {
      // 서버에서 확인하는 코드
      final res = await Future.delayed(Duration(seconds: 2));

      // 서버에서 유저를 가져왔다면
      //유저 다시 저장  await SharedPreferencesHelper.saveUser(updatedUser);
      userNotifier.setUser(_user);
      authState = authState.copyWith(
          oauthId: _user.oauthId,
          oauthProvider: _user.oauthProvider,
          authState: AuthStateT.authenticated);
      notifyListeners();
      return _user;
    }

    log('here');
    //1-2. 없다면 unAuthenticated로 변경
    authState = authState.copyWith(authState: AuthStateT.unauthenticated);
    // 상태 변경 알림
    notifyListeners();
  }

  // auth signUp
  Future<void> signUp(SignUpInterface user) async {
    // signUp api 호출 후 성고하면 _state 변경
    try {
      // 회원가입
      await authRepository.signUp(user.toSignUpModel());
      authState = authState.copyWith(nickname: user.nickname);
    } catch (e) {
      // 실패하면 그냥 가만히 있어.
      throw '회원가입도중 오류가 발생하였습니다.';
    }
  }

  // auth signIn
  Future<MemberInterface?> signIn() async {
    Future<MemberInterface> _successState(MemberInterface user) async {
      authState = authState.copyWith(
        authState: AuthStateT.authenticated,
      );
      log("1");
      // userProvider 상태 변경해주기.
      userNotifier.setUser(user);

      // 유저 저장
      await SharedPreferencesHelper.saveUser(user);
      log("3");
      notifyListeners();
      return user;
    }

    dynamic _redirectionSatate() {
      authState = authState.copyWith(
        authState: AuthStateT.authenticating,
      );
      notifyListeners();
      return null;
    }

    void _failState() {
      authState = authState.copyWith(
          authState: AuthStateT.authenticating,
          oauthId: null,
          oauthProvider: null);
      notifyListeners();
    }

    if (mode == RUNTIMEMODE.passLogin) {
      log("pass login");
      final dynamic res = {
        "memberId": "2a1c9422-0c10-4582-81d0-e41aad8fe5ef",
        "nickname": "테스트",
        "email": "ethanleast@gmail.com",
        "profileImage": null,
        "introduction": "사이",
        "age": 22,
        "gender": "male",
        "role": "ROLE_USER",
        "oauthId": "1124",
        "oauthProvider": "GOOGLE",
        "isDeleted": false,
        "isVisible": false
      };
      return _successState(res);
    }
    try {
      // signIn api 실행
      log('authState: ${authState.toJson().toString()}');
      final res = await authRepository.signIn(authState.toOauthModel());

      // res null 이라면 SignUp으로
      if (res == null) {
        return _redirectionSatate();
      } else {
        log("a[[ usesr : ${res.toString()}");
        final appUser = await _successState(res.toMemberInterface());
        return appUser;
      }
    } catch (e) {
      _failState();
      throw '로그인도중 오류가 발생하였습니다.';
    }
  }

  // google auth
  Future<void> GoogleSignIn() async {
    const _errorMessage = '구글 로그인에 실패하였습니다';

    try {
      GoogleSignInAccount? _googleUser = await googleLogin();

      if (_googleUser != null) {
        authState = authState.copyWith(
          oauthId: _googleUser.id,
          nickname: _googleUser.displayName,
          oauthProvider: "GOOGLE",
          profileImage: _googleUser.photoUrl,
          email: _googleUser.email,
        );
      } else {
        throw _errorMessage;
      }
    } catch (e) {
      throw _errorMessage;
    }
  }

  // kakao auth
  Future<void> KakaoSignIn() async {
    const _errorMessage = '카카오 로그인에 실패하였습니다';
    try {
      User? _kakaoUser = await kakaoLogin();
      if (_kakaoUser != null) {
        authState = authState.copyWith(
            oauthId: _kakaoUser.id.toString(),
            nickname: _kakaoUser.kakaoAccount?.profile?.nickname ?? 'default',
            oauthProvider: "KAKAO",
            profileImage:
                _kakaoUser.kakaoAccount?.profile?.profileImageUrl ?? '',
            email: _kakaoUser.kakaoAccount?.email);
      } else {
        throw _errorMessage;
      }
    } catch (e) {
      throw _errorMessage;
    }
  }

//유저 로그인
  Future<void> login(LoginPlatform platform) async {
    // 1. oauth를 통해 oauth정보 가져오기.

    try {
      if (platform == LoginPlatform.GOOGLE) {
        await GoogleSignIn();
      } else if (platform == LoginPlatform.KAKAO) {
        await KakaoSignIn();
      }

      // 2. oauth 정보를 바탕으로 signIn 하기
      await signIn();
      log("login success");
    } catch (e) {
      log("login fail: ${e.toString()}");
      authState = authState.copyWith(
          authState: AuthStateT.unauthenticated,
          oauthId: null,
          oauthProvider: null);

      notifyListeners();
      throw '로그인에 실패하였습니다.';
    }
  }

// 유저 로그아웃
  Future<void> logout() async {
    try {
      // 1.서버에 로그아웃 알림
      await Future.delayed(Duration(seconds: 2));
      // 2.oauth 로그아웃 알림
      await oauthLogOut();

      // 3.local 저장소 초기화
      await SecureStorageHelper.clearAll();
      //4. 상태 변경
      authState = authState.copyWith(
          authState: AuthStateT.unauthenticated,
          oauthId: null,
          oauthProvider: null);

      log('User logged out');
      notifyListeners();
    } catch (e) {
      // 3.local 저장소 초기화
      await SecureStorageHelper.clearAll();

      authState = authState.copyWith(
          authState: AuthStateT.unauthenticated,
          oauthId: null,
          oauthProvider: null);
      notifyListeners();
      throw e.toString();
    }
  }

// goRouter 에서의 redirect 로직입니다.
  String? redirect({
    required GoRouterState goRouterState,
    required bool showErrorIfNonExistentRoute,
  }) {
    log("route ${goRouterState.fullPath}");
    log("state:${authState.authState.toString()}");

    final isAuthInitial =
        switch (authState.authState) { AuthStateT.initial => true, _ => false };
    final isAutheticating = switch (authState.authState) {
      AuthStateT.authenticating => true,
      _ => false
    };
    final isAuthenticated = switch (authState.authState) {
      AuthStateT.authenticated => true,
      _ => false
    };
    final unAuthenticated = switch (authState.authState) {
      AuthStateT.unauthenticated => true,
      _ => false
    };
    // state initial -> splash screen
    if (isAuthInitial) return SplashScreen.routeName;
    if (isAuthenticated) {
      if (goRouterState.matchedLocation.startsWith(SplashScreen.routeName)) {
        return routeNameFrom;
      }
      routeNameFrom = goRouterState.fullPath ?? MapScreen.routeName;
      return null;
    }
    if (unAuthenticated) return LoginPageT.routeName;
    if (isAutheticating) return LoginPageT.routeName + SingUpScreenT.routeName;
  }
}

final authProvider = ChangeNotifierProvider((ref) {
  final userNotifier = ref.read(userProvider.notifier);
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(userNotifier, authRepository);
});

// base Url입력하면 됩니다.
final apiClientProvider = Provider((ref) => ApiClient(BASE_URL));

final authRepositoryProvider =
    Provider((ref) => AuthRepositoryImpl(ref.read(apiClientProvider)));
