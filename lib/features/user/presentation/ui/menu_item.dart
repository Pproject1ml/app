import 'package:chat_location/common/components/async_button.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:flutter/material.dart';

Widget mypageMenuItem({
  required String title,
  Widget? trailing,
  String? subTitle,
  Future<void> Function()? onTap,
  Color? backgroundColor,
  Color? textColor,
}) {
  return AsyncButton(
    onClick: () async {
      if (onTap != null) {
        await onTap();
      }
    },
    child: ListTile(
      tileColor: backgroundColor,
      // leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: TTTextStyle.bodyMedium16.copyWith(color: textColor),
      ),
      subtitle: subTitle != null
          ? Text(
              subTitle,
              style: TTTextStyle.captionRegular10
                  .copyWith(color: TTColors.gray600),
            )
          : null,
      trailing: trailing,
    ),
  );
}
