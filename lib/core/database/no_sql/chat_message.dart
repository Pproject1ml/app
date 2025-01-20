import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart'; // 어댑터 코드를 생성하기 위한 파일 이름 선언

@HiveType(typeId: 0) // Unique typeId를 지정
@JsonSerializable() // json_serializable 사용
class ChatMessageHiveModel {
  @HiveField(0)
  final String messageId;

  @HiveField(1)
  final String chatRoomId;

  @HiveField(2)
  final String profileId;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final String messageType;

  @HiveField(5)
  final DateTime createdAt;

  ChatMessageHiveModel({
    required this.messageId,
    required this.chatRoomId,
    required this.profileId,
    required this.content,
    required this.messageType,
    required this.createdAt,
  });

  factory ChatMessageHiveModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageHiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageHiveModelToJson(this);
}
