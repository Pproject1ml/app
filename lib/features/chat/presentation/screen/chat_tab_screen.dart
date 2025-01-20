import 'dart:developer';

import 'package:chat_location/common/utils/is_within_radius.dart';
import 'package:chat_location/common/utils/permissions.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/controller/location_controller.dart';

import 'package:chat_location/features/chat/presentation/component/chat_room.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat'; // routeName 정의
  static const String pageName = " caht";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _isLoading = true; // 로딩 상태를 관리
  late final _scrollController;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(chattingControllerProvider.notifier);
    final data = ref.watch(chattingControllerProvider);
    final position = ref.watch(positionProvider);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: TTColors.gray100,
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
        body: data.when(
            data: (_data) {
              return SafeArea(
                  child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: notifier.refreshAction,
                      child: _data.isEmpty
                          ? SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "참여중인 채팅방이 없어요",
                                    textAlign: TextAlign.center,
                                    style: TTTextStyle.captionMedium12
                                        .copyWith(color: TTColors.gray400),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        notifier.refreshAction();
                                      },
                                      icon: const Icon(
                                        Icons.replay_outlined,
                                        color: TTColors.gray400,
                                      ))
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: _data.length,
                              itemBuilder: (context, index) {
                                return ChatRoomContainer(
                                  chatroomId: _data[index].chatroomId,
                                  data: _data[index],
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ));
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (e, s) => SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(e.toString()),
                      IconButton(
                          onPressed: () {
                            notifier.refreshAction();
                          },
                          icon: const Icon(
                            Icons.replay_outlined,
                            color: TTColors.gray400,
                          ))
                    ],
                  ),
                )));
  }
}
