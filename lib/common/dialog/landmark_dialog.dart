import 'dart:developer';

import 'package:chat_location/common/components/custom_buttom.dart';
import 'package:chat_location/common/components/network_image.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_tab_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_page_screen.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> landmarkDialog(BuildContext context, LandmarkInterface landmark,
    Future<void> Function() onTapPositive) {
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
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: widthRatio(40)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 원하는 반지름 설정
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: heightRatio(20),
                  left: widthRatio(20),
                  right: widthRatio(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    landmark.name,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        letterSpacing: -0.6, fontWeight: FontWeight.bold),
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
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: widthRatio(20), right: widthRatio(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: heightRatio(4),
                  ),
                  Text(
                    landmark.address ?? '',
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
                      // width: widthRatio(270),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: NetWorkImage(imagePath: landmark.imagePath))),
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
                  SizedBox(
                    height: heightRatio(1),
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
            ),
            SizedBox(
              height: heightRatio(30),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: widthRatio(20),
                  right: widthRatio(20),
                  bottom: heightRatio(18)),
              child: Row(
                children: [
                  CustomAnimatedButton(
                    width: widthRatio(92),
                    height: 52,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
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
                  Flexible(
                    child: CustomAnimatedButton(
                      width: double.infinity,
                      height: 52,
                      onPressed: () async {
                        Navigator.pop(context);
                        await onTapPositive();
                      },
                      child: Container(
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
            ),
          ],
        ),
      );
    },
  );
}
