import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';


Widget chatEventBox(String eventMessage){
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
        color: TTColors.chatEventBgColor
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Text(eventMessage, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),),
        ),
      ),
    ],
  );
}