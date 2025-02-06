import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:flutter/material.dart';

enum SnackBarType { warning, alert, success }

void showSnackBar(
    {required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.alert}) {
  final Color _backgrounColor = type == SnackBarType.alert
      ? TTColors.gray500
      : type == SnackBarType.warning
          ? TTColors.red
          : type == SnackBarType.success
              ? TTColors.ttPurple
              : TTColors.black;
  final Color _textColor = type == SnackBarType.alert
      ? TTColors.white
      : type == SnackBarType.warning
          ? TTColors.black
          : type == SnackBarType.success
              ? TTColors.black
              : TTColors.white;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: _backgrounColor,
      content: Text(
        message,
        style: TTTextStyle.captionMedium12.copyWith(
          color: _textColor,
        ),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}
