import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

abstract class ChatRoomRepository {
  Future<List<ChatRoom>> getAllChatRooms();
  Future<dynamic> updateChatRoom(String roomId, dynamic data);
  Future<void> subscribeChatRoom(
      String roomId, void Function(StompFrame) onMessage);
}
