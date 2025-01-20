import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat koreanDateFormat = DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR');
Widget chattingDateBox(ChatMessageInterface message) {
  try {
    final DateTime date = DateTime.parse(message.content);
    final String korFormattedDate = koreanDateFormat.format(date);

    return Padding(
      padding: EdgeInsets.only(bottom: heightRatio(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: TTColors.gray400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Text(
                korFormattedDate,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  } catch (e, s) {
    log(e.toString() + s.toString());
    return const SizedBox.shrink();
  }
}
