import 'package:chat_location/common/ui/box/rounded_box.dart';
import 'package:chat_location/constants/colors.dart';

import 'package:chat_location/features/map/ui/open_list_button.dart';
import 'package:chat_location/features/map/component/chat_room.dart';
import 'package:chat_location/features/map/screen/mapScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListBox extends ConsumerStatefulWidget {
  const ChatListBox({super.key, required this.LOCATION_DATA});
  final LOCATION_DATA;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListBoxState();
}

class _ChatListBoxState extends ConsumerState<ChatListBox>
    with SingleTickerProviderStateMixin {
  bool isListOpen = false;
  late AnimationController _controller; // 애니메이션 컨트롤러
  late Animation<double> _animation; // 애니메이션

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 해제

    super.dispose();
  }

  void _handleClickToggleList() {
    setState(() {
      isListOpen = !isListOpen; // 상태 토글
      if (isListOpen) {
        _controller.forward(); // 애니메이션 시작
      } else {
        _controller.reverse(); // 애니메이션 반대로
      }
    });
  }

  void _onVerticalDrag(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    final isDraggingDown = velocity.dy > 0;
    // 닫힌 상황에서
    if (!isListOpen && isDraggingDown && velocity.distance > 1000) {
      _handleClickToggleList();
    }
    //열린 상황에서
    if (isListOpen && !isDraggingDown && velocity.distance > 5000) {
      _handleClickToggleList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // 그림자 색상과 투명도
          spreadRadius: 0, // 그림자 확산 정도
          blurRadius: 25, // 그림자 흐림 정도
          offset: const Offset(0, 4), // 그림자 위치 (x, y)
        ),
      ]),
      child: GestureDetector(
        onVerticalDragEnd: _onVerticalDrag,
        onTap: _handleClickToggleList,
        child: RoundedContainer(
            backgroundColor: Theme.of(context).cardTheme.color,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 18, left: 20, bottom: 16, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '현재 내가 있는 곳에서',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${LOCATION_DATA.length}개',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: TTColors.ttPurple,
                                        fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '의 채팅방에 참여할 수 있어요.',
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      ),
                      OpenListButton(
                        isOpened: isListOpen,
                      )
                    ],
                  ),
                ),
                SizeTransition(
                  sizeFactor: _animation, // 애니메이션 적용
                  axis: Axis.vertical, // 수직 방향으로 애니메이션
                  child: Container(
                    child: isListOpen
                        ? ListView(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: LOCATION_DATA
                                .map((item) => ChatRoom())
                                .toList(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
