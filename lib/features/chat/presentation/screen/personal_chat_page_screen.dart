import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/component/chat_page.dart';
import 'package:chat_location/features/chat/presentation/component/chat_page_profiles.dart';
import 'package:chat_location/features/chat/presentation/component/chatroom_alarm.dart';

import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/provider/personal_chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PersonalChatPage extends ConsumerStatefulWidget {
  final String roomNumber;
  const PersonalChatPage({super.key, required this.roomNumber});
  static const String routeName = '/personalchatRoom'; // routeName 정의
  static const String pageName = "personalchatRoom";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<PersonalChatPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await ref
        .read(personalchattingControllerProvider.notifier)
        .enterAction(widget.roomNumber));
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isEndDrawerOpned = false;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(personalchattingControllerProvider.notifier);
    return ref.watch(personalchattingControllerProvider).when(data: (v) {
      ChatRoomInterface? _chatroomInfo;

      try {
        _chatroomInfo = v.firstWhere(
          (v) => v.chatroomId == widget.roomNumber,
        );
      } catch (e, s) {
        _chatroomInfo = null;
        return Container();
      }
      return Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          onEndDrawerChanged: (isOpened) {
            setState(() {
              isEndDrawerOpned = isOpened;
            });
          },
          key: _scaffoldKey,
          resizeToAvoidBottomInset: !isEndDrawerOpned,
          appBar: AppBar(
            title: Text(_chatroomInfo.title),
            actions: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
          endDrawer: Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Drawer(
                  width: MediaQuery.of(context).size.width * 0.85 >=
                          widthRatio(300)
                      ? widthRatio(300)
                      : MediaQuery.of(context).size.width * 0.85,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widthRatio(18),
                              vertical: heightRatio(17)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textAlign: TextAlign.start,
                                _chatroomInfo.title,
                                style: TextTheme.of(context)
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: heightRatio(22),
                              ),
                              Expanded(
                                child: ChatPageProfiles(
                                  chatroomId: _chatroomInfo.chatroomId,
                                  isPrivate: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: TTColors.gray100,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      overlayColor: TTColors.gray400),
                                  onPressed: () async {
                                    await notifier.dieAction(widget.roomNumber);
                                    context.goNamed(ChatScreen.pageName);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: heightRatio(15)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svgs/out.svg',
                                          width: widthRatio(20),
                                        ),
                                        SizedBox(
                                          width: widthRatio(6),
                                        ),
                                        Text(
                                          "나가기",
                                          style: TTTextStyle.captionMedium12
                                              .copyWith(
                                                  color: TTColors.gray500),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            CharoomAlarm(
                              chatroom: _chatroomInfo,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
          body: ChatPageContainer(
            chatroom: _chatroomInfo,
            isPrivate: true,
          ));
    }, error: (e, s) {
      return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("잘못된 접근입니다."),
        ),
      );
    }, loading: () {
      return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        key: _scaffoldKey,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
