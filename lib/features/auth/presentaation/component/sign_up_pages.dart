import 'dart:developer';

import 'package:chat_location/common/ui/box/text_field.dart';
import 'package:chat_location/common/ui/text_input/bottom_border_text_input.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/auth/dmain/entities/signup.dart';
import 'package:chat_location/features/auth/presentaation/UI/gender_button.dart';
import 'package:chat_location/features/auth/presentaation/UI/sinup_library.dart';
import 'package:chat_location/features/auth/presentaation/provider/sign_up_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage1 extends ConsumerWidget {
  const SignUpPage1({super.key, required this.notifier, required this.state});
  final SignUpInterface state;
  final SignUpFormControllerT notifier;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            SignUpNicknameContainer(
              notifier: notifier,
              state: state,
            )
          ],
        ),
      ),
    );
  }
}

class SignUpPage2 extends ConsumerWidget {
  const SignUpPage2({super.key, required this.notifier, required this.state});
  final SignUpInterface state;
  final SignUpFormControllerT notifier;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      controller: notifier.ageController,
                      focusNode: notifier.ageFocus,
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
                  onTap: () => notifier.setGender("male"),
                  child: genderButton(
                      text: "남자",
                      backgroundColor: state.gender == "male"
                          ? TTColors.ttPurple
                          : Colors.white,
                      textColor: state.gender == "male"
                          ? Colors.white
                          : TTColors.ttPurple,
                      borderColor: TTColors.ttPurple),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => notifier.setGender("female"),
                  child: genderButton(
                      text: "여자",
                      backgroundColor: state.gender == "female"
                          ? TTColors.ttPurple
                          : Colors.white,
                      textColor: state.gender == "female"
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
                      inactiveTrackColor: TTColors.gray300.withOpacity(1.0),
                      value: state.isVisible ?? false,
                      onChanged: (value) {
                        notifier.setIsVisible(value);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage3 extends ConsumerWidget {
  const SignUpPage3({super.key, required this.notifier, required this.state});
  final SignUpInterface state;
  final SignUpFormControllerT notifier;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            CustomTextField(
                onTapOutsideAutoFocuseOut: false,
                controller: notifier.descriptionController,
                focusNode: notifier.descriptionFocus,
                hintText: "Ex) 홍대, 연남, 합정, 상수, 망원을 잘 압니다.\nMBTI는 ENFP 예요~")
          ],
        ),
      ),
    );
  }
}

class SignUpNicknameContainer extends StatefulWidget {
  const SignUpNicknameContainer(
      {super.key, required this.notifier, required this.state});
  final SignUpFormControllerT notifier;
  final SignUpInterface state;
  @override
  State<SignUpNicknameContainer> createState() =>
      _SignUpNicknameContainerState();
}

class _SignUpNicknameContainerState extends State<SignUpNicknameContainer> {
  bool _isValidating = false;

  Future<void> handleTapButton() async {
    setState(() {
      _isValidating = true;
    });

    await widget.notifier.isNickNameValid();

    setState(() {
      _isValidating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightRatio(48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: BottomBorderTextInput(
            controller: widget.notifier.nicknameController,
            focusNode: widget.notifier.nickNameFocus,
            isCounterVisible: true,
            maxLength: 10,
            enabled: !_isValidating,
          )),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            width: widthRatio(82),
            height: heightRatio(48),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    widget.notifier.nicknameController.text != ""
                        ? await handleTapButton()
                        : null;
                  },
                  child: nickNameValidationgButton(
                    isButtonValid:
                        widget.notifier.nicknameController.text != "",
                  ),
                ),
                if (_isValidating)
                  Positioned.fill(
                    child: Stack(
                      children: [
                        // 흐린 배경 추가
                        Container(
                          color: Colors.black.withOpacity(0.5), // 배경 흐리기
                        ),
                        // 로딩 인디케이터
                        const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
