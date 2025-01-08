import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/core/newtwork/socket_client.dart';
import 'package:chat_location/features/chat/presentation/component/hive_test.dart';
import 'package:chat_location/features/chat/presentation/provider/chat_room_controller.dart';
import 'package:chat_location/features/chat/presentation/provider/socket_controller.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat'; // routeName 정의
  static const String pageName = " caht";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _isLoading = true; // 로딩 상태를 관리

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(chatRoomControllerProvider);
    final notifier = ref.read(chatRoomControllerProvider.notifier);
    return Scaffold(
      backgroundColor: TTColors.gray6,
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
      body: SafeArea(child: HiveTest()
          // ChatList()
          ),
    );
  }

  Widget _socketTest() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
            onTap: () async {},
            child: Container(
              height: 100,
              width: 500,
              color: Colors.red,
            )),
        TextField(
          onSubmitted: (value) {},
        ),
        GestureDetector(
            onTap: () async {},
            child: Container(
              height: 100,
              width: 500,
              color: Colors.red,
            )),
        GestureDetector(
            onTap: () async {},
            child: Container(
              height: 100,
              width: 500,
              color: Colors.blue,
            )),
      ],
    );
  }
}
