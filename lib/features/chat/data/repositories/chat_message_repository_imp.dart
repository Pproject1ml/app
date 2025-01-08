import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/newtwork/socket_client.dart';
import 'package:chat_location/features/chat/domain/repositories/chat_message_repository.dart';

class ChatMessageRepositoryImp implements ChatMessageRepository {
  final SocketClient socketClient;
  ChatMessageRepositoryImp(this.socketClient);
  @override
  Future<List> getChatMessages(String startChatId, String? endChatId) {
    // http로 메시지 가져오기
    throw UnimplementedError();
  }

  @override
  Future<void> sendChatMessage(ChatMessage message) async {
    // sockeet으로 매시지 보내기
    socketClient.sendMessage(message);
  }

  @override
  Future<ChatMessage> updateChatMessage(ChatMessage message) {
    // socket으로 메시지 업데이트 하기
    throw UnimplementedError();
  }
}
