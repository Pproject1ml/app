import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/features/chat/data/model/chat_message.dart';
import 'package:chat_location/features/chat/data/model/chatroom.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

abstract class ChattingRepository {
  Future<List<ChatRoomModel>> getAllChatRoomsFromServer(
      {required String profileId});
  Future<dynamic> updateChatRoom(String roomId, dynamic data);
  void subscribeChatRoom(
      {required String roomId,
      required void Function(StompFrame) onMessage,
      String? command});
  Future<void> unSubscribeChatRoom({required String roomId, String? command});
  Future<void> disconnectSocket();
  // Future<List<int>> getChatMessages(String startChatId, String? endChatId);
  Future<void> sendChatMessage(ChatMessageModel message);
  Future<ChatMessageModel> updateChatMessage(ChatMessageModel message);
  Future<void> saveMessageLocal(ChatMessageHiveModel message);
  Future<void> saveChatroomLocal(ChatRoomHiveModel message);
  Future<void> deleteMessageLocal(String chatroomId);
  Future<void> deleteChatroomLocal(String chatroomId);
  Future<List<int>> getMessageKeysLocal(String chatroomId);
  Future<List<ChatMessageInterface>> getMessageLocal(
      {required List<int> candidateKeys,
      String? lastMessageId,
      required String chatroomId});
}
