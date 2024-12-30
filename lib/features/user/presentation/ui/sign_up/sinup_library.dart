import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/theme.dart';
import 'package:chat_location/features/user/domain/entities/signup_user.dart';
import 'package:chat_location/features/user/presentation/provider/sign_up_user_controller.dart';
import 'package:flutter/material.dart';

class SignUpTitle extends StatelessWidget {
  const SignUpTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold, letterSpacing: -0.6, height: 1.28));
  }
}

class SignUpSubTitle extends StatelessWidget {
  const SignUpSubTitle({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(message,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: TTColors.gray, height: 1.2, letterSpacing: -0.3));
  }
}

class SignUpInputTitle extends StatelessWidget {
  const SignUpInputTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
          height: 1.4, letterSpacing: 0, fontWeight: FontWeight.w600),
    );
  }
}

class BottomBorderTextInput extends StatelessWidget {
  const BottomBorderTextInput(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.maxLength,
      this.isCounterVisible = true,
      this.keyboardType,
      this.enabled = true});
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLength;
  final bool isCounterVisible;
  final TextInputType? keyboardType;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      autofocus: true,
      keyboardType: keyboardType,
      controller: controller,
      focusNode: focusNode,
      cursorColor: TTColors.ttPurple,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.all(0),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: TTColors.gray), // 기본 상태 border 색상
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: TTColors.ttPurple,
          ), // 포커스된 상태 border 색상
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: TTColors.gray,
          ), // 활성화된 상태 border 색상
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: TTColors.gray,
          ), // 비활성화된 상태 border 색상
        ),
        suffix: isCounterVisible
            ? Padding(
                padding: EdgeInsets.only(right: widthRatio(18)),
                child: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, TextEditingValue value, child) {
                    return Text(
                      '${value.text.length}/${maxLength ?? 0}',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: TTColors.gray),
                      textAlign: TextAlign.end,
                    );
                  },
                ),
              )
            : null,
      ),
      maxLength: maxLength,
    );
  }
}

class SignUpTextInput extends StatelessWidget {
  const SignUpTextInput(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.hintText,
      this.maxLength = 40,
      this.maxLines = 4});
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLines;
  final int? maxLength;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      autocorrect: false,
      controller: controller,
      focusNode: focusNode,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        counterStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: TTColors.gray,
            fontSize: 13,
            height: 1.5,
            letterSpacing: -0.3),
        hintText: hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: TTColors.gray, height: 1.5, letterSpacing: -0.3),
        labelStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(height: 1.5, letterSpacing: -0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: TTColors.ttPurple,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: TTColors.gray4,
            )),
      ),
    );
  }
}

class SignUpSetNickName extends StatefulWidget {
  const SignUpSetNickName(
      {super.key,
      required this.signUpNotifier,
      required this.signUpController});
  final SignUpController signUpNotifier;
  final SignUpUser signUpController;
  @override
  State<SignUpSetNickName> createState() => _SignUpSetNickNameState();
}

class _SignUpSetNickNameState extends State<SignUpSetNickName> {
  bool _isValidating = false;

  Future<void> handleTapButton() async {
    setState(() {
      _isValidating = true;
    });
    await widget.signUpNotifier.isNickNameValid();
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
            controller: widget.signUpNotifier.nicknameController,
            focusNode: widget.signUpNotifier.nickNameFocus,
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
                    widget.signUpNotifier.nicknameController.text != ""
                        ? await handleTapButton()
                        : null;
                  },
                  child: nickNameValidationgButton(
                    isButtonValid:
                        widget.signUpNotifier.nicknameController.text != "",
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

Widget nickNameValidationgButton({bool isButtonValid = false}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
        color: isButtonValid ? TTColors.ttPurple : TTColors.gray6,
        borderRadius: BorderRadius.circular(5)),
    child: Align(
      alignment: Alignment.center,
      child: Text(
        "중복확인",
        style: TTTextTheme.lightTextTheme.labelMedium
            ?.copyWith(color: isButtonValid ? Colors.white : TTColors.gray),
      ),
    ),
  );
}
