import 'dart:developer';

import 'package:chat_location/controller/user_controller.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/user/data/repositories/sign_up_repository_impl.dart';
import 'package:chat_location/features/user/data/repositories/user_repository_impl.dart';
import 'package:chat_location/features/user/domain/entities/auth.dart';
import 'package:chat_location/features/user/domain/entities/oauth_user.dart';
import 'package:chat_location/features/user/domain/entities/signup_user.dart';
import 'package:chat_location/features/user/presentation/provider/bottom_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpController extends StateNotifier<SignUpUser> {
  final Ref ref;
  final SignUpRepositoryImpl signUpRepository;
  int currentPage = 0; // 현재 페이지 상태 추가
  bool _isPage1Valid = false; // 첫 번째 페이지: 닉네임 중복 확인 여부
  bool _isPage2Valid = false; // 두 번째 페이지: 나이와 성별 입력 확인
  bool _isPage3Valid = false; // 세 번째 페이지: 한줄 소개 입력 확인

  late final TextEditingController nicknameController;
  late final TextEditingController ageController;
  late final TextEditingController descriptionController;
  late final PageController pageController;
  late final FocusNode nickNameFocus;
  late final FocusNode ageFocus;
  late final FocusNode descriptionFocus;
  SignUpController(SignUpUser initialUser, this.ref, this.signUpRepository)
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
    log("dispose");
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
    // bottomButton state 변경하기
  }

  void setAge(int age) {
    state = state.copyWith(age: age);
    // bottomButton state 변경하기
  }

  void setIsVisible(bool isVisible) {
    state = state.copyWith(isVisible: isVisible);
    // bottomButton state 변경하기
  }

  void setIntroduction(String introduction) {
    state = state.copyWith(introduction: introduction);
    // bottomButton state 변경하기
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
    // bottomButton state 변경하기
  }

  void _nickeNameEventListener() {
    // 닉네임 중복 확인 및 유효성 체크

    setNickname(nicknameController.text);
    _isPage1Valid = false; // 예시 조건
    _updateBottomButton();
  }

  void _ageEventListener() {
    // 나이 및 성별 입력 여부 체크
    _isPage2Valid = ageController.text.isNotEmpty;

    if (_isPage2Valid) setAge(int.parse(ageController.text));
    _updateBottomButton();
  }

  void _descriptionEventListener() {
    // 한줄 소개 입력 여부 체크

    _isPage3Valid = descriptionController.text.isNotEmpty;
    setIntroduction(descriptionController.text);
    _updateBottomButton();
  }

  // 페이지 이동
  void nextPage() {
    if (currentPage < 2) {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      currentPage++;
      _updateBottomButton();
    }
  }

  void prevPage() {
    if (currentPage > 0) {
      pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      currentPage--;
      _updateBottomButton();
    }
  }

  // 닉네임 중복 확인 요청
  Future<void> isNickNameValid() async {
    final nickName = state.nickname;
    try {
      //서버에서 이름  중복 확인
      final isAvailable = await signUpRepository.isNicknameValid(nickName);

      log('available id : ${isAvailable}');
      if (isAvailable) {
        _isPage1Valid = true;
      }
      if (!isAvailable) {
        _isPage1Valid = false;
      }
      _updateBottomButton(); // 상태 업데이트
    } catch (e) {
      nicknameError = "닉네임 확인에 실패했습니다.";

      _updateBottomButton(); // 상태 업데이트
    }
  }

  void setCurrentPage(index) {
    currentPage = index;
  }

  // 회원가입 요청
  Future<void> signUp() async {
    try {
      final userInfoJson = state.toJson();
      log("회원 가입: ${state.toJson().toString()}");
      // 회원가입 시도
      await ref.read(userProvider.notifier).signUp(userInfoJson);

      await ref.read(userProvider.notifier).signIn(
          {"oauthId": state.oauthId, "oauthProvider": state.oauthProvider});
      log("성공!!! ");
    } catch (e) {
      print("회원가입 실패: $e");
      rethrow;
    }
  }

  // BottomButton 상태 업데이트
  void _updateBottomButton() {
    log("bottom logic restart");
    final bottomButtonController = ref.read(bottomButtonProvider.notifier);
    bool _buttonDisabled = true;
    String _text = "확인";
    Future<void> Function()? _onPress = () async {};
    switch (currentPage) {
      case 0:
        _buttonDisabled = !_isPage1Valid;
        _text = "확인";
        _onPress = () async {
          nextPage();
        };
        break;
      case 1:
        _buttonDisabled = !_isPage2Valid;
        _text = "확인";
        _onPress = () async {
          nextPage();
        };
        break;
      case 2:
        _buttonDisabled = !_isPage3Valid;
        _text = "회원가입";
        _onPress = () async {
          await signUp();
        };
        break;
    }

    bottomButtonController.setDisabled(_buttonDisabled);
    bottomButtonController.setText(_text);
    bottomButtonController.setOnPress(_onPress);
  }
}

final signUpProvider = StateNotifierProvider.autoDispose
    .family<SignUpController, SignUpUser, OauthUser>(
  (ref, initialUser) {
    final SignUpUser initail = SignUpUser.fromOauthUser(initialUser);
    final signUpRepository = ref.read(signUpRepositoryProvider);
    return SignUpController(initail, ref, signUpRepository);
  },
);

// base Url입력하면 됩니다.
final apiClientProvider =
    Provider((ref) => ApiClient("http://192.168.0.11:8080/"));

// signUp 관련 provider
final signUpRepositoryProvider =
    Provider((ref) => SignUpRepositoryImpl(ref.read(apiClientProvider)));
