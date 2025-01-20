import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';

class RoundTextInput extends StatelessWidget {
  const RoundTextInput(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.maxLength,
      this.isCounterVisible = true,
      this.keyboardType,
      this.enabled = true,
      this.autofocus = true,
      this.hintText});
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLength;
  final bool isCounterVisible;
  final TextInputType? keyboardType;
  final bool autofocus;
  final bool enabled;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      focusNode: focusNode,
      cursorColor: TTColors.chatEventBgColor,
      decoration: InputDecoration(
        hintText: "참여자 검색하기",
        isCollapsed: true,
        filled: true,
        fillColor: Color(0xFFF6F6FA),
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

      style: Theme.of(context).textTheme.labelSmall,
      textAlignVertical: TextAlignVertical.center, // Center-align text
    );
  }
}
