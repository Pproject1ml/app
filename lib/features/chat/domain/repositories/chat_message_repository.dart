import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/features/chat/data/model/chat_message.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

abstract class ChatMessageRepository {
  Future<List<dynamic>> getChatMessages(String startChatId, String? endChatId);
  Future<void> sendChatMessage(ChatMessageModel message);
  Future<ChatMessageModel> updateChatMessage(ChatMessageModel message);
  Future<void> subscribeChatRoom(
      {required String roomId,
      required void Function(StompFrame) onMessage,
      String? command});

  Future<void> unSubscribeChatRoom({
    required String roomId,
    required String profileId,
  });
  Future<void> saveMessageLocal(ChatMessageHiveModel message);
  Future<List<dynamic>> getMessageKeysLocal();
  Future<List<ChatMessageInterface>> getMessageLocal(
      {required List<dynamic> candidateKeys,
      required int from,
      required int to});
}
