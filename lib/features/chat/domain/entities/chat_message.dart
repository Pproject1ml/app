import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/features/chat/data/model/chat_message.dart';
import 'package:chat_location/features/chat/data/model/chatroom.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';

enum MessageType { TEXT }

class ChatMessageInterface {
  final String? messageId;
  final String chatroomId;
  final String profileId;
  final String content;
  final String messageType;
  final DateTime? createdAt;

  ChatMessageInterface(
      {this.messageId,
      required this.chatroomId,
      required this.profileId,
      required this.content,
      this.createdAt,
      required this.messageType});

  factory ChatMessageInterface.fromHiveModel(ChatMessageHiveModel data) {
    return ChatMessageInterface(
      messageId: data.messageId,
      chatroomId: data.chatRoomId,
      profileId: data.profileId,
      content: data.content,
      messageType: data.messageType,
      createdAt: data.createdAt,
    );
  }
  factory ChatMessageInterface.fromChatMessageModel(ChatMessageModel data) {
    return ChatMessageInterface(
      messageId: data.messageId,
      chatroomId: data.chatroomId,
      profileId: data.profileId,
      content: data.content,
      messageType: data.messageType,
      createdAt: data.createdAt,
    );
  }
  ChatMessageModel toChatMessageModel() {
    return ChatMessageModel(
        chatroomId: chatroomId,
        profileId: profileId,
        content: content,
        messageType: messageType);
  }
}
