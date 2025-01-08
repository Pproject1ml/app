// lib/providers/router_index_provider.dart
import 'package:chat_location/features/chat/presentation/screen/chat_list_screen.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';
import 'package:chat_location/features/user/presentation/screen/userInfoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationBarIndexProvider extends StateNotifier<int> {
  BottomNavigationBarIndexProvider() : super(0); // 초기 상태를 0으로 설정

  void setIndex(index) {
    state = index;
  }

  void onDestinationSelected(BuildContext context, int index) {
    setIndex(index);
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
}

// StateNotifierProvider 생성
final bottomNavigationBarIndexProvider =
    StateNotifierProvider<BottomNavigationBarIndexProvider, int>((ref) {
  return BottomNavigationBarIndexProvider();
});
