import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';

Widget indexIndicator(int currentPage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? TTColors.ttPurple : TTColors.gray4),
      );
    }),
  );
}
