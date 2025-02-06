import 'dart:developer';

import 'package:chat_location/features/chat/data/model/EnterLeave_message.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentChatRoomControllerProvider =
    Provider.autoDispose.family<String, String>((ref, chatroomId) {
  final chatRepository = ref.read(chattingRepositoryProvider);
  final userInfo = ref.read(userProvider)?.profile;
  if (userInfo == null) {
    throw '유저 정보를 찾을 수 없습니다.';
  }
  ref.onDispose(() {
    log('disposed');
    final EnterLeaveModel leaveData =
        EnterLeaveModel(chatroomId: chatroomId, profileId: userInfo.profileId);
    chatRepository.sendLeaveMessage(data: leaveData);
  });

  return chatroomId;
});
