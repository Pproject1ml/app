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
        color: isDisabled ? TTColors.gray5 : TTColors.ttPurple,
        borderRadius: BorderRadius.circular(8)),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: isDisabled ? TTColors.gray : Colors.white,
            letterSpacing: -0.3,
            height: 1.22,
            fontWeight: FontWeight.normal),
      ),
    ),
  );
}

Widget bottomNextButton(
    {bool isDisabled = false,
    required String text,
    required Function onPressed}) {
  return ElevatedButton(
      onPressed: () async {
        isDisabled ? null : await onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? TTColors.gray5 : TTColors.ttPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 52),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: isDisabled ? TTColors.gray : Colors.white,
            letterSpacing: -0.3,
            height: 1.22,
            fontWeight: FontWeight.normal),
      ));
}
