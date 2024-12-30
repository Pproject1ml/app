import 'package:chat_location/common/ui/box/chat_room_box.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/screen/chat_page_screen.dart';
import 'package:chat_location/pages/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatRoom extends ConsumerStatefulWidget {
  const ChatRoom({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        context.pushNamed(ChatPage.pageName, pathParameters: {'id': "123"})
      },
      child: Container(
        height: heightRatio(90),
        decoration: BoxDecoration(color: Theme.of(context).cardTheme.color),
        child: ChatRoomBox(
          type: ChatRoomBoxType.joined,
        ),
      ),
    );
  }
}
