import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';

Widget bottomNextButton(
    {bool isDisabled = false, required void Function()? onPressed}) {
  return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? TTColors.gray5 : TTColors.ttPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 52),
      ),
      child: Text(
        "확인",
        style: TextStyle(
            fontSize: 16,
            color: isDisabled ? TTColors.gray : Colors.white,
            letterSpacing: -0.3,
            height: 1.22,
            fontWeight: FontWeight.normal),
      ));
}
