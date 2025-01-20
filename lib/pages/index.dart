import 'package:chat_location/common/utils/permissions.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ShellRouteIndex extends ConsumerStatefulWidget {
  const ShellRouteIndex({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShellRouteIndexState();
}

class _ShellRouteIndexState extends ConsumerState<ShellRouteIndex> {
  @override
  void initState() {
    permissionWithNotification();
    super.initState();
    Future.microtask(() => {ref.read(chattingControllerProvider.notifier)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/home.svg',
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/home.svg',
                color: TTColors.ttPurple,
              ),
              label: '홈'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/chat.svg',
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/chat.svg',
                color: TTColors.ttPurple,
              ),
              label: '채팅'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/person.svg',
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/person.svg',
                color: TTColors.ttPurple,
              ),
              label: '마이페이지'),
        ],
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (int index) {
          // 브랜치를 전환하는데는 StatefulNavigationShell.goBranch 메서드를 사용한다.
          widget.navigationShell.goBranch(index);
        },
      ),
    );
  }
}
