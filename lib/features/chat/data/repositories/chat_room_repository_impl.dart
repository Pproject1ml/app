// import 'dart:developer';

// import 'package:chat_location/core/database/no_sql/chat_room.dart';
// import 'package:chat_location/core/newtwork/api_client.dart';
// import 'package:chat_location/core/newtwork/socket_client.dart';
// import 'package:chat_location/features/chat/data/model/chatroom.dart';
// import 'package:chat_location/features/chat/data/repositories/chat_message_repository_imp.dart';
// import 'package:chat_location/features/chat/domain/repositories/chat_room_repository.dart';
// import 'package:chat_location/features/chat/presentation/provider/socket_controller.dart';
// import 'package:stomp_dart_client/stomp_dart_client.dart';

// class ChatRoomRepositoryImp implements ChatRoomRepository {
//   final ChatSocketClientNotifier socketClient;
//   final ApiClient apiClient;

//   ChatRoomRepositoryImp(
//     this.socketClient,
//     this.apiClient,
//   );
//   @override
//   Future<List<ChatRoomModel>> getAllChatRoomsFromServer(
//       {required String profileId}) async {
//     // http 로 채팅방 정보를 가져옴
//     try {
//       final queryParameters = {"id": profileId};
//       final res = await apiClient.get(
//           endpoint: '/chat/list', queryParameters: queryParameters);

//       final datas = res['data'] as List<dynamic>;

//       final chatRooms = datas.map((json) {
//         return ChatRoomModel.fromJson(json as Map<String, dynamic>);
//       }).toList();

//       return chatRooms;
//     } catch (e, stack_trace) {
//       log(e.toString());
//       log(stack_trace.toString());
//       throw "서버에서 채팅방 가저오기 실패하였습니다";
//     }
//   }

//   @override
//   Future updateChatRoom(String roomId, data) {
//     // socket으로 구독을 한다.
//     // 메세지가 올때마다 return 한다.

//     throw UnimplementedError();
//   }

//   @override
//   Future<void> subscribeChatRoom(
//       {required String roomId,
//       required void Function(StompFrame) onMessage,
//       String? command}) async {
//     socketClient.subscribeChatRoom(
//         roomId: roomId, onMessage: onMessage, command: command);
//   }

//   @override
//   Future<void> unSubscribeChatRoom(
//       {required String roomId, String? command}) async {
//     socketClient.unSubscribeChatRoom(roomId: roomId, command: command);
//   }
// }
