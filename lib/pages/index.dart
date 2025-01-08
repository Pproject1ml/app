import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ShellRouteIndex extends StatelessWidget {
  const ShellRouteIndex({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
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
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          // 브랜치를 전환하는데는 StatefulNavigationShell.goBranch 메서드를 사용한다.
          navigationShell.goBranch(index);
        },
      ),
    );
  }
}
