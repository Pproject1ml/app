import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/features/user/data/models/profile.dart';

class ChatRoomModel {
  final String chatroomId;
  final String title;
  final int count;
  final List<ProfileModel>? profiles;
  final String? lastMessage;
  final String? lastReadMessageId;
  final double longitude;
  final double latitude;
  final DateTime? lastMessageAt;
  final String? imagePath;
  ChatRoomModel(
      {required this.chatroomId,
      required this.title,
      required this.count,
      required this.profiles,
      this.lastMessage,
      this.lastReadMessageId,
      required this.latitude,
      required this.longitude,
      this.lastMessageAt,
      this.imagePath});

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
        chatroomId: json['chatroomId'] as String,
        title: json['title'] as String,
        count: json['count'] as int,
        profiles: json['profiles'] != null
            ? (json['profiles'] as List<dynamic>)
                .map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        lastMessage: json['lastMessage'] as String?,
        lastReadMessageId: json['lastReadMessageId'] as String?,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        lastMessageAt: json['lastMessageAt'] != null
            ? DateTime.parse(json['lastMessageAt'] as String)
            : null,
        imagePath: json['imagePath'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'title': title,
      'profiles': profiles?.map((e) => e.toJson()).toList(),
      'lastMessage': lastMessage,
      'lastReadMessageId': lastReadMessageId,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'count': count
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
    );
  }

  ChatRoomHiveModel toHiveModel() {
    return ChatRoomHiveModel(
      chatroomId: chatroomId,
      title: title,
      profiles: profiles?.map((e) => e.toHiveProfileModel()).toList() ?? [],
      count: count,
      longitude: longitude,
      latitude: latitude,
      lastMessage: lastMessage,
      lastReadMessageId: lastReadMessageId,
      lastMessageAt: lastMessageAt,
    );
  }
}
