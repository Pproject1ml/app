import 'package:chat_location/core/database/no_sql/chat_message.dart';

class ChatMessageModel {
  final String? messageId;
  final String chatroomId;
  final String profileId;
  final String content;
  final String messageType;
  final DateTime? createdAt;

  ChatMessageModel(
      {this.messageId,
      required this.chatroomId,
      required this.profileId,
      required this.content,
      required this.messageType,
      this.createdAt});

  /// JSON -> 객체
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
        messageId: json['messageId'] as String,
        chatroomId: json['chatroomId'] as String,
        profileId: json['profileId'] as String,
        content: json['content'] as String,
        messageType: json['messageType'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String));
  }

  /// 객체 -> JSON
  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'profileId': profileId,
      'content': content,
      'messageType': messageType,
    };
  }

  ChatMessageHiveModel toHiveMessage() {
    assert(messageId != null && createdAt != null);
    return ChatMessageHiveModel(
        messageId: messageId!,
        chatRoomId: chatroomId,
        profileId: profileId,
        content: content,
        messageType: messageType,
        createdAt: createdAt!);
  }
}
