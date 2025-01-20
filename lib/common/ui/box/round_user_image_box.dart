import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';

Widget roundUserImageBox(
    {String? imageUrl, double size = 40, bool editable = false}) {
  return Stack(
    children: [
      SizedBox(
        height: widthRatio(size),
        width: widthRatio(size),
        child: CircleAvatar(
          backgroundColor: TTColors.gray100,
          child: Icon(
            Icons.person,
            color: TTColors.gray500,
            size: widthRatio(size / 1.2),
          ),
        ),
      ),
      if (editable)
        const Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(Icons.camera_alt, size: 18, color: Colors.grey),
          ),
        ),
    ],
  );
}
