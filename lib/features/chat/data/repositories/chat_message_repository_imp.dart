// import 'dart:developer';

// import 'package:chat_location/constants/data.dart';
// import 'package:chat_location/core/database/no_sql/chat_message.dart';
// import 'package:chat_location/core/newtwork/isolate.dart';
// import 'package:chat_location/core/newtwork/socket_client.dart';
// import 'package:chat_location/features/chat/data/model/chat_message.dart';
// import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
// import 'package:chat_location/features/chat/domain/repositories/chat_message_repository.dart';
// import 'package:chat_location/features/chat/presentation/provider/socket_controller.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:stomp_dart_client/stomp_dart_client.dart';

// class ChatMessageRepositoryImp implements ChatMessageRepository {
//   final ChatSocketClientNotifier chatSocketNotifier;
//   final LazyBox<ChatMessageHiveModel> box;
//   final String chatRoomId;
//   ChatMessageRepositoryImp(this.chatSocketNotifier, this.chatRoomId, this.box);

//   Future<void> deleteAllMessage(keys) async {
//     await box.deleteAll(keys);
//   }

//   @override
//   Future<List> getChatMessages(String startChatId, String? endChatId) {
//     // http로 메시지 가져오기
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> sendChatMessage(ChatMessageModel message) async {
//     // sockeet으로 매시지 보내기
//     chatSocketNotifier.sendMessage(message);
//   }

//   @override
//   Future<ChatMessageModel> updateChatMessage(ChatMessageModel message) {
//     // socket으로 메시지 업데이트 하기
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> subscribeChatRoom(
//       {required String roomId,
//       required void Function(StompFrame) onMessage,
//       String? command}) async {
//     chatSocketNotifier.subscribeChatRoom(
//         roomId: roomId, onMessage: onMessage, command: command);
//   }

//   @override
//   Future<void> unSubscribeChatRoom({
//     required String roomId,
//     required String profileId,
//   }) async {
//     final _header = {'chatroomId': roomId, 'profileId': profileId};
//     chatSocketNotifier.unSubscribeChatRoom(
//         roomId: roomId, command: "LEAVE", headers: _header);
//   }

//   @override
//   Future<void> saveMessageLocal(ChatMessageHiveModel message) async {
//     final boxKey = HIVE_CHAT_MESSAGE + "${chatRoomId}";
//     await box.put(message.messageId, message);
//     // final _data = {"key": message.messageId, "value": message};

//     // await runHiveTask(operation: 'write', boxKey: boxKey, data: _data);
//   }

//   @override
//   Future<List<int>> getMessageKeysLocal() async {
//     final boxKey = HIVE_CHAT_MESSAGE + "${chatRoomId}";
//     // final res = await runHiveTask(operation: 'keys', boxKey: boxKey, data: {});
//     // log('get keys: $res');
//     final keys = box.keys.map((key) => int.parse(key)).toList();
//     keys.sort();
//     log(keys.toString());
//     return keys;
//   }

// // 이거는 예외적으로 interface를 return 하게 하였습니다. -> list 두번 돌리는건 비효율적인거 같아요.
// // reverse 해서 줍니다.
//   @override
//   Future<List<ChatMessageInterface>> getMessageLocal(
//       {required List<dynamic> candidateKeys,
//       required int from,
//       required int to}) async {
//     // 시작 <= 끝 assertion 추가;
//     assert(from <= to);

//     try {
//       List<dynamic> keys = [];

//       keys = List.from(candidateKeys).sublist(from, to);

//       List<ChatMessageInterface> localMessages = [];
//       for (var i = keys.length - 1; i >= 0; i--) {
//         // background thread 에서 실행합니다.

//         final boxKey = HIVE_CHAT_MESSAGE + "${chatRoomId}";
//         // final res = await hiveManager.runHiveTask(
//         //     operation: 'read', boxKey: boxKey, data: {"key": keys[i]});
//         final _message = await box.get(keys[i].toString());

//         if (_message != null) {
//           localMessages.add(ChatMessageInterface.fromHiveModel(_message!));
//         }
//       }
//       return localMessages;
//     } catch (e) {
//       log(e.toString());
//       throw "메시지 불러오기에 실패하였습니다.";
//     }
//   }
// }
