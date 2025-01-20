import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/features/chat/data/model/chatroom.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

abstract class ChatRoomRepository {
  Future<List<ChatRoomModel>> getAllChatRoomsFromServer(
      {required String profileId});
  Future<dynamic> updateChatRoom(String roomId, dynamic data);
  Future<void> subscribeChatRoom(
      {required String roomId,
      required void Function(StompFrame) onMessage,
      String? command});
  Future<void> unSubscribeChatRoom({required String roomId, String? command});
}
