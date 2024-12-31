import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/controller/user_controller.dart';
import 'package:chat_location/features/user/domain/entities/auth.dart';
import 'package:chat_location/features/user/domain/entities/oauth_user.dart';
import 'package:chat_location/features/user/domain/entities/signup_user.dart';
import 'package:chat_location/features/user/presentation/component/sign_up/bottom_next_button.dart';
import 'package:chat_location/features/user/presentation/provider/sign_up_user_controller.dart';
import 'package:chat_location/features/user/presentation/ui/sign_up/gender_button.dart';
import 'package:chat_location/features/user/presentation/ui/sign_up/index_indicator.dart';
import 'package:chat_location/features/user/presentation/ui/sign_up/sinup_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingUpPageView extends ConsumerStatefulWidget {
  const SingUpPageView({super.key});

  @override
  ConsumerState<SingUpPageView> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<SingUpPageView> {
  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oauthNotifier = ref.read(userProvider.notifier);

    if (oauthNotifier.getUser() is OauthUser) {
      final signUpController =
          ref.watch(signUpProvider(oauthNotifier.getUser() as OauthUser));
      final signUpNotifier = ref
          .read(signUpProvider(oauthNotifier.getUser() as OauthUser).notifier);
      return Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: heightRatio(21)),
              child: indexIndicator(signUpNotifier.currentPage)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: heightRatio(44),
              ),
              child: PageView(
                controller: signUpNotifier.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  signUpNotifier.setCurrentPage(index);
                  signUpNotifier.setFocus(index);
                },
                children: [
                  _firstPage(
                      signUpController: signUpController,
                      signUpNotifier: signUpNotifier),
                  _secondPage(
                      signUpController: signUpController,
                      signUpNotifier: signUpNotifier),
                  _thirdPage(
                      signUpController: signUpController,
                      signUpNotifier: signUpNotifier)
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _firstPage(
      {required SignUpController signUpNotifier,
      required SignUpUser signUpController}) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.only(left: widthRatio(20), right: widthRatio(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SignUpTitle(title: "닉네임을 설정해 주세요."),
            const SizedBox(height: 7),
            const SignUpSubTitle(message: "공백 또는 특수문자는 사용할 수 없어요."),
            const SizedBox(height: 36),
            SignUpSetNickName(
              signUpController: signUpController,
              signUpNotifier: signUpNotifier,
            )
          ],
        ),
      ),
    );
  }

  Widget _secondPage(
      {required SignUpController signUpNotifier,
      required SignUpUser signUpController}) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SignUpTitle(title: "나이와 성별을 알려 주세요."),
            const SizedBox(height: 8),
            const SignUpSubTitle(
              message: "유저 간의 신뢰를 쌓기 위함이에요.\n원하지 않으면 비공개 설정을 할 수 있어요.",
            ),
            const SizedBox(height: 24),
            const SignUpInputTitle(
              title: "나이",
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: 70,
                    child: BottomBorderTextInput(
                      controller: signUpNotifier.ageController,
                      focusNode: signUpNotifier.ageFocus,
                      isCounterVisible: false,
                      keyboardType: TextInputType.number,
                    )),
                Text(
                  "세",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(height: 1.4, letterSpacing: 0),
                )
              ],
            ),
            const SizedBox(height: 32),
            const SignUpInputTitle(title: "성별"),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () => signUpNotifier.setGender("male"),
                  child: genderButton(
                      text: "남자",
                      backgroundColor: signUpController.gender == "male"
                          ? TTColors.ttPurple
                          : Colors.white,
                      textColor: signUpController.gender == "male"
                          ? Colors.white
                          : TTColors.ttPurple,
                      borderColor: TTColors.ttPurple),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => signUpNotifier.setGender("female"),
                  child: genderButton(
                      text: "여자",
                      backgroundColor: signUpController.gender == "female"
                          ? TTColors.ttPurple
                          : Colors.white,
                      textColor: signUpController.gender == "female"
                          ? Colors.white
                          : TTColors.ttPurple,
                      borderColor: TTColors.ttPurple),
                ),
              ],
            ),
            const SizedBox(height: 31),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SignUpInputTitle(title: "나이 / 성별 공개"),
                SizedBox(
                  width: 40,
                  child: Switch(
                      overlayColor: MaterialStateProperty.resolveWith(
                        (final Set<MaterialState> states) {
                          return Colors.transparent;
                        },
                      ),
                      thumbColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return Colors.white;
                      }),
                      trackOutlineColor: MaterialStateProperty.resolveWith(
                        (final Set<MaterialState> states) {
                          return Colors.transparent;
                        },
                      ),
                      activeColor: TTColors.ttPurple,
                      activeTrackColor: TTColors.ttPurple.withOpacity(1.0),
                      inactiveTrackColor: TTColors.gray.withOpacity(1.0),
                      value: signUpController.isVisible ?? false,
                      onChanged: (value) {
                        signUpNotifier.setIsVisible(value);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _thirdPage(
      {required SignUpController signUpNotifier,
      required SignUpUser signUpController}) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SignUpTitle(title: "한줄소개를 작성해 주세요."),
            const SizedBox(height: 8),
            const SignUpSubTitle(
              message: "한줄소개는 언제든 수정할 수 있어요.",
            ),
            const SizedBox(height: 44),
            SignUpTextInput(
                controller: signUpNotifier.descriptionController,
                focusNode: signUpNotifier.descriptionFocus,
                hintText: "Ex) 홍대, 연남, 합정, 상수, 망원을 잘 압니다.\nMBTI는 ENFP 예요~")
          ],
        ),
      ),
    );
  }
}
