import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/features/user/data/models/profile.dart';

class ChatRoomModel {
  final String chatroomId;
  final String? title;
  final int count;
  final List<ProfileModel>? profiles;
  final String? lastMessage;
  final String? lastReadMessageId;
  final double longitude;
  final double latitude;
  final DateTime? lastMessageAt;
  final String? imagePath;
  final bool active;
  final bool alarm;
  ChatRoomModel(
      {required this.chatroomId,
      this.title,
      this.count = 0,
      required this.profiles,
      this.lastMessage,
      this.lastReadMessageId,
      this.latitude = 0,
      this.longitude = 0,
      this.lastMessageAt,
      this.imagePath,
      required this.active,
      required this.alarm});

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
        chatroomId: json['chatroomId'] as String,
        title: json['title'] as String?,
        count: json['count'] != null ? json['count'] as int : 0,
        profiles: json['profiles'] != null
            ? (json['profiles'] as List<dynamic>)
                .map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        lastMessage: json['lastMessage'] as String?,
        lastReadMessageId: json['lastReadMessageId'] as String?,
        latitude: json['latitude'] != null ? json['latitude'] as double : 0,
        longitude: json['longitude'] != null ? json['longitude'] as double : 0,
        lastMessageAt: json['lastMessageAt'] != null
            ? DateTime.parse(json['lastMessageAt'] as String)
            : null,
        imagePath: json['imagePath'] as String?,
        active: json['active'] as bool,
        alarm: json['alarm'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'title': title,
      'count': count,
      'profiles': profiles?.map((e) => e.toJson()).toList(),
      'lastMessage': lastMessage,
      'lastReadMessageId': lastReadMessageId,
      'longitude': longitude,
      'latitude': latitude,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'imagePath': imagePath,
      'active': active,
      'alarm': alarm
    };
  }

  factory ChatRoomModel.fromHiveModel(ChatRoomHiveModel hiveModel) {
    return ChatRoomModel(
        chatroomId: hiveModel.chatroomId,
        title: hiveModel.title,
        count: 0,
        profiles:
            hiveModel.profiles.map((e) => ProfileModel.fromHive(e)).toList(),
        latitude: hiveModel.latitude,
        longitude: hiveModel.longitude,
        lastMessage: hiveModel.lastMessage,
        lastReadMessageId: hiveModel.lastReadMessageId,
        lastMessageAt: hiveModel.lastMessageAt,
        imagePath: hiveModel.imagePath,
        active: hiveModel.active,
        alarm: hiveModel.alarm);
  }

  ChatRoomHiveModel toHiveModel() {
    return ChatRoomHiveModel(
        chatroomId: chatroomId,
        title: title ?? '알수없음',
        profiles: profiles?.map((e) => e.toHiveProfileModel()).toList() ?? [],
        count: count,
        longitude: longitude,
        latitude: latitude,
        lastMessage: lastMessage,
        lastReadMessageId: lastReadMessageId,
        lastMessageAt: lastMessageAt,
        imagePath: imagePath,
        active: active,
        alarm: alarm);
  }
}
