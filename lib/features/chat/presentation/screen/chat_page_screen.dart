import 'dart:async';
import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/presentation/component/hice_chat_page.dart';
import 'package:chat_location/features/chat/presentation/provider/chat_message_controller.dart';
import 'package:chat_location/features/chat/presentation/ui/chat_box.dart';
import 'package:chat_location/features/chat/presentation/ui/chat_bubble_box.dart';
import 'package:chat_location/features/chat/presentation/ui/chat_event_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String roomNumber;
  const ChatPage({super.key, required this.roomNumber});
  static const String routeName = '/chatRoom'; // routeName 정의
  static const String pageName = "chatRoom";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final List<String> messages = []; // 메시지를 저장할 리스트
  late final _scrollController;
  late final _focusNode;
  final TextEditingController _controller =
      TextEditingController(); // 텍스트 입력 컨트롤러
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      // messages.insert(0, _controller.text.trim());
      messages.add(_controller.text.trim());
    });

    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(chatMessagesProvider(widget.roomNumber));
    final notifier =
        ref.read(chatMessagesProvider((widget.roomNumber)).notifier);
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Chat Room ${widget.roomNumber}'),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: SafeArea(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Text(
                    'End Drawer Header',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    // Home 눌렀을 때 동작
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    // Settings 눌렀을 때 동작
                  },
                ),
              ],
            ),
          ),
        ),
        body: HiveChatPage(roomNumber: widget.roomNumber)
        // Column(
        //   children: [
        //     Expanded(
        //       child: GestureDetector(
        //         onTap: _onTapChatScreen,
        //         child: Container(
        //           height: double.infinity,
        //           color: Colors.transparent,
        //           child: Align(
        //             alignment: Alignment.topCenter,
        //             child: ListView.separated(
        //               scrollDirection: Axis.vertical,
        //               controller: _scrollController,
        //               reverse: true,
        //               shrinkWrap: true,
        //               itemCount: messages.length,
        //               itemBuilder: (context, index) {
        //                 return ListTile(
        //                     title: ChatBox(
        //                         text: messages[messages.length - 1 - index])
        //                     // chatBubbleBox(
        //                     //      message:messages[messages.length - 1 - index], time: DateTime.now(), reversed: true, backgroundColor: TTColors.ttPurple, textColor: Colors.white),
        //                     );
        //               },
        //               separatorBuilder: (_, __) => const SizedBox(
        //                 height: 0,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     _messageBar()
        //   ],
        // )
        );
  }

  Widget _messageBar() {
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
                    onEditingComplete: () {
                      // 완료 버튼을 눌렀을 때 수행할 동작

                      print('완료 버튼을 눌렀습니다!');
                      _sendMessage();
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
              onPressed: _sendMessage, // 메시지 전송
            ),
          ],
        ),
      ),
    );
  }
}
