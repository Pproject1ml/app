import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/presentation/provider/chat_message_controller.dart';
import 'package:chat_location/features/chat/presentation/ui/chat_box.dart';
import 'package:chat_location/features/chat/presentation/ui/chat_bubble_box.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HiveChatPage extends ConsumerStatefulWidget {
  final String roomNumber;
  const HiveChatPage({super.key, required this.roomNumber});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HiveChatPageState();
}

class _HiveChatPageState extends ConsumerState<HiveChatPage> {
  late final ScrollController _scrollController;
  late final FocusNode _focusNode;
  final TextEditingController _controller =
      TextEditingController(); // 텍스트 입력 컨트롤러
  final TextEditingController _controller2 =
      TextEditingController(); // 텍스트 입력 컨트롤러
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAtTop = false;
  Future<void> _sendMessage(String userId) async {
    if (_controller.text.trim().isEmpty) return;
    final message = _controller.text;
    await ref
        .read(chatMessagesProvider((widget.roomNumber)).notifier)
        .sendMessage(message, userId);
    _controller.clear();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() async {
    if (_scrollController.hasClients) {
      log('바닥으로 갑니다');
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendNotMeMessage(String userId) async {
    if (_controller2.text.trim().isEmpty) return;
    final message = _controller2.text;
    await ref
        .read(chatMessagesProvider((widget.roomNumber)).notifier)
        .sendMessage(message, userId);
    _controller2.clear();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      log("event");
      if (!isAtTop) {
        ref.read(chatMessagesProvider(widget.roomNumber).notifier).loadMore();
        setState(() {
          isAtTop = true; // 맨 위 상태로 변경
        });
      }
    } else {
      if (isAtTop) {
        setState(() {
          isAtTop = false; // 맨 위 상태가 아님
        });
      }
    }
  }

  void _onFocusChange() {
    log('focus lisetener');
    if (_focusNode.hasFocus) {
      // 키보드가 열렸을 때 아래로 스크롤
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _onTapChatScreen() {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("message");
    final data = ref.watch(chatMessagesProvider(widget.roomNumber));
    final notifier =
        ref.read(chatMessagesProvider((widget.roomNumber)).notifier);
    final user = ref.watch(userProvider);
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _onTapChatScreen,
            child: Container(
              height: double.infinity,
              color: Colors.transparent,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    reverse: true, // 역순으로 렌더링
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final chatData = data[index];

                      // 이전 데이터와 비교
                      final isSameSender = index < data.length - 1 &&
                          data[index + 1].senderId == chatData.senderId;

                      // 현재 메시지가 본인의 메시지인지 확인
                      final isMyMessage =
                          chatData.senderId == (user?.memberId ?? 'me');

                      if (isMyMessage) {
                        return ListTile(
                            title: chatBubbleBox(
                                message: chatData.message,
                                time: chatData.timestamp,
                                reversed: isMyMessage));
                      }

                      // UI 빌드
                      if (isSameSender) {
                        return ListTile(
                            title: chatBubbleBox(
                                message: chatData.message,
                                time: chatData.timestamp,
                                reversed: isMyMessage));
                      } else {
                        return ListTile(
                          title: ChatBox(
                            data: chatData,
                            isMyMessage: isMyMessage,
                          ),
                        );
                      }
                    },
                  )),
            ),
          ),
        ),
        _noMemessageBar(),
        _messageBar()
      ],
    );
  }

  Widget _messageBar() {
    final user = ref.watch(userProvider);
    return SizedBox(
      height: heightRatio(64),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.add,
                  size: 28,
                )),
            SizedBox(
              width: widthRatio(8),
            ),
            Expanded(
              child: Container(
                height: heightRatio(44),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.84),
                    color: TTColors.gray6),
                child: Padding(
                  padding: const EdgeInsets.only(top: 11, left: 16, bottom: 10),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    onSubmitted: (String value) {},
                    onEditingComplete: () async {
                      // 완료 버튼을 눌렀을 때 수행할 동작

                      print('완료 버튼을 눌렀습니다!');
                      await _sendMessage(user?.memberId ?? 'me');
                    },
                    // onTapOutside: (event) {
                    //   log("TAP");
                    // },
                    focusNode: _focusNode,
                    controller: _controller,
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      hintStyle: Theme.of(context).textTheme.labelLarge,
                      hintText: '메시지를 입력하세요...',
                      border: InputBorder.none, // 밑줄 제거
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: widthRatio(12),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                size: 28,
              ),
              onPressed: () async {
                await _sendMessage(user?.memberId ?? 'me');
              }, // 메시지 전송
            ),
          ],
        ),
      ),
    );
  }

  Widget _noMemessageBar() {
    return SizedBox(
      height: heightRatio(64),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.add,
                  size: 28,
                )),
            SizedBox(
              width: widthRatio(8),
            ),
            Expanded(
              child: Container(
                height: heightRatio(44),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.84),
                    color: TTColors.gray6),
                child: Padding(
                  padding: const EdgeInsets.only(top: 11, left: 16, bottom: 10),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    onSubmitted: (String value) {},
                    onEditingComplete: () async {
                      // 완료 버튼을 눌렀을 때 수행할 동작

                      print('완료 버튼을 눌렀습니다!');
                      await _sendMessage("other");
                    },
                    // onTapOutside: (event) {
                    //   log("TAP");
                    // },
                    // focusNode: _focusNode,
                    controller: _controller2,
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      hintStyle: Theme.of(context).textTheme.labelLarge,
                      hintText: '메시지를 입력하세요...',
                      border: InputBorder.none, // 밑줄 제거
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: widthRatio(12),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                size: 28,
              ),
              onPressed: () async {
                await _sendNotMeMessage("other");
              }, // 메시지 전송
            ),
          ],
        ),
      ),
    );
  }
}
