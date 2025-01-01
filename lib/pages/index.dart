import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/features/chat/screen/chat_list_screen.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';
import 'package:chat_location/features/user/presentation/screen/userInfoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationBarScaffold extends StatefulWidget {
  const BottomNavigationBarScaffold({super.key, required this.child});
  final Widget child;
  static const String routeName = '/'; // routeName 정의
  @override
  State<BottomNavigationBarScaffold> createState() =>
      _BottomNavigationBarScaffoldState();
}

class _BottomNavigationBarScaffoldState
    extends State<BottomNavigationBarScaffold> {
  int _index = 0;
  void onDestinationSelected(int index) {
    setState(() {
      _index = index;
    });

    switch (index) {
      case 0:
        context.goNamed(MapScreen.pageName);
        break;
      case 1:
        context.goNamed(ChatScreen.pageName);
        break;
      case 2:
        context.goNamed(UserInfoScreen.pageName);
    }
  }

  void setIndexByPathName(String uri) {
    // map page를 뒤에 항상 뛰우기 위해 chat,profile 에서 뒤로가기 누를 시 index를  map navgigation으로 설정
    switch (uri) {
      case '/map':
        setState(() {
          _index = 0;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPath =
        GoRouter.of(context).routerDelegate.currentConfiguration;
    setIndexByPathName(currentPath.uri.toString());
    return Scaffold(
        body: widget.child,
        bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            destinations: [
              const NavigationDestination(label: '홈', icon: Icon(Icons.home)),
              NavigationDestination(
                  label: '채팅', icon: SvgPicture.asset('assets/svgs/chat.svg')),
              const NavigationDestination(
                  label: '마이페이지', icon: Icon(Icons.person)),
            ],
            onDestinationSelected: onDestinationSelected));
  }
}

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
