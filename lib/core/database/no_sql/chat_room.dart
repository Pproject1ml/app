import 'package:chat_location/features/user/data/models/profile.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@HiveType(typeId: 1)
@JsonSerializable() // json_serializable 사용
class ChatRoom extends HiveObject {
  @HiveField(0)
  final String chatroomId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<ProfileModel> members;

  @HiveField(3)
  final String lastMessage;

  @HiveField(4)
  final String lastReadMessageId;

  @HiveField(5)
  final DateTime updatedAt;

  ChatRoom(
      {required this.chatroomId,
      required this.title,
      required this.members,
      required this.lastMessage,
      required this.lastReadMessageId,
      required this.updatedAt});

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}
