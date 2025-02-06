import 'package:chat_location/common/dialog/landmark_dialog.dart';
import 'package:chat_location/common/ui/box/chat_room_box.dart';
import 'package:chat_location/common/ui/box/rounded_box.dart';
import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_page_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_tab_screen.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/presentation/ui/open_list_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AvailableLandmarks extends ConsumerStatefulWidget {
  const AvailableLandmarks({super.key, required this.landmarks});
  final List<LandmarkInterface> landmarks;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AvailableLandmarksState();
}

class _AvailableLandmarksState extends ConsumerState<AvailableLandmarks>
    with SingleTickerProviderStateMixin {
  bool isListOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleList() {
    setState(() {
      isListOpen = !isListOpen;
      if (isListOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleVerticalDrag(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    if (!isListOpen && velocity > 1000) {
      _toggleList();
    } else if (isListOpen && velocity < -1000) {
      _toggleList();
    }
  }

  Future<void> _joinChatroom(ChatRoomInterface chatroom) async {
    try {
      final chatroomList =
          ref.read(chattingControllerProvider.notifier).getData();
      final isJoined =
          chatroomList.any((v) => v.chatroomId == chatroom.chatroomId);

      if (isJoined) {
        context.goNamed(ChatScreen.pageName);
        context.pushNamed(ChatPage.pageName,
            pathParameters: {'id': chatroom.chatroomId});
      } else {
        await ref
            .read(chattingControllerProvider.notifier)
            .joinAction(chatroom);
        context.goNamed(ChatScreen.pageName);
        context.pushNamed(ChatPage.pageName,
            pathParameters: {'id': chatroom.chatroomId});
      }
    } catch (e) {
      showSnackBar(context: context, message: "채팅방 참가에 실패하였습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 25,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onVerticalDragEnd: _handleVerticalDrag,
        onTap: _toggleList,
        child: RoundedContainer(
          backgroundColor: theme.cardTheme.color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '현재 내가 있는 곳에서',
                          style: TTTextStyle.bodyMedium14.copyWith(
                              letterSpacing: -0.3,
                              height: 1.22,
                              color: theme.textTheme.bodyLarge?.color),
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.landmarks.length}개',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: TTColors.ttPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '의 채팅방에 참여할 수 있어요.',
                              style: TTTextStyle.bodyMedium14.copyWith(
                                  letterSpacing: -0.3,
                                  height: 1.22,
                                  color: theme.textTheme.bodyLarge?.color),
                            ),
                          ],
                        ),
                      ],
                    ),
                    openListButton(
                        isOpened: isListOpen,
                        textStyle: TTTextStyle.bodyMedium14.copyWith(
                            color: TTColors.white,
                            height: 1.22,
                            letterSpacing: -0.3),
                        iconColor: TTColors.white),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: heightRatio(400)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    child: isListOpen
                        ? ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: widget.landmarks
                                .map(
                                  (item) => GestureDetector(
                                    onTap: () =>
                                        landmarkDialog(context, item, () async {
                                      await _joinChatroom(item.chatroom!);
                                    }),
                                    child: ChatRoomBox(
                                      data: item.chatroom,
                                      backgroundColor: theme.cardColor,
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
