import 'package:chat_location/common/components/custom_buttom.dart';
import 'package:chat_location/common/components/network_image.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:flutter/material.dart';

Future<void> landmarkDialog(BuildContext context, LandmarkInterface landmark,
    Future<void> Function()? onTapPositive) {
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
                    style: TTTextStyle.bodyBold20.copyWith(
                        fontSize: 24,
                        letterSpacing: -0.6,
                        height: 1.28,
                        color: Theme.of(context).textTheme.labelLarge?.color),
                  ),
                  SizedBox(
                    width: widthRatio(8),
                  ),
                  Image.asset(
                    'assets/images/people_alt.png',
                    height: widthRatio(18),
                    width: widthRatio(18),
                    color: TTColors.gray600,
                  ),
                  SizedBox(
                    width: widthRatio(4),
                  ),
                  Text(count,
                      style: TTTextStyle.bodyMedium14.copyWith(
                          color: TTColors.gray600,
                          letterSpacing: 0.3,
                          height: 1.22))
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
                    style: TTTextStyle.captionMedium12
                        .copyWith(color: TTColors.gray500, letterSpacing: -0.3),
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
                      Text("내 위치에서",
                          style: TTTextStyle.bodyRegular14.copyWith(
                              color:
                                  Theme.of(context).textTheme.labelLarge?.color,
                              letterSpacing: -0.3,
                              height: 1.22)),
                      Text(distance,
                          style: TTTextStyle.bodyRegular14.copyWith(
                              color: TTColors.ttPurple,
                              letterSpacing: -0.3,
                              height: 1.22)),
                      Text("이내에 있어요.",
                          style: TTTextStyle.bodyRegular14.copyWith(
                              color:
                                  Theme.of(context).textTheme.labelLarge?.color,
                              letterSpacing: -0.3,
                              height: 1.22))
                    ],
                  ),
                  SizedBox(
                    height: heightRatio(1),
                  ),
                  Row(
                    children: [
                      Text(count,
                          style: TTTextStyle.bodyRegular14.copyWith(
                              color: TTColors.ttPurple,
                              letterSpacing: -0.3,
                              height: 1.22)),
                      Text(" 명 의 사람들이 채팅에 참여하고 있어요.",
                          style: TTTextStyle.bodyRegular14.copyWith(
                              color:
                                  Theme.of(context).textTheme.labelLarge?.color,
                              letterSpacing: -0.3,
                              height: 1.22))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: heightRatio(30),
            ),
            if (onTapPositive != null)
              Padding(
                padding: EdgeInsets.only(
                    left: widthRatio(20),
                    right: widthRatio(20),
                    bottom: heightRatio(18)),
                child: Row(
                  children: [
                    CustomAnimatedButton(
                      width: widthRatio(92),
                      height: heightRatio(52),
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
                          style: TTTextStyle.bodyMedium16.copyWith(
                              letterSpacing: -0.3,
                              height: 1.22,
                              color: TTColors.gray500),
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
                            style: TTTextStyle.bodyMedium16.copyWith(
                                letterSpacing: -0.3,
                                height: 1.22,
                                color: Colors.white),
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
