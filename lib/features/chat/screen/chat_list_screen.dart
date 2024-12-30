import 'package:chat_location/common/ui/box/chat_room_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/component/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat'; // routeName 정의
  static const String pageName = " caht";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TTColors.backgroundSecondary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "채팅",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: -0.4),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0), // 하단 영역 높이
          child: Container(
            color: TTColors.gray200, // 하단 테두리 색상
            height: 1.0, // 테두리 두께
          ),
        ),
      ),
      body: SafeArea(child: ChatList()),
    );
  }
}
