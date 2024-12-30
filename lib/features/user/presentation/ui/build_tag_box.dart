 import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/theme.dart';
import 'package:flutter/material.dart';

Widget buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: TTColors.ttPurple),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style:TTTextTheme.lightTextTheme.labelSmall?.copyWith(color: TTColors.ttPurple)
      ),
    );
  }