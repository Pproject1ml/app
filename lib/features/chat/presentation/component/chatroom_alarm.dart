import 'dart:developer';

import 'package:chat_location/common/components/async_button.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CharoomAlarm extends ConsumerStatefulWidget {
  final ChatRoomInterface chatroom;
  const CharoomAlarm({super.key, required this.chatroom});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CharoomAlarmState();
}

class _CharoomAlarmState extends ConsumerState<CharoomAlarm> {
  late bool isNotificationGranted;

  @override
  @override
  void initState() {
    super.initState();
    isNotificationGranted = widget.chatroom.alarm;
  }

  Future<void> handleClickAlarm() async {
    final _value = !isNotificationGranted;
    setState(() {
      isNotificationGranted = _value;
    });
    await ref
        .read(chattingControllerProvider.notifier)
        .alarmSettingAction(widget.chatroom.chatroomId, _value);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: AsyncButton(
        onClick: () async {
          await handleClickAlarm();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: heightRatio(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                isNotificationGranted
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_off_rounded,
                size: widthRatio(20),
                color: TTColors.gray500,
              ),
              SizedBox(
                width: widthRatio(6),
              ),
              Text(
                isNotificationGranted ? "알림 켬" : "알림 끔",
                style: TTTextStyle.captionMedium12
                    .copyWith(color: TTColors.gray500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
