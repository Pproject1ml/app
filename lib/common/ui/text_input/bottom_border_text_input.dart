import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';

class BottomBorderTextInput extends StatelessWidget {
  const BottomBorderTextInput(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.maxLength,
      this.isCounterVisible = true,
      this.keyboardType,
      this.enabled = true,
      this.autofocus = true});
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLength;
  final bool isCounterVisible;
  final TextInputType? keyboardType;
  final bool autofocus;
  final bool enabled;
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
                          ?.copyWith(color: TTColors.gray500),
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
