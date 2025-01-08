import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart'; // 어댑터 코드를 생성하기 위한 파일 이름 선언

@HiveType(typeId: 0) // Unique typeId를 지정
@JsonSerializable() // json_serializable 사용
class ChatMessage {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String chatRoomId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String message;

  @HiveField(4)
  final DateTime timestamp;

  ChatMessage({
    this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
