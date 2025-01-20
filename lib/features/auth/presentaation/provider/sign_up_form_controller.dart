import 'dart:developer';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/auth/dmain/entities/oauth.dart';
import 'package:chat_location/features/auth/dmain/entities/signup.dart';
import 'package:chat_location/features/auth/presentaation/provider/auth_controller.dart';
import 'package:chat_location/features/auth/presentaation/provider/sign_up_bottom_button_controller.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpFormControllerT extends StateNotifier<SignUpInterface> {
  final Ref ref;

  final BottomButtonControllerT signUpBottomButtonRepository;
  final AuthController authNotifier;
  int currentPage = 0; // 현재 페이지 상태 추가
  bool _isPage1Valid = false; // 첫 번째 페이지: 닉네임 중복 확인 여부
  bool _isPage2Valid = false; // 두 번째 페이지: 나이와 성별 입력 확인
  bool _isPage3Valid = false; // 세 번째 페이지: 한줄 소개 입력 확인
  bool _isNicknameValid = false; // 닉네임 중복확인
  late final TextEditingController nicknameController;
  late final TextEditingController ageController;
  late final TextEditingController descriptionController;
  late final PageController pageController;
  late final FocusNode nickNameFocus;
  late final FocusNode ageFocus;
  late final FocusNode descriptionFocus;
  SignUpFormControllerT(SignUpInterface initialUser, this.ref,
      this.signUpBottomButtonRepository, this.authNotifier)
      : super(initialUser) {
    // 초기화 시 BottomButton 상태 설정

    pageController = PageController();
    nicknameController = TextEditingController(text: initialUser.nickname);
    ageController = TextEditingController();
    descriptionController = TextEditingController();
    nickNameFocus = FocusNode();
    ageFocus = FocusNode();
    descriptionFocus = FocusNode();
    nicknameController.addListener(_nickeNameEventListener);
    ageController.addListener(_ageEventListener);
    descriptionController.addListener(_descriptionEventListener);
    Future.microtask(() => _updateBottomButton());
  }
  @override
  void dispose() {
    pageController.dispose();
    nicknameController.dispose();
    ageController.dispose();
    descriptionController.dispose();
    nickNameFocus.dispose();
    ageFocus.dispose();
    descriptionFocus.dispose();
    nicknameController.removeListener(_nickeNameEventListener);
    ageController.removeListener(_ageEventListener);
    descriptionController.removeListener(_descriptionEventListener);

    super.dispose();
  }

  String? nicknameError;

  void setFocus(index) {
    switch (index) {
      case 0:
        nickNameFocus.requestFocus();
        break;
      case 1:
        ageFocus.requestFocus();
        break;
      case 2:
        descriptionFocus.requestFocus();
    }
  }

  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
    _pageValidChecker(state); // valid 여부 확인
    _updateBottomButton();
  }

  void setAge(int? age) {
    state = state.copyWith(age: age ?? 0);
    _pageValidChecker(state); // valid 여부 확인
    _updateBottomButton();
  }

  void setIsVisible(bool isVisible) {
    state = state.copyWith(isVisible: isVisible);
    _pageValidChecker(state); // valid 여부 확인
    _updateBottomButton();
  }

  void setIntroduction(String introduction) {
    state = state.copyWith(introduction: introduction);
    _pageValidChecker(state); // valid 여부 확인
    _updateBottomButton();
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
    _pageValidChecker(state); // valid 여부 확인
    _updateBottomButton();
  }

  void _nickeNameEventListener() {
    // 닉네임 중복 확인 및 유효성 체크
    setNickname(nicknameController.text);
    _isNicknameValid = false; // 이름이 바뀌면 nickname 중복확인 초기화;
  }

  void _ageEventListener() {
    // 나이 및 성별 입력 여부 체크
    if (ageController.text.isNotEmpty) {
      setAge(int.parse(ageController.text));
    } else {
      setAge(null);
    }
  }

  void _descriptionEventListener() {
    // 한줄 소개 입력 여부 체크

    _isPage3Valid = descriptionController.text.isNotEmpty;
    setIntroduction(descriptionController.text);
    _updateBottomButton();
  }

  // 페이지 이동
  void _nextPage() {
    if (currentPage < 2) {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      currentPage++;
      _updateBottomButton();
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      currentPage--;
      _updateBottomButton();
    }
  }

  void _pageValidChecker(SignUpInterface user) {
    switch (currentPage) {
      case 0:
        _page1ValidChecker(user);
        _updateBottomButton();
        break;
      case 1:
        _page2ValidChecker(user);
        _updateBottomButton();
        break;
      case 2:
        _page3ValidChecker(user);
        _updateBottomButton();
        break;
    }
  }

  // 페이지 1이 valid한지 확인 로직
  void _page1ValidChecker(SignUpInterface user) {
    // _isNicknamValid
    if (user.nickname.isNotEmpty && _isNicknameValid) {
      _isPage1Valid = true;
    } else {
      _isPage1Valid = false;
    }
  }

// 페이지 2가 valid한지 확인 로직
  void _page2ValidChecker(SignUpInterface user) {
    // age, 성별, 입력 여부

    if (user.age != null &&
        user.age! > 0 &&
        user.age is int &&
        user.gender != null) {
      _isPage2Valid = true;
    } else {
      _isPage2Valid = false;
    }
  }

  void _page3ValidChecker(SignUpInterface user) {
    // introduction check
    if (user.introduction != null && user.introduction!.isNotEmpty) {
      _isPage3Valid = true;
    } else {
      _isPage3Valid = false;
    }
  }

  // 닉네임 중복 확인 요청
  Future<void> isNickNameValid() async {
    final nickName = state.nickname;

    try {
      //서버에서 이름  중복 확인
      final isAvailable = await authNotifier.isNickNameValid(nickName);

      if (isAvailable) {
        _isNicknameValid = true;
      }
      if (!isAvailable) {
        _isNicknameValid = false;
      }
    } catch (e) {
      _isNicknameValid = false;
    }
    _pageValidChecker(state);
  }

  void setCurrentPage(index) {
    currentPage = index;
  }

  // 회원가입 요청
  Future<MemberInterface> signUp() async {
    try {
      // 회원가입
      await authNotifier.signUp(state);
      // 로그인
      final user = await authNotifier.signIn();
      if (user != null) {
        return user;
      }
      throw '회원가입에 실패하였습니다.';
    } catch (e) {
      throw '회원가입에 실패하였습니다.';
    }
  }

  // BottomButton 상태 업데이트
  void _updateBottomButton() {
    bool _buttonDisabled = true;
    String _text = "확인";
    Future<void> Function()? _onPress = () async {};

    switch (currentPage) {
      case 0:
        _buttonDisabled = !_isPage1Valid;
        _text = "확인";
        _onPress = () async {
          _nextPage();
        };
        break;
      case 1:
        _buttonDisabled = !_isPage2Valid;
        _text = "확인";
        _onPress = () async {
          _nextPage();
        };
        break;
      case 2:
        _buttonDisabled = !_isPage3Valid;
        _text = "회원가입";
        _onPress = () async {
          try {
            await signUp();
          } catch (e) {
            throw e.toString();
          }
        };
        break;
    }

    signUpBottomButtonRepository.update(
        isDisabled: _buttonDisabled, onPress: _onPress, text: _text);
  }
}

final signUpFormProvider =
    StateNotifierProvider.autoDispose<SignUpFormControllerT, SignUpInterface>(
  (ref) {
    final authNotifier = ref.read(authProvider.notifier);
    final OauthInterface? oauthState = authNotifier.authState;
    if (oauthState == null) throw 'oauth 오류가 발생했습니다';
    final SignUpInterface initail = SignUpInterface.fromOauth(oauthState);

    final signUpBottomButtonRepository =
        ref.read(signUpBottomButtonProvider.notifier);
    return SignUpFormControllerT(
        initail, ref, signUpBottomButtonRepository, authNotifier);
  },
);

// base Url입력하면 됩니다.
final apiClientProvider = Provider((ref) => ApiClient(BASE_URL));
