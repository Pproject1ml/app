import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:flutter/material.dart';

Widget chattingJoinBox(String actionType, ChatMessageInterface message) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: TTColors.gray200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Text(
            message.content,
            style: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}
