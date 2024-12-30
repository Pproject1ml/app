import 'dart:developer';
import 'package:chat_location/core/database/shared_preference.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/initialize/screen/splashScreen.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';
import 'package:chat_location/features/user/data/repositories/user_repository_impl.dart';
import 'package:chat_location/features/user/domain/entities/auth.dart';
import 'package:chat_location/features/user/domain/entities/oauth_user.dart';
import 'package:chat_location/features/user/domain/entities/user.dart';
import 'package:chat_location/features/user/domain/repositories/user_repository.dart';
import 'package:chat_location/features/user/presentation/screen/login.dart';
import 'package:chat_location/features/user/presentation/screen/signUp.dart';
import 'package:chat_location/features/user/util/oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

enum MODE { loginTest, signUpTest, normal, main }

enum LoginPlatform { GOOGLE, KAKAO }

class UserController with ChangeNotifier {
  // userRepository 안에 api 통신을 위한 매서드가 정의되어있으니 사용하면 됩니다.
  final MODE mode = MODE.normal;
  final UserRepositoryImpl userRepository;

  UserController(this.userRepository);

  // AuthState
  AuthState _authState = const AuthStateInitial();

  AuthState get authState => _authState;

  Future<void> init() async {
    await checkIfAuthenticated();
  }

// 로컬 유저 확인
  Future<void> checkIfAuthenticated() async {
    _authState = const AuthStateAuthenticating(null);
    final _user = await SharedPreferencesHelper.loadUser();
    if (_user != null) {
      final user = _user;
      _authState = AuthStateAuthenticated(user);
    } else {
      _authState = AuthStateUnauthenticated();
    }
    notifyListeners();
  }

// 유저 정보 변경
  Future<void> updateUserInfo(AppUser userInfo) async {
    if (_authState is AuthStateAuthenticated) {
      try {
        final authenticatedState = _authState as AuthStateAuthenticated;

        // 기존 유저 정보를 복사하면서 새로운 정보를 업데이트
        final updatedUser = authenticatedState.user.copyWith(
          nickname: userInfo.nickname,
          email: userInfo.email,
          profileImage: userInfo.profileImage,
          introduction: userInfo.introduction,
          age: userInfo.age,
          gender: userInfo.gender,
        );
        // 유저 정보 변경 api
        await userRepository.updateUser(updatedUser);

        // SharedPreferences에 업데이트된 유저 저장
        await SharedPreferencesHelper.saveUser(updatedUser);

        // 상태 업데이트
        _authState = AuthStateAuthenticated(updatedUser);

        log("User updated: ${updatedUser.nickname}");
        notifyListeners();
      } catch (error) {
        throw Exception("user 정보 변경에 실패하였습니다.");
      }
    } else {
      log("Cannot update user info: User is not authenticated.");
    }
  }

  dynamic getUser() {
    if (_authState.state == AuthStateType.authenticating) {
      return (_authState as AuthStateAuthenticating).user;
    } else if (_authState.state == AuthStateType.authenticated) {
      return (_authState as AuthStateAuthenticated).user;
    }
  }

  Future<void> signUp(Map<String, dynamic> userData) async {
    // signUp api 호출 후 성고하면 _state 변경
    try {
      // 회원가입
      await userRepository.signUp(userData);
      return;
    } catch (e) {
      // 실패하면 그냥 가만히 있어.
      return;
    }
  }

  Future<void> signIn(Map<String, dynamic> signInData) async {
    _authState = const AuthStateAuthenticating(null);
    AppUser? user;
    try {
      user = await userRepository.signIn(signInData);
      if (user != null) {
        await SharedPreferencesHelper.saveUser(user);
        _authState = AuthStateAuthenticated(user);
      } else {
        _authState = const AuthStateUnauthenticated();
      }
    } catch (e) {
      _authState = const AuthStateUnauthenticated();
    }

    notifyListeners();
  }

//유저 로그인
  Future<void> login(LoginPlatform platform) async {
    _authState = const AuthStateAuthenticating(null);

    bool isAuthenticated = false;
    AppUser? user;
    Map<String, dynamic> _body = {};
    try {
      if (platform == LoginPlatform.GOOGLE) {
        // Replace with actual Google login logic
        GoogleSignInAccount? _googleUser = await googleLogin();
        if (_googleUser != null) {
          _body = {
            "oauthId": _googleUser.id,
            "nickname": _googleUser.displayName,
            "oauthProvider": "GOOGLE",
            "profileImage": _googleUser.photoUrl,
            "email": _googleUser.email
          };
        }
      } else if (platform == LoginPlatform.KAKAO) {
        // Replace with actual Kakao login logic
        User? _kakaoUser = await kakaoLogin();
        if (_kakaoUser != null) {
          _body = {
            "oauthId": _kakaoUser.id.toString(),
            "nickname": _kakaoUser.kakaoAccount?.profile?.nickname ?? 'default',
            "oauthProvider": "KAKAO",
            "profileImage":
                _kakaoUser.kakaoAccount?.profile?.profileImageUrl ?? '',
            "email": _kakaoUser.kakaoAccount?.email
          };
        }
      }
      // -- dev mode 에서 사용 (test용 로직입니다.)
      if (mode == MODE.main) {
        user = AppUser(
            memberId: "0",
            oauthId: "oauthId",
            nickname: "tester",
            oauthProvider: "Google");
      }
      if (mode == MODE.normal) {
        user = await userRepository.signIn(_body);
      } else if (mode == MODE.signUpTest) {
        user = null;
      }
      //------------------------------------
      if (user == null) {
        // signUpPage로 이동시켜라
        OauthUser _tmpUser = OauthUser.fromJson(_body);
        _authState = AuthStateAuthenticating(_tmpUser);
        notifyListeners();
        return;
      }

      isAuthenticated = true;
      if (isAuthenticated && user != null) {
        await SharedPreferencesHelper.saveUser(user);
        _authState = AuthStateAuthenticated(user);
      } else {
        _authState = const AuthStateUnauthenticated();
      }
    } catch (error) {
      _authState = const AuthStateUnauthenticated();
    }

    notifyListeners();
  }

// 유저 로그아웃
  Future<void> logout() async {
    await SharedPreferencesHelper.clearUser();
    _authState = const AuthStateUnauthenticated();
    await oauthLogOut();
    log('User logged out');
    notifyListeners();
  }

  // goRouter 에서의 redirect 로직입니다. -> 현재는 라우팅 로직이 유저 상태에 따라서만 달라져서 해당 파일에 작성함
  String? redirect({
    required GoRouterState goRouterState,
    required bool showErrorIfNonExistentRoute,
  }) {
    log("route ${goRouterState.fullPath}, state:${authState.state.toString()}");

    final isAuthInitial =
        switch (authState.state) { AuthStateType.initial => true, _ => false };
    final isAutheticating = switch (authState.state) {
      AuthStateType.authenticating => true,
      _ => false
    };

    final isAuthenticated = switch (authState.state) {
      AuthStateType.authenticated => true,
      _ => false
    };

    // initial 이면 splash 로 이동해라
    if (isAuthInitial) {
      return SplashScreen.routeName;
    }
    // 만약 splash screen 인데 인증된 유저이면 map, 안되었으면 login, 인증 중이면 null
    if (goRouterState.matchedLocation.startsWith(SplashScreen.routeName)) {
      if (isAutheticating) {
        return (_authState as AuthStateAuthenticating).user != null
            ? LoginPage.routeName + SingUpPage.routeName
            : null;
      }
      return isAuthenticated ? MapScreen.routeName : LoginPage.routeName;
    }
    // 만약 로그인 페이지인데 인증 중이면 그대로, 인증되었다면 가던기, 아니면 로그인
    if (goRouterState.matchedLocation.endsWith(LoginPage.routeName)) {
      log("로그인 middle ware");
      if (isAutheticating) {
        return (authState as AuthStateAuthenticating).user != null
            ? LoginPage.routeName + SingUpPage.routeName
            : null;
      }
      return isAuthenticated ? null : LoginPage.routeName;
    }
    // 만약 회원가입 페이지인데 인증 중이면 그대로, 인증되었다면 가던기, 아니면 로그인
    if (goRouterState.matchedLocation.endsWith(SingUpPage.routeName)) {
      if (isAutheticating) {
        return null;
      }
    }

    return isAuthenticated ? null : LoginPage.routeName;
  }
}

final userProvider = ChangeNotifierProvider((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UserController(userRepository);
});

// base Url입력하면 됩니다.
final apiClientProvider =
    Provider((ref) => ApiClient("http://192.168.0.11:8080/"));

// user 관련 provider
final userRepositoryProvider =
    Provider((ref) => UserRepositoryImpl(ref.read(apiClientProvider)));
