import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:flutter/material.dart';

class BottomBorderTextInput extends StatelessWidget {
  const BottomBorderTextInput(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.maxLength,
      this.isCounterVisible = true,
      this.keyboardType,
      this.errorMessage,
      this.helperText,
      this.enabled = true,
      this.autofocus = true});
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLength;
  final bool isCounterVisible;
  final TextInputType? keyboardType;
  final bool autofocus;
  final bool enabled;
  final String? helperText;
  final String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      autofocus: autofocus,
      keyboardType: keyboardType,
      controller: controller,
      focusNode: focusNode,
      cursorColor: TTColors.ttPurple,
      style: TTTextStyle.bodyRegular18.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          letterSpacing: -0,
          height: 1.8),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.all(0),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: TTColors.gray500), // 기본 상태 border 색상
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: TTColors.ttPurple,
          ), // 포커스된 상태 border 색상
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: TTColors.gray500,
          ), // 활성화된 상태 border 색상
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: TTColors.gray500,
          ), // 비활성화된 상태 border 색상
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: TTColors.red,
          ), // 비활성화된 상태 border 색상
        ),
        helperStyle:
            TTTextStyle.captionRegular12.copyWith(color: TTColors.ttPurple),
        errorText: errorMessage,
        helperText: helperText,
        suffix: isCounterVisible
            ? Padding(
                padding: EdgeInsets.only(right: widthRatio(18)),
                child: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, TextEditingValue value, child) {
                    return Text(
                      '${value.text.length}/${maxLength ?? 0}',
                      style: TTTextStyle.captionRegular12.copyWith(
                          color: TTColors.gray500, letterSpacing: -0.3),
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
