import 'dart:developer';

import 'package:chat_location/common/ui/button/nextButton.dart';
import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/provider/personal_chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_tab_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/personal_chat_page_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/personal_chat_tab.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:chat_location/features/user/presentation/screen/userInfoScreen.dart';
import 'package:chat_location/features/user/presentation/ui/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final ProfileInterface userProfile;
  const UserProfileScreen({super.key, required this.userProfile});
  static const String pageName = " userProfile";
  static const String routeName = '/userProfile';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserProfileScreen> {
  bool isChatroomExist = false;
  Future<void> _joinChatroom(String profileId) async {
    try {
      final chatroomList =
          ref.read(personalchattingControllerProvider.notifier).getData();
      final int joinedChatroomIndex = chatroomList.indexWhere(
          (v) => v.profiles.keys.contains(widget.userProfile.profileId));
      log("joined index : ${joinedChatroomIndex}");
      if (joinedChatroomIndex >= 0) {
        final ChatRoomInterface chatroom = chatroomList[joinedChatroomIndex];
        context.goNamed(UserInfoScreen.pageName);
        context.pushNamed(PersonalChatScreen.pageName);
        context.pushNamed(PersonalChatPage.pageName,
            pathParameters: {'id': chatroom.chatroomId});
      } else {
        final ChatRoomInterface chatroom = await ref
            .read(personalchattingControllerProvider.notifier)
            .createPrivateChatroom(profileId);
        context.goNamed(UserInfoScreen.pageName);
        context.pushNamed(PersonalChatScreen.pageName);
        context.pushNamed(PersonalChatPage.pageName,
            pathParameters: {'id': chatroom.chatroomId});
      }
    } catch (e) {
      showSnackBar(context: context, message: "채팅방 참가에 실패하였습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(personalchattingControllerProvider.notifier);
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0), // 하단 영역 높이
            child: Container(
              color: TTColors.gray200, // 하단 테두리 색상
              height: 1.0, // 테두리 두께
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            userProfile(
                profile: widget.userProfile,
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).textTheme.bodyLarge?.color ??
                    TTColors.black),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widthRatio(20), vertical: heightRatio(20)),
              child: GestureDetector(
                  onTap: () async {
                    await _joinChatroom(widget.userProfile.profileId);
                  },
                  child: bottomNextButtonT(text: "1:1 채팅하기")),
            )
          ],
        ));
  }
}
