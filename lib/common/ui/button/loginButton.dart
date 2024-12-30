import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';

Widget squareLoginButton({required Widget child, Color? backgroundColor}) {
  return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: backgroundColor),
      height: heightRatio(54),
      child: child);
}
