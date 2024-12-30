import 'package:flutter/material.dart';

Widget genderButton(
    {required String text,
    required Color textColor,
    required Color backgroundColor,
    required Color borderColor}) {
  return Container(
    decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor)),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            height: 1.4),
      ),
    ),
  );
}
