import 'package:chat_location/common/components/network_image.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';

Widget roundUserImageBox({
  String? imageUrl,
  double size = 40,
}) {
  return SizedBox(
      height: widthRatio(size),
      width: widthRatio(size),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: NetWorkImage(
          imagePath: imageUrl,
          defaultImage: defaultImage(size),
        ),
      ));
}

Widget defaultImage(double size) {
  return CircleAvatar(
    backgroundColor: TTColors.gray100,
    child: Icon(
      Icons.person,
      color: TTColors.gray500,
      size: widthRatio(size / 1.2),
    ),
  );
}
