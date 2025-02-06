import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/chat/presentation/component/chat_room.dart';
import 'package:flutter/material.dart';

Widget buildEmptyState(VoidCallback onRefresh) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "참여중인 채팅방이 없어요",
          textAlign: TextAlign.center,
          style: TTTextStyle.captionMedium12.copyWith(color: TTColors.gray400),
        ),
        IconButton(
          onPressed: onRefresh,
          icon: const Icon(Icons.replay_outlined, color: TTColors.gray400),
        ),
      ],
    ),
  );
}

Widget buildErrorState(String errorMessage, VoidCallback onRetry) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(errorMessage),
        IconButton(
          onPressed: onRetry,
          icon: const Icon(Icons.replay_outlined, color: TTColors.gray400),
        ),
      ],
    ),
  );
}

Widget buildChatList(
    {required List chatData,
    required ScrollController scrollController,
    bool isPrivate = false}) {
  chatData.sort((a, b) {
    if (a.active != b.active) {
      return (b.active ? 1 : 0) - (a.active ? 1 : 0);
    }

    if (a.lastMessageAt == null && b.lastMessageAt == null) {
      // 둘 다 null이면 순서를 유지
      return 0;
    } else if (a.lastMessageAt == null) {
      // dateA가 null이면 아래로
      return 1;
    } else if (b.lastMessageAt == null) {
      // dateB가 null이면 아래로
      return -1;
    }
    return b.lastMessageAt!.compareTo(a.lastMessageAt!);
  });
  return ListView.builder(
    controller: scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: chatData.length,
    itemBuilder: (context, index) {
      return ChatRoomContainer(
        chatroomId: chatData[index].chatroomId,
        data: chatData[index],
        isPrivate: isPrivate,
      );
    },
  );
}
