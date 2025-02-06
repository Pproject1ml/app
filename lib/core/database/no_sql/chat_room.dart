import 'package:chat_location/core/database/no_sql/profile.dart';
import 'package:chat_location/features/user/data/models/profile.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@HiveType(typeId: 1)
@JsonSerializable() // json_serializable 사용
class ChatRoomHiveModel extends HiveObject {
  @HiveField(0)
  final String chatroomId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int? count;

  @HiveField(3)
  final List<ProfileHiveModel> profiles;

  @HiveField(4)
  final String? lastMessage;

  @HiveField(5)
  final String? lastReadMessageId;

  @HiveField(6)
  final double longitude;

  @HiveField(7)
  final double latitude;

  @HiveField(8)
  final DateTime? lastMessageAt;

  @HiveField(9)
  final String? imagePath;

  @HiveField(10)
  final bool active;

  @HiveField(11)
  final bool alarm;

  ChatRoomHiveModel(
      {required this.chatroomId,
      required this.title,
      this.count,
      required this.profiles,
      required this.lastMessage,
      this.lastReadMessageId,
      required this.longitude,
      required this.latitude,
      this.lastMessageAt,
      this.imagePath,
      required this.active,
      required this.alarm});

  factory ChatRoomHiveModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomHiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomHiveModelToJson(this);

  ChatRoomHiveModel copyWith({
    String? chatroomId,
    String? title,
    int? count,
    List<ProfileHiveModel>? profiles,
    String? lastMessage,
    String? lastReadMessageId,
    double? longitude,
    double? latitude,
    DateTime? lastMessageAt,
    String? imagePath,
    bool? active,
    bool? alarm,
  }) {
    return ChatRoomHiveModel(
      chatroomId: chatroomId ?? this.chatroomId,
      title: title ?? this.title,
      count: count ?? this.count,
      profiles: profiles ?? this.profiles,
      lastMessage: lastMessage ?? this.lastMessage,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      imagePath: imagePath ?? this.imagePath,
      active: active ?? this.active,
      alarm: alarm ?? this.alarm,
    );
  }
}
