import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/theme.dart';

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
