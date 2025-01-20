import 'dart:developer';

import 'package:chat_location/common/components/network_image.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_tab_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_page_screen.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> landmarkDialog(BuildContext context, LandmarkInterface landmark) {
  final String count = landmark.chatroom == null
      ? "0"
      : landmark.chatroom!.count >= 1000
          ? "999+"
          : landmark.chatroom!.count.toString();
  final String distance = landmark.chatroom?.distance == null
      ? "5km"
      : landmark.chatroom!.distance! < 1000
          ? "${landmark.chatroom?.distance}m"
          : "${((landmark.chatroom!.distance!) / 1000).toInt()}km";
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 원하는 반지름 설정
        ),
        contentPadding: EdgeInsets.all(widthRatio(20)),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              landmark.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              width: widthRatio(8),
            ),
            Image.asset(
              'assets/images/people_alt.png',
              height: 18,
              width: 18,
              color: TTColors.gray600,
            ),
            SizedBox(
              width: widthRatio(4),
            ),
            Text(count,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: TTColors.gray600))
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              landmark.name,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: TTColors.gray500),
            ),
            SizedBox(
              height: heightRatio(16),
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4), // 원하는 반지름 설정
                ),
                height: heightRatio(150),
                width: double.infinity,
                child: NetWorkImage(imagePath: landmark.imagePath)),
            SizedBox(
              height: heightRatio(20),
            ),
            Row(
              children: [
                Text(
                  "내 위치에서",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(distance,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: TTColors.ttPurple)),
                Text(
                  "거리에 있어요.",
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
            Row(
              children: [
                Text(count,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: TTColors.ttPurple)),
                Text(
                  "명 의 사람들이 채팅에 참여하고 있어요.",
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              GestureDetector(
                onTap: () => {Navigator.of(context).pop()},
                child: Container(
                  width: widthRatio(92),
                  height: 52,
                  decoration: BoxDecoration(
                      color: TTColors.gray300,
                      borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: Text(
                    "닫기",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: TTColors.gray500),
                  ),
                ),
              ),
              SizedBox(
                width: widthRatio(8),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(
                      ChatScreen.pageName,
                    );

                    context.pushNamed(ChatPage.pageName,
                        pathParameters: {'id': "10"});
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                        color: TTColors.ttPurple,
                        borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: Text(
                      "채팅방 입장하기",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
