import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';

Widget bottomNextButtonT({
  bool isDisabled = false,
  required String text,
}) {
  return Container(
    height: heightRatio(52),
    decoration: BoxDecoration(
        color: isDisabled ? TTColors.gray200 : TTColors.ttPurple,
        borderRadius: BorderRadius.circular(8)),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: isDisabled ? TTColors.gray500 : Colors.white,
            letterSpacing: -0.3,
            height: 1.22,
            fontWeight: FontWeight.normal),
      ),
    ),
  );
}
