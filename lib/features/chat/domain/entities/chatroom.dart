import 'dart:developer';

import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/features/chat/data/model/chatroom.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';

class ChatRoomInterface {
  final String chatroomId;
  final String title;
  final int count;
  final Map<String, ProfileInterface> profiles;
  final Map<String, int> lastReadMap;
  final String? lastMessage;
  final String? lastReadMessageId;
  final DateTime? lastMessageAt;
  final List<ChatMessageInterface> chatting;
  final double latitude;
  final double longitude;
  final List<int> hiveKeys;
  final double? distance;
  final bool active;
  final String? imagePath;
  final bool alarm;
  ChatRoomInterface(
      {required this.chatroomId,
      required this.title,
      required this.profiles,
      this.lastReadMap = const {},
      this.lastMessage,
      this.lastReadMessageId,
      this.lastMessageAt,
      this.count = 0,
      required this.latitude,
      required this.longitude,
      this.chatting = const [],
      this.hiveKeys = const [],
      this.distance,
      this.active = true,
      this.imagePath,
      this.alarm = true});

  factory ChatRoomInterface.fromHiveModel(ChatRoomHiveModel data) {
    return ChatRoomInterface(
        chatroomId: data.chatroomId,
        title: data.title,
        count: data.count ?? 0,
        profiles: {
          for (var v in data.profiles)
            v.profileId: ProfileInterface.fromProfileHiveModel(v),
        },
        latitude: data.latitude,
        longitude: data.longitude,
        lastMessage: data.lastMessage,
        lastReadMessageId: data.lastReadMessageId,
        lastMessageAt: data.lastMessageAt,
        imagePath: data.imagePath,
        active: data.active,
        alarm: data.alarm);
  }
  factory ChatRoomInterface.fromChatRoomModel(ChatRoomModel data) {
    return ChatRoomInterface(
        chatroomId: data.chatroomId,
        title: data.title ?? '알수없음',
        profiles: {
          for (var v in data.profiles ?? [])
            v.profileId: ProfileInterface.fromProfileModel(v),
        },
        count: data.count,
        longitude: data.longitude,
        latitude: data.latitude,
        lastMessage: data.lastMessage,
        lastReadMessageId: data.lastReadMessageId,
        lastMessageAt: data.lastMessageAt,
        imagePath: data.imagePath,
        active: data.active,
        alarm: data.alarm);
  }

  ChatRoomHiveModel toHiveModel() {
    return ChatRoomHiveModel(
        chatroomId: chatroomId,
        title: title,
        profiles: profiles.entries.map((e) {
          return e.value.toProfileHiveModel();
        }).toList(),
        latitude: latitude,
        longitude: longitude,
        lastMessage: lastMessage,
        lastReadMessageId: lastReadMessageId,
        lastMessageAt: lastMessageAt,
        imagePath: imagePath,
        active: active,
        alarm: alarm);
  }

  ChatRoomModel toChatRoomModel() {
    return ChatRoomModel(
        chatroomId: chatroomId,
        title: title,
        count: count,
        profiles: profiles.entries.map((e) {
          return e.value.toProfileModel();
        }).toList(),
        latitude: latitude,
        longitude: longitude,
        lastMessage: lastMessage,
        lastReadMessageId: lastReadMessageId,
        lastMessageAt: lastMessageAt,
        imagePath: imagePath,
        active: active,
        alarm: alarm);
  }

  ChatRoomInterface copyWith(
      {String? chatroomId,
      String? title,
      int? count,
      Map<String, ProfileInterface>? profiles,
      String? lastMessage,
      String? lastReadMessageId,
      DateTime? lastMessageAt,
      List<ChatMessageInterface>? chatting,
      double? latitude,
      double? longitude,
      double? distance,
      bool? active,
      List<int>? hiveKeys,
      String? imagePath,
      bool? alarm}) {
    return ChatRoomInterface(
        chatroomId: chatroomId ?? this.chatroomId,
        title: title ?? this.title,
        profiles: profiles ?? this.profiles,
        lastMessage: lastMessage ?? this.lastMessage,
        lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        chatting: chatting ?? this.chatting,
        count: count ?? this.count,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        distance: distance ?? this.distance,
        active: active ?? this.active,
        hiveKeys: hiveKeys ?? this.hiveKeys,
        imagePath: imagePath ?? this.imagePath,
        alarm: alarm ?? this.alarm);
  }
}
