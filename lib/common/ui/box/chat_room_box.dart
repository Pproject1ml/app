import 'package:chat_location/common/components/network_image.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum ChatRoomBoxType { joined, notAvailable, available }

class ChatRoomBox extends StatelessWidget {
  const ChatRoomBox(
      {super.key, this.type = ChatRoomBoxType.available, this.data});
  final ChatRoomBoxType type;

  final ChatRoomInterface? data;
  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container();
    }
    return Opacity(
      opacity: data!.available ? 1 : 0.5,
      child: Container(
        decoration: BoxDecoration(
            color: data!.available ? TTColors.white : Colors.transparent),
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
                                  child: _chatRoomInfo(data!.title,
                                      data!.profiles.entries.length, context),
                                ),
                                _timeManager(data!.lastMessageAt, context)
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
                                      context),
                                  SizedBox(
                                    height: heightRatio(4),
                                  ),
                                  Text(
                                    textAlign: TextAlign.left,
                                    data!.lastMessage ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: TTColors.gray500,
                                          fontWeight: FontWeight.w500,
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
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: TTColors.ttPurple,
                          )),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // 원하는 반지름 설정
        ),
        child: NetWorkImage(imagePath: imageUrl));
  }

  Widget _chatRoomInfo(String title, int count, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widthRatio(150)),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
          ),
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
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: TTColors.gray400, fontWeight: FontWeight.w500),
        ) // 참여가 수
      ],
    );
  }

  Widget _joinedChatRoomInfo(
      String title, int count, DateTime? time, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _chatRoomInfo(title, count, context),
          ],
        ),
        _timeManager(time, context)
      ],
    );
  }

  Widget _timeManager(DateTime? time, BuildContext context) {
    if (time == null) {
      return const SizedBox(
        child: Text(""),
      );
    }
    return Text(
      timeago.format(time, locale: "ko"),
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(color: TTColors.gray500, fontWeight: FontWeight.w500),
    );
  }
}
