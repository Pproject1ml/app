import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/core/newtwork/socket_client.dart';
import 'package:chat_location/features/chat/data/repositories/chat_message_repository_imp.dart';
import 'package:chat_location/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatRoomRepositoryImp implements ChatRoomRepository {
  final SocketClient socketClient;
  final ApiClient apiClient;

  ChatRoomRepositoryImp(
    this.socketClient,
    this.apiClient,
  );
  @override
  Future<List<ChatRoom>> getAllChatRooms() {
    // http 로 채팅방 정보를 가져옴
    //  가져온 정보를 return 한다.
    throw UnimplementedError();
  }

  @override
  Future updateChatRoom(String roomId, data) {
    // socket으로 구독을 한다.
    // 메세지가 올때마다 return 한다.

    throw UnimplementedError();
  }

  @override
  Future<void> subscribeChatRoom(
      String roomId, void Function(StompFrame) onMessage) async {
    socketClient.subscribeToRoom(roomId, onMessage);
    throw UnimplementedError();
  }
}
