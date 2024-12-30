import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/ui/chat_bubble_box.dart';
import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key, required this.text});
  final String text;
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection:  TextDirection.ltr,
      children: [
        roundUserImageBox(),
        const SizedBox(width: 6,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text("user123", style: Theme.of(context).textTheme.labelSmall?.copyWith(color:TTColors.gray )),
            ),
            chatBubbleBox(message: text,time: DateTime.now(), reversed: false)
          ],
        ),
      ],
    );
  }
}
