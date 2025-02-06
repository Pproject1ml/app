import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/common/ui/box/rounded_with_sharp_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:flutter/material.dart';

Widget userProfile({
  required ProfileInterface profile,
  required Color backgroundColor,
  required Color textColor,
}) {
  return Container(
    width: double.infinity,
    color: backgroundColor,
    padding:
        const EdgeInsets.only(top: 24, bottom: 32, left: 50.5, right: 50.5),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        roundUserImageBox(
          imageUrl: profile.profileImage,
          size: 134,
        ),
        const SizedBox(height: 12),
        // 이름과 나이
        Column(
          children: [
            Text(
              profile.nickname,
              style: TTTextStyle.bodyBold18
                  .copyWith(height: 1.22, color: textColor),
            ),
            const SizedBox(height: 2),
            profile.isVisible
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (profile.age != null)
                        Text(
                          '${profile.age}세',
                          style: TTTextStyle.bodyMedium14.copyWith(
                              letterSpacing: -0.3,
                              height: 1.22,
                              color: TTColors.gray500),
                        ),
                      if (profile.gender != null)
                        Text(
                          profile.gender == "male" ? "남자" : "여자",
                          style: TTTextStyle.bodyMedium14.copyWith(
                              letterSpacing: -0.3,
                              height: 1.22,
                              color: TTColors.gray500),
                        ),
                    ],
                  )
                : Text(
                    "나이 성별 비공개",
                    style: TTTextStyle.bodyMedium14.copyWith(
                        letterSpacing: -0.3,
                        height: 1.22,
                        color: TTColors.gray500),
                  ),
          ],
        ),
        const SizedBox(height: 4),
        // 소개글
        if (profile.introduction != null)
          roundedWithSharp(
            profile.introduction ?? '',
          ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
