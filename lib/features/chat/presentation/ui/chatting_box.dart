import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

final intl.DateFormat koreamTimeForamt = intl.DateFormat('a hh:mm', 'ko_KR');
Widget chatBubbleBox(
    {required String message,
    Color backgroundColor = TTColors.gray100,
    Color textColor = Colors.black,
    int unread = 0,
    required DateTime time,
    bool reversed = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    textDirection: reversed ? TextDirection.rtl : TextDirection.ltr,
    children: [
      Flexible(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Text(message,
              softWrap: true, // 줄바꿈 허용
              overflow: TextOverflow.visible, // 넘친 텍스트 처리
              style: TTTextStyle.bodyMedium14.copyWith(
                  color: textColor,
                  height: 1.22,
                  letterSpacing: -0.3)), // 메시지 내용
        ),
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
          if (unread > 0)
            Text(
              unread.toString(),
              style: const TextStyle(
                  height: 0,
                  fontSize: 10,
                  color: TTColors.gray600,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal),
            ),
          Text(
            koreamTimeForamt.format(time),
            style: TTTextStyle.captionRegular10.copyWith(
                color: TTColors.gray600, letterSpacing: -0.3, height: 1.5),
          )
        ],
      )
    ],
  );
}
