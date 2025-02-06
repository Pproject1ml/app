import 'package:chat_location/common/ui/box/chat_room_box.dart';
import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_page_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/personal_chat_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatRoomContainer extends ConsumerStatefulWidget {
  final String chatroomId;
  final ChatRoomInterface data;
  final bool isPrivate;
  const ChatRoomContainer(
      {super.key,
      required this.chatroomId,
      required this.data,
      this.isPrivate = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoomContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.isPrivate) {
          context.pushNamed(PersonalChatPage.pageName,
              pathParameters: {'id': widget.chatroomId});
        } else {
          if (widget.data.active) {
            context.pushNamed(ChatPage.pageName,
                pathParameters: {'id': widget.chatroomId});
          } else {
            showSnackBar(
                context: context,
                message: "채팅방에 참여할 수 있는 위치가 아닙니다.",
                type: SnackBarType.warning);
          }
        }
      },
      child: ChatRoomBox(
        type: ChatRoomBoxType.joined,
        data: widget.data,
        backgroundColor: Theme.of(context).cardColor,
      ),
    );
  }
}
