import 'package:chat_location/common/dialog/landmark_dialog.dart';
import 'package:chat_location/common/ui/box/chat_room_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoom extends ConsumerStatefulWidget {
  const ChatRoom({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {
  void _onClickButton() {
    landmarkDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClickButton,
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: TTColors.gray5, // 테두리 색상
                width: 1.0, // 테두리 두께
              ),
            ),
          ),
          child: SizedBox(
            height: heightRatio(80),
            child: ChatRoomBox(
              type: ChatRoomBoxType.available,
            ),
          )),
    );
  }
}
