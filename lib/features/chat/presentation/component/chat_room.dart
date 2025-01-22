import 'package:chat_location/common/ui/box/chat_room_box.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatRoomContainer extends ConsumerStatefulWidget {
  final String chatroomId;
  final ChatRoomInterface data;
  const ChatRoomContainer(
      {super.key, required this.chatroomId, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoomContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.pushNamed(ChatPage.pageName,
            pathParameters: {'id': widget.chatroomId});
        await ref
            .read(chattingControllerProvider.notifier)
            .enterAction(widget.chatroomId);
      },
      child: ChatRoomBox(type: ChatRoomBoxType.joined, data: widget.data),
    );
  }
}
