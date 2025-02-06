import 'package:chat_location/common/ui/box/rounded_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';

Widget openListButton(
    {bool isOpened = false, TextStyle? textStyle, Color? iconColor}) {
  return Opacity(
    opacity: isOpened ? 0.6 : 1,
    child: SizedBox(
      width: widthRatio(93),
      child: RoundedContainer(
          radius: 8,
          backgroundColor: TTColors.ttPurple,
          child: Padding(
            padding: EdgeInsets.only(
                top: heightRatio(3),
                bottom: heightRatio(3),
                left: widthRatio(14),
                right: widthRatio(8)),
            child: SizedBox(
              child: Row(
                children: [
                  (Text(isOpened ? '목록닫기' : '목록열기', style: textStyle)),
                  AnimatedRotation(
                    turns: isOpened ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: iconColor,
                      size: widthRatio(15),
                    ),
                  )
                ],
              ),
            ),
          )),
    ),
  );
}
