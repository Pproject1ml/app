import 'package:chat_location/core/database/no_sql/chat_message.dart';

abstract class ChatMessageRepository {
  Future<List<dynamic>> getChatMessages(String startChatId, String? endChatId);
  Future<void> sendChatMessage(ChatMessage message);
  Future<ChatMessage> updateChatMessage(ChatMessage message);
}
