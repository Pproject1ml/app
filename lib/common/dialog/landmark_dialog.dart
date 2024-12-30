import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/map/domain/entities/chat_room.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:flutter/material.dart';

Future<void> landmarkDialog(BuildContext context, ChatRoom_? chatRoom) {
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
              chatRoom?.landmark.name ?? 'null',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              width: widthRatio(8),
            ),
            Image.asset(
              'assets/images/people_alt.png',
              height: 18,
              width: 18,
            ),
            SizedBox(
              width: widthRatio(4),
            ),
            Text("999+",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: TTColors.gray))
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatRoom?.landmark.name ?? "null",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: TTColors.gray),
            ),
            SizedBox(
              height: heightRatio(16),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), // 원하는 반지름 설정
                image: DecorationImage(
                  image: AssetImage('assets/images/test_img.png'),
                  fit: BoxFit.cover, // 이미지 비율 유지
                ),
              ),
              height: heightRatio(150),
              width: widthRatio(270),
            ),
            SizedBox(
              height: heightRatio(20),
            ),
            Row(
              children: [
                Text(
                  "내 위치에서",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text("300m ",
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
                Text("999명 이상",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: TTColors.ttPurple)),
                Text(
                  "의 사람들이 채팅에 참여하고 있어요.",
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
                      color: TTColors.gray5,
                      borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: Text(
                    "취소",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: TTColors.gray),
                  ),
                ),
              ),
              SizedBox(
                width: widthRatio(8),
              ),
              Expanded(
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
            ],
          ),
        ],
      );
    },
  );
}
