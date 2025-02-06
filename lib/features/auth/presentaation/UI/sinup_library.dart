import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/text_style.dart';

import 'package:chat_location/constants/theme.dart';

import 'package:flutter/material.dart';

class SignUpTitle extends StatelessWidget {
  const SignUpTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TTTextStyle.headingBold24.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            letterSpacing: -0.6,
            height: 1.28));
  }
}

class SignUpSubTitle extends StatelessWidget {
  const SignUpSubTitle({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(message,
        style: TTTextStyle.bodyMedium14.copyWith(
            color: TTColors.gray500, letterSpacing: -0.3, height: 1.22));
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

class SignUpTextInput extends StatelessWidget {
  const SignUpTextInput(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.hintText,
      this.maxLength = 40,
      this.maxLines = 4,
      this.onTapOutsideAutoFocuseOut = true});
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLines;
  final int? maxLength;
  final String hintText;
  final bool onTapOutsideAutoFocuseOut;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        if (onTapOutsideAutoFocuseOut) FocusScope.of(context).unfocus();
      },
      autocorrect: false,
      controller: controller,
      focusNode: focusNode,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        counterStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: TTColors.gray500,
            fontSize: 13,
            height: 1.5,
            letterSpacing: -0.3),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: TTColors.gray600, height: 1.5, letterSpacing: -0.3),
        labelStyle: TTTextStyle.bodyRegular18.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            letterSpacing: -0,
            height: 1.8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: TTColors.ttPurple,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: TTColors.gray300,
            )),
      ),
      style: TTTextStyle.bodyRegular18.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          letterSpacing: -0,
          height: 1.8),
    );
  }
}

Widget nickNameValidationgButton({bool isButtonValid = false}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
        color: isButtonValid ? TTColors.ttPurple : TTColors.gray100,
        borderRadius: BorderRadius.circular(5)),
    child: Align(
      alignment: Alignment.center,
      child: Text(
        "중복확인",
        style: lightTextTheme.labelMedium
            ?.copyWith(color: isButtonValid ? Colors.white : TTColors.gray500),
      ),
    ),
  );
}
