import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum ChatRoomBoxType { joined, notAvailable, available }

class ChatRoomBox extends StatelessWidget {
  const ChatRoomBox({
    super.key,
    this.type = ChatRoomBoxType.available,
  });
  final ChatRoomBoxType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: type == ChatRoomBoxType.available ? 15 : 20),
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
                  _chatRoomImage('assets/images/test_img.png'),
                  SizedBox(
                    width: widthRatio(12),
                  ),
                  type == ChatRoomBoxType.available
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _chatRoomInfo("명동", 12, context),
                            _timeManager(DateTime(2024, 12, 21), context)
                          ],
                        )
                      : Expanded(
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _joinedChatRoomInfo(
                                    "명동", 12, DateTime(2024, 12, 21), context),
                                Text(
                                  "지금 롯데백화점 앞인데 근처에 싸고 맛있는 식당이 있는데 놀러오세요",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color: TTColors.gray,
                                          overflow: TextOverflow.ellipsis),
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
    );
  }

  Widget _chatRoomImage(String imageUrl) {
    return Container(
      height: heightRatio(50),
      width: heightRatio(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // 원하는 반지름 설정
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.fill, // 이미지 비율 유지
        ),
      ),
    );
  }

  Widget _chatRoomInfo(String title, int count, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "명동거리",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
        ),
        SizedBox(
          width: widthRatio(8),
        ),
        Image.asset('assets/images/people_alt.png'),
        SizedBox(
          width: widthRatio(4),
        ),
        Text(
          '12',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: TTColors.gray3),
        )
      ],
    );
  }

  Widget _joinedChatRoomInfo(
      String title, int count, DateTime time, BuildContext context) {
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

  Widget _timeManager(DateTime time, BuildContext context) {
    return Text(
      timeago.format(time, locale: "ko"),
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(color: TTColors.gray3),
    );
  }
}
