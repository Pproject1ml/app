import 'package:chat_location/common/ui/box/chat_room_box.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/presentation/component/chat_room.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  late final _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return ChatRoomContainer();
      },
    );
  }
}
