import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:flutter/material.dart';

Widget chattingJoinBox(String actionType, ProfileInterface? senderInfo) {
  final String suffixMessage = actionType == "JOIN"
      ? "님이 입장하였습니다."
      : actionType == "DIE"
          ? "님이 퇴장하였습니다."
          : "";

  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: TTColors.gray400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Text(
            senderInfo?.nickname ?? "익명의 누군가$suffixMessage",
            style: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}
