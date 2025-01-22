import 'dart:developer';

import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/common/ui/text_input/rounde_text_input.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/constants/theme.dart';

import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPageProfiles extends ConsumerStatefulWidget {
  final String chatroomId;
  const ChatPageProfiles({super.key, required this.chatroomId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatPageProfilesState();
}

class _ChatPageProfilesState extends ConsumerState<ChatPageProfiles> {
  late final TextEditingController searchTextController;
  late final FocusNode searchTextFocusNode;
  List<ProfileInterface> _searchedList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchTextController = TextEditingController();
    searchTextController.addListener(_filterList);
    searchTextFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    searchTextFocusNode.dispose();
    super.dispose();
  }

  void _filterList() {
    final query = searchTextController.text.toLowerCase();
    log("query: ${query}");

    setState(() {
      if (query.isEmpty) {
        _searchedList = [];
      } else {
        // Filter the original list based on the search query
        // _searchedList = ref
        //     .watch(chattingControllerProvider)[0]
        //     .profiles
        //     .values
        //     .where((profile) => profile.nickname.toLowerCase().contains(query))
        //     .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(chattingControllerProvider.notifier);
    List<ProfileInterface> data;
    try {
      data = ref
          .watch(chattingControllerProvider)
          .maybeWhen(data: (v) => v, orElse: () => throw 'data 문제')
          .firstWhere((v) => v.chatroomId == widget.chatroomId)
          .profiles
          .values
          .toList();
    } catch (e, s) {
      return Center(
        child: Text("유저 정보를 불러오지 못했습니다."),
      );
    }
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
                Text("참여자 목록",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(
                  width: 8,
                ),
                Text(data.length.toString(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: TTColors.ttPurple,
                        letterSpacing: -0.3))
              ],
            ),
            SizedBox(
              height: heightRatio(8),
            ),
            RoundTextInput(
              controller: searchTextController,
              focusNode: searchTextFocusNode,
              autofocus: false,
            ),
            SizedBox(
              height: heightRatio(12),
            ),
            Expanded(
                child: ListView.separated(
              itemCount: data.length,
              itemBuilder: (context, index) => userChatProfile(data[index]),
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: heightRatio(8),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

Widget userChatProfile(ProfileInterface userInfo) {
  return Row(children: [
    roundUserImageBox(
        editable: false, size: 36, imageUrl: userInfo.profileImage),
    SizedBox(
      width: widthRatio(10),
    ),
    Text(
      userInfo.nickname,
      style: TTTextStyle.bodyRegular14,
    )
  ]);
}
