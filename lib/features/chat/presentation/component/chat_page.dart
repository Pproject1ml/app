import 'dart:developer';

import 'package:chat_location/common/ui/button/nextButton.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_tab_screen.dart';
import 'package:chat_location/features/chat/presentation/ui/chatting_box_with_image.dart';
import 'package:chat_location/features/chat/presentation/ui/chatting_box.dart';
import 'package:chat_location/features/chat/presentation/ui/chatting_date_box.dart';
import 'package:chat_location/features/chat/presentation/ui/chatting_enter_box.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatPageContainer extends ConsumerStatefulWidget {
  final String roomNumber;
  const ChatPageContainer({super.key, required this.roomNumber});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HiveChatPageState();
}

class _HiveChatPageState extends ConsumerState<ChatPageContainer> {
  late final ScrollController _scrollController;
  late final FocusNode _focusNode;
  final TextEditingController _controller =
      TextEditingController(); // 텍스트 입력 컨트롤러

  bool isAtTop = false;

  Future<void> _sendMessage(String userId) async {
    if (_controller.text.trim().isEmpty) return;
    final message = _controller.text;
    await ref
        .read(chattingControllerProvider.notifier)
        .sendMessageAction(message, userId, widget.roomNumber);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() async {
    if (_scrollController.hasClients) {
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
    _scrollController.addListener(_scrollListener);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (!isAtTop) {
        // ref.read(chattingControllerProvider.notifier).loadMore();
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
    if (_focusNode.hasFocus) {
      // 키보드가 열렸을 때 아래로 스크롤
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _onTapChatScreen() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  bool isDialogOpen(BuildContext context) {
    if (!context.mounted) return false; // 컨텍스트가 유효하지 않으면 false 반환
    return ModalRoute.of(context)?.isCurrent != true;
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
    final notifier = ref.read(chattingControllerProvider.notifier);
    final user = ref.watch(userProvider);

    return ref.watch(chattingControllerProvider).when(
        data: (v) {
          ChatRoomInterface? _chatroomInfo;
          try {
            _chatroomInfo = v.firstWhere(
              (v) => v.chatroomId == widget.roomNumber,
            );
          } catch (e, s) {
            _chatroomInfo = null;
          }
          if (_chatroomInfo == null) {
            return const Center(
              child: Text("채팅방 정보를 불러올 수 없습니다."),
            );
          }
          final _data = _chatroomInfo.chatting;
          final _profiles = _chatroomInfo.profiles;
          final _isDialogVisible = isDialogOpen(context);

          if (_chatroomInfo.available) {
            if (_isDialogVisible) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
          } else {
            if (!_isDialogVisible) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showUnavailableAlert(context);
              });
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          itemCount: _data.length,
                          itemBuilder: (context, index) {
                            final chatData = _data[index];

                            // 이전 데이터와 비교
                            final isSameSender = index < _data.length - 1 &&
                                _data[index + 1].profileId ==
                                    chatData.profileId;

                            // 현재 메시지가 본인의 메시지인지 확인
                            final isMyMessage = chatData.profileId ==
                                (user?.profile.profileId ?? 'me');

                            final profileInfo = _profiles[chatData.profileId];

                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: index == 0 ? heightRatio(8) : 0),
                              child: _messageBox(chatData, isMyMessage,
                                  isSameSender, profileInfo),
                            );
                          },
                        )),
                  ),
                ),
              ),
              _messageBar()
            ],
          );
        },
        error: (e, s) => Center(child: Text(e.toString())),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  Widget _messageBox(ChatMessageInterface message, bool isMyMessage,
      bool isSameSender, ProfileInterface? profile) {
    switch (message.messageType) {
      case "TEXT":
        return _textMessage(message, isMyMessage, isMyMessage);
      case "ENTER":
        break;
      case "JOIN":
        return chattingJoinBox("JOIN", profile);
      case "LEAVE":
        break;
      case "DIE":
        return chattingJoinBox("DIE", profile);
      case "DATE":
        return chattingDateBox(message);
      case "IMAGE":
        break;
    }
    return const SizedBox.shrink();
  }

  void _showUnavailableAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: TTColors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widthRatio(20),
            vertical: heightRatio(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Column이 자식의 크기에 맞게 줄어듦
            children: [
              SizedBox(height: heightRatio(22)),
              Image.asset(
                'assets/images/warning.png',
                width: widthRatio(80),
                height: heightRatio(112),
              ),
              SizedBox(height: heightRatio(14)),
              const Text(
                "채팅 가능 지역을 벗어났어요.",
                style: TTTextStyle.bodyMedium16,
              ),
              SizedBox(height: heightRatio(73)),
              bottomNextButtonT(text: "대화 종료하기"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textMessage(
      ChatMessageInterface message, bool isMyMessage, bool isSameSender) {
    if (isMyMessage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: widthRatio(16),
                bottom: heightRatio(4),
                left: widthRatio(16)),
            child: chatBubbleBox(
                message: message.content,
                time: message.createdAt!,
                reversed: isMyMessage),
          ),
        ],
      );
    }

    // UI 빌드
    if (isSameSender) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: widthRatio(16),
                bottom: heightRatio(4),
                left: widthRatio(16)),
            child: chatBubbleBox(
                message: message.content,
                time: message.createdAt!,
                reversed: isMyMessage),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: widthRatio(16),
                bottom: heightRatio(16),
                left: widthRatio(16)),
            child: ChattingBoxWithImage(
              data: message,
              isMyMessage: isMyMessage,
            ),
          ),
        ],
      );
    }
  }

  Widget _messageBar() {
    final user = ref.watch(userProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
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
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21.84),
                  color: TTColors.gray100),
              child: Padding(
                padding: EdgeInsets.only(
                    top: heightRatio(1),
                    left: widthRatio(16),
                    bottom: heightRatio(1)),
                child: TextField(
                  scrollPadding: EdgeInsets.zero,
                  maxLines: 4,
                  minLines: 1,
                  autofocus: false,
                  textInputAction: TextInputAction.newline,
                  focusNode: _focusNode,
                  controller: _controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
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
            icon: const Icon(
              Icons.send,
              size: 28,
              color: Colors.grey,
            ),
            onPressed: () async {
              await _sendMessage(user?.profile.profileId ?? 'me');
            }, // 메시지 전송
          ),
        ],
      ),
    );
  }
}
