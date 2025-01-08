import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget chatBubbleBox(
    {required String message,
    Color backgroundColor = TTColors.gray6,
    Color textColor = Colors.black,
    int unread = -1,
    required DateTime time,
    bool reversed = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    textDirection: reversed ? TextDirection.rtl : TextDirection.ltr,
    children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: backgroundColor),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Text(message,
            style: TTTextTheme.lightTextTheme.labelMedium
                ?.copyWith(color: textColor)),
      ),
      SizedBox(
        width: widthRatio(4),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment:
            reversed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            unread.toString(),
            style: const TextStyle(
                height: 0,
                fontSize: 10,
                color: TTColors.gray,
                letterSpacing: 0,
                fontWeight: FontWeight.normal),
          ),
          Text(
            timeago.format(time, locale: "ko"),
            style: const TextStyle(
                height: 0,
                fontSize: 10,
                color: TTColors.gray200,
                letterSpacing: -0,
                fontWeight: FontWeight.normal),
          )
        ],
      )
    ],
  );
}
