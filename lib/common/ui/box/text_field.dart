import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
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
