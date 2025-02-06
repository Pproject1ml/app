import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:flutter/material.dart';

class RoundTextInput extends StatelessWidget {
  const RoundTextInput(
      {super.key,
      this.hitnTextStyle,
      this.labelTextStyle,
      required this.controller,
      required this.focusNode,
      this.maxLength,
      this.isCounterVisible = true,
      this.keyboardType,
      this.enabled = true,
      this.autofocus = true,
      this.hintText,
      this.maxLines,
      this.minLines = 1});
  final TextStyle? hitnTextStyle;
  final TextStyle? labelTextStyle;
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLength;
  final bool isCounterVisible;
  final TextInputType? keyboardType;
  final bool autofocus;
  final bool enabled;
  final String? hintText;
  final int? maxLines;
  final int minLines;
  @override
  Widget build(BuildContext context) {
    final darkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return TextField(
      maxLines: maxLines ?? minLines,
      minLines: maxLines,
      controller: controller,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      focusNode: focusNode,
      cursorColor: TTColors.chatEventBgColor,
      decoration: InputDecoration(
        hintText: hintText ?? "참여자 검색하기",
        labelStyle: labelTextStyle ??
            TTTextStyle.captionMedium12.copyWith(
                letterSpacing: -0.3,
                height: 1.22,
                color: darkMode ? TTColors.white : TTColors.gray600),
        hintStyle: hitnTextStyle ??
            TTTextStyle.captionMedium12.copyWith(
                letterSpacing: -0.3,
                height: 1.22,
                color: darkMode ? TTColors.white : TTColors.gray600),
        isCollapsed: true,
        filled: true,
        fillColor: darkMode ? TTColors.gray600 : TTColors.gray100,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50),
        ),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            size: 20, // 아이콘 크기
          ),
        ),
      ),

      style: labelTextStyle ??
          TTTextStyle.captionMedium12.copyWith(
              letterSpacing: -0.3,
              height: 1.22,
              color: darkMode ? TTColors.white : TTColors.gray600),
      textAlignVertical: TextAlignVertical.center, // Center-align text
    );
  }
}
