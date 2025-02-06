import 'dart:developer';

import 'package:chat_location/common/dialog/user_profile_dialog.dart';
import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/common/ui/text_input/rounde_text_input.dart';
import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/constants/theme.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/provider/personal_chatting_controller.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:chat_location/features/user/presentation/screen/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatPageProfiles extends ConsumerStatefulWidget {
  final String chatroomId;
  final bool isPrivate;
  const ChatPageProfiles(
      {super.key, required this.chatroomId, this.isPrivate = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatPageProfilesState();
}

class _ChatPageProfilesState extends ConsumerState<ChatPageProfiles> {
  late final TextEditingController searchTextController;
  late final FocusNode searchTextFocusNode;
  List<ProfileInterface> _searchedList = [];
  List<ProfileInterface> data = [];

  @override
  void initState() {
    super.initState();

    searchTextController = TextEditingController();
    searchTextController.addListener(_filterList);
    searchTextFocusNode = FocusNode();

    try {
      if (widget.isPrivate) {
        data = ref
            .read(personalchattingControllerProvider)
            .maybeWhen(
              data: (v) => v,
              orElse: () => [],
            )
            .firstWhere(
              (v) => v.chatroomId == widget.chatroomId,
              orElse: () => throw Exception("Chatroom not found"),
            )
            .profiles
            .values
            .toList();
      } else {
        data = ref
            .read(chattingControllerProvider)
            .maybeWhen(
              data: (v) => v,
              orElse: () => [],
            )
            .firstWhere(
              (v) => v.chatroomId == widget.chatroomId,
              orElse: () => throw Exception("Chatroom not found"),
            )
            .profiles
            .values
            .toList();
      }

      _searchedList = data;
    } catch (e) {
      data = [];
      _searchedList = [];
    }
  }

  void handleClickUser(ProfileInterface userInfo) async {
    try {
      context.pushNamed(UserProfileScreen.pageName, extra: userInfo);
    } catch (e, s) {
      log(e.toString() + s.toString());
      showSnackBar(context: context, message: "유저를 불러올 수 없습니다.");
    }
  }

  @override
  void dispose() {
    searchTextController.dispose();
    searchTextFocusNode.dispose();
    super.dispose();
  }

  void _filterList() {
    final query = searchTextController.text.toLowerCase();

    setState(() {
      _searchedList = query.isEmpty
          ? data
          : data
              .where(
                  (profile) => profile.nickname.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(chattingControllerProvider.notifier);

    return SizedBox(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "참여자 목록",
                  style: TTTextStyle.bodySemibold14.copyWith(
                      height: 1.22,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                SizedBox(width: widthRatio(8)),
                Text(
                  data.length.toString(),
                  style: TTTextStyle.bodyRegular14.copyWith(
                    fontWeight: FontWeight.w400,
                    color: TTColors.ttPurple,
                    height: 1.22,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            SizedBox(height: heightRatio(8)),
            if (!widget.isPrivate)
              RoundTextInput(
                controller: searchTextController,
                focusNode: searchTextFocusNode,
                autofocus: false,
              ),
            SizedBox(height: heightRatio(12)),
            Expanded(
              child: _searchedList.isEmpty
                  ? Center(
                      child: Text(
                        "해당 유저를 찾을 수 없습니다.",
                        style: TTTextStyle.bodyRegular14.copyWith(
                          color: TTColors.gray500,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _searchedList.length,
                      itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            handleClickUser(_searchedList[index]);
                          },
                          child: userChatProfile(_searchedList[index])),
                      separatorBuilder: (context, index) => SizedBox(
                        height: heightRatio(8),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget userChatProfile(ProfileInterface userInfo) {
  return Row(
    children: [
      roundUserImageBox(
        size: 36,
        imageUrl: userInfo.profileImage,
      ),
      SizedBox(width: widthRatio(10)),
      Text(
        userInfo.nickname,
        style: TTTextStyle.bodyRegular14
            .copyWith(letterSpacing: -0.3, height: 1.22),
      ),
    ],
  );
}
