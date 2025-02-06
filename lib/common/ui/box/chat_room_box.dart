import 'dart:developer';

import 'package:chat_location/common/components/network_image.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum ChatRoomBoxType { joined, notAvailable, available }

class ChatRoomBox extends StatelessWidget {
  ChatRoomBox(
      {super.key,
      this.type = ChatRoomBoxType.available,
      this.data,
      this.backgroundColor});
  final ChatRoomBoxType type;
  final ChatRoomInterface? data;
  Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container();
    }

    return Opacity(
      opacity: data!.active ? 1 : 0.5,
      child: Container(
        decoration: BoxDecoration(
            color: data!.active ? backgroundColor : Colors.transparent),
        padding: EdgeInsets.symmetric(
            horizontal: widthRatio(20),
            vertical: type == ChatRoomBoxType.available
                ? heightRatio(15)
                : heightRatio(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: type == ChatRoomBoxType.available
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _chatRoomImage(data!.imagePath),
                    SizedBox(
                      width: widthRatio(12),
                    ),
                    type == ChatRoomBoxType.available
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  child: _chatRoomInfo(
                                      data!.title,
                                      data!.count,
                                      TTTextStyle.bodyBold18.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        height: 1.22,
                                      ),
                                      TTTextStyle.bodyMedium14.copyWith(
                                          color: TTColors.gray400,
                                          height: 1.22,
                                          letterSpacing: -0.3)),
                                ),
                                _timeManager(
                                    data!.lastMessageAt,
                                    TTTextStyle.bodyMedium14.copyWith(
                                        color: TTColors.gray500,
                                        height: 1.22,
                                        letterSpacing: -0.3))
                              ],
                            ),
                          )
                        : Expanded(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _joinedChatRoomInfo(
                                      data!.title,
                                      data!.profiles.entries.length,
                                      data!.lastMessageAt,
                                      TTTextStyle.bodyBold18.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        height: 1.22,
                                      ),
                                      TTTextStyle.bodyMedium14.copyWith(
                                          color: TTColors.gray400,
                                          height: 1.22,
                                          letterSpacing: -0.3),
                                      TTTextStyle.bodyMedium14.copyWith(
                                          color: TTColors.gray500,
                                          height: 1.22,
                                          letterSpacing: -0.3)),
                                  SizedBox(
                                    height: heightRatio(4),
                                  ),
                                  Text(
                                    textAlign: TextAlign.left,
                                    data!.lastMessage ?? '',
                                    maxLines: 1,
                                    style: TTTextStyle.bodyMedium14.copyWith(
                                      color: TTColors.gray500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
            if (type == ChatRoomBoxType.available)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("상세보기",
                      style: TTTextStyle.bodyMedium14.copyWith(
                          color: TTColors.ttPurple,
                          height: 1.22,
                          letterSpacing: -0.3)),
                  const Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 12,
                    color: TTColors.ttPurple,
                  )
                ],
              )
            else
              SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _chatRoomImage(String? imageUrl) {
    return Container(
        height: heightRatio(50),
        width: heightRatio(50),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: NetWorkImage(imagePath: imageUrl)));
  }

  Widget _chatRoomInfo(String title, int count, TextStyle? chatroomTextStyle,
      TextStyle? chatCountTextStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widthRatio(150)),
          child: Text(title, style: chatroomTextStyle),
        ),
        SizedBox(
          width: widthRatio(8),
        ),
        Image.asset(
          'assets/images/people_alt.png',
          color: TTColors.gray400,
        ),
        SizedBox(
          width: widthRatio(4),
        ),
        Text(
          count.toString(),
          style: chatCountTextStyle,
        ) // 참여가 수
      ],
    );
  }

  Widget _joinedChatRoomInfo(
      String title,
      int count,
      DateTime? time,
      TextStyle? chatroomTextStyle,
      TextStyle? chatCountTextStyle,
      TextStyle? timeTextStyle) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _chatRoomInfo(title, count, chatroomTextStyle, chatCountTextStyle),
          ],
        ),
        _timeManager(time, timeTextStyle)
      ],
    );
  }

  Widget _timeManager(DateTime? time, TextStyle? timeTextStyle) {
    if (time == null) {
      return const SizedBox(
        child: Text(""),
      );
    }
    return Text(
      timeago.format(time, locale: "ko"),
      style: timeTextStyle,
    );
  }
}
