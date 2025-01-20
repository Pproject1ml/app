import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:chat_location/features/chat/presentation/ui/chatting_box.dart';
import 'package:flutter/material.dart';

class ChattingBoxWithImage extends StatelessWidget {
  const ChattingBoxWithImage(
      {super.key, required this.data, required this.isMyMessage});
  final ChatMessageInterface data;
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
                padding: EdgeInsets.only(bottom: heightRatio(3)),
                child: Text(data.profileId,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: TTColors.gray500)),
              ),
            chatBubbleBox(
                message: data.content,
                time: data.createdAt!,
                reversed: isMyMessage ? true : false)
          ],
        ),
      ],
    );
  }
}
