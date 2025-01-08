import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/features/chat/presentation/ui/chat_bubble_box.dart';
import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key, required this.data, required this.isMyMessage});
  final ChatMessage data;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: isMyMessage ? TextDirection.rtl : TextDirection.ltr,
      children: [
        roundUserImageBox(),
        const SizedBox(
          width: 6,
        ),
        Column(
          crossAxisAlignment:
              isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMyMessage)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(data.senderId,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: TTColors.gray)),
              ),
            chatBubbleBox(
                message: data.message,
                time: data.timestamp,
                reversed: isMyMessage ? true : false)
          ],
        ),
      ],
    );
  }
}
