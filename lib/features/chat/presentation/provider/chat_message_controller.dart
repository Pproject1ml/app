// // Chat Messages Notifier
// import 'dart:convert';
// import 'dart:developer';
// import 'package:chat_location/constants/data.dart';
// import 'package:chat_location/core/database/no_sql/chat_message.dart';
// import 'package:chat_location/features/chat/data/model/chat_message.dart';
// import 'package:chat_location/features/chat/data/repositories/chat_message_repository_imp.dart';
// import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
// import 'package:chat_location/features/chat/presentation/provider/chat_room_controller.dart';
// import 'package:chat_location/features/chat/presentation/provider/socket_controller.dart';
// import 'package:chat_location/features/user/domain/entities/profile.dart';
// import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:stomp_dart_client/stomp_dart_client.dart';

// const limit = 20;

// class ChatMessagesNotifier extends ChangeNotifier {
//   List<ChatMessageInterface> state = [];

//   bool initialLized = false;
//   final ChatMessageRepositoryImp chatRepository;

//   final String chatRoomId;
//   int getIndex = 0;
//   String boxKey = "";
//   List<int> candidateKeys = [];
//   ChatMessagesNotifier(this.chatRepository, this.chatRoomId) {
//     boxKey = HIVE_CHAT_MESSAGE + "${chatRoomId}";
//     _initializeChatMessages();
//   }

//   Future<void> _initializeChatMessages() async {
//     // 0. 구독 요청 다시 보내기
//     chatRepository.subscribeChatRoom(
//         roomId: chatRoomId,
//         onMessage: (StompFrame stompMessage) {
//           _onReceiveMessage(stompMessage);
//           if (initialLized) notifyListeners();
//         },
//         command: "ENTER");
//     // 1. local 채팅 불러오기
//     candidateKeys = await chatRepository.getMessageKeysLocal();
//     final localMessages = await getMessageLocal();
//     // // 2. 로컬 마지막 채팅 id 찾기
//     final startMessageId =
//         localMessages.length > 0 ? localMessages[0].messageId! : null;
//     // // 3. 소켓 처음 채팅 id 찾기
//     final endMessageId = state.length > 0 ? state[0].messageId : null;
//     // // 4. 서버에 데이터 요청

//     // await Future.delayed(Duration(seconds: 1));
//     final res = [];
//     state = [...state, ...res, ...localMessages];
//     // // 4. 순서에 맞게 list update
//     initialLized = true;
//     notifyListeners();
//   }

//   Future<void> loadMore() async {
//     try {
//       final bool isMessageEnd = getIndex <= 0;
//       if (!isMessageEnd) {
//         final isMessageEnough = getIndex > limit;

//         if (isMessageEnough) {
//           final from = getIndex - limit;
//           final to = getIndex;
//           final List<ChatMessageInterface> localMessages =
//               await chatRepository.getMessageLocal(
//                   candidateKeys: candidateKeys, from: from, to: to);
//           getIndex = getIndex - limit;
//           state = [...state, ...localMessages];
//         } else {
//           final to = getIndex;
//           final List<ChatMessageInterface> localMessages = await chatRepository
//               .getMessageLocal(candidateKeys: candidateKeys, from: 0, to: to);

//           state = [...state, ...localMessages];
//           getIndex = -1;
//         }

//         notifyListeners();
//       }
//     } catch (e) {
//       throw "마지막 메시지 입니다";
//     }
//   }

//   Future<List<ChatMessageInterface>> getMessageLocal() async {
//     try {
//       final bool isMessageEnough = candidateKeys.length >= limit;
//       int from = getIndex;
//       if (isMessageEnough)
//         from = candidateKeys.length - limit;
//       else
//         from = 0;
//       final res = await chatRepository.getMessageLocal(
//           candidateKeys: candidateKeys, from: from, to: candidateKeys.length);
//       getIndex = from;
//       return res;
//     } catch (e) {
//       log(e.toString());
//       throw "메시지 불러오기에 실패하였습니다.";
//     }
//   }

//   Future<void> _onReceiveMessage(StompFrame stompMessage) async {
//     final stompBody = jsonDecode(stompMessage.body!);
//     final _message = stompBody['data'];

//     switch (_message['messageType']) {
//       case "TEXT":
//         _onReceiveText(_message);
//         break;
//       case "ENTER":
//         _onReceiveENTER(_message);
//         break;
//       case "LEAVE":
//         _onReceiveLEAVE(_message);
//         break;
//       case "JOIN":
//         _onReceiveJOIN(_message);
//         break;
//       case "DIE":
//         _onReceiveDIE(_message);
//         break;
//       case "DATE":
//         _onReceiveDATE(_message);
//         break;
//     }
//   }

//   void _onReceiveText(dynamic _message) {
//     final ChatMessageModel res = ChatMessageModel(
//         messageId: _message['messageId'],
//         chatroomId: _message!['chatroomId'],
//         profileId: _message!['profileId'],
//         content: _message!['content'],
//         createdAt: DateTime.parse(_message['createdAt'] as String),
//         messageType: _message['messageType']);
//     final ChatMessageInterface message =
//         ChatMessageInterface.fromChatMessageModel(res);
//     // 상태 변경해주기
//     state = [message, ...state];
//     // local에 저장하기
//     _saveMessageLocal(res);
//   }

//   void _onReceiveDATE(dynamic _message) {
//     final ChatMessageModel res = ChatMessageModel(
//         messageId: _message['messageId'],
//         chatroomId: _message!['chatroomId'],
//         profileId: _message!['profileId'],
//         content: _message!['content'],
//         createdAt: DateTime.parse(_message['createdAt'] as String),
//         messageType: _message['messageType']);
//     final ChatMessageInterface message =
//         ChatMessageInterface.fromChatMessageModel(res);
//     // 상태 변경해주기
//     state = [message, ...state];
//     // local에 저장하기
//     _saveMessageLocal(res);
//   }

//   void _onReceiveJOIN(dynamic _message) {
//     // profiles 업데이트 하기
//   }
//   void _onReceiveDIE(dynamic _message) {
//     // profiles 업데이트 하기
//   }
//   void _onReceiveLEAVE(dynamic _message) {
//     // profiles 업데이트 하기
//   }
//   void _onReceiveENTER(dynamic _message) {
//     // profiles 업데이트 하기
//   }

//   void clearMessages() {
//     state = [];
//   }

//   Future<void> deleteAll() async {
//     await chatRepository
//         .deleteAllMessage(candidateKeys.map((key) => key.toString()).toList());
//   }

//   Future<void> _saveMessageLocal(ChatMessageModel message) async {
//     try {
//       final ChatMessageHiveModel _message = message.toHiveMessage();

//       await chatRepository.saveMessageLocal(_message);
//     } catch (e, s) {
//       log("save messag error");
//       log("${e.toString()}, ${s.toString()}");
//     }
//   }

//   Future<void> sendMessage(
//     String message,
//     String userId,
//   ) async {
//     // socket에 message 보내기
//     try {
//       final ChatMessageInterface _message = ChatMessageInterface(
//           chatroomId: chatRoomId,
//           profileId: userId,
//           content: message,
//           messageType: "TEXT");
//       await chatRepository.sendChatMessage(_message.toChatMessageModel());
//     } catch (e) {
//       log(e.toString());
//       throw "메시지 전송에 실패하였습니다.";
//     }
//   }
// }

// // Hive LazyBox Provider
// final chatMessageLazyBoxProvider =
//     Provider.family<LazyBox<ChatMessageHiveModel>, String>((ref, chatRoomId) {
//   // LazyBox 열기
//   final String boxKey = HIVE_CHAT_MESSAGE + "${chatRoomId}";
//   if (!Hive.isBoxOpen(boxKey)) {
//     throw Exception(
//         'LazyBox "chatRooms" is not open. Did you forget to open it?');
//   }
//   return Hive.lazyBox<ChatMessageHiveModel>(boxKey);
// });

// // Chat Messages State Provider
// final chatMessagesProvider =
//     ChangeNotifierProvider.autoDispose.family<ChatMessagesNotifier, String>(
//   (ref, chatRoomId) {
//     // socket client
//     final socketClient = ref.read(chatSocketNotifierProvider.notifier);
//     // local db
//     final hivebox = ref.read(chatMessageLazyBoxProvider(chatRoomId));
//     // chatMessage apis
//     final chatMessageRepository = ref.read(chatMessageRepositoryProvider(
//         {'box': hivebox, 'chatRoomId': chatRoomId}));
//     // 프로필 정보

//     ref.onDispose(() {
//       // 현재 채팅방 구독 취소
//       chatMessageRepository.unSubscribeChatRoom(
//           roomId: chatRoomId,
//           profileId: ref.read(userProvider)!.profile.profileId);

//       // 채팅 리스트 구독 추가
//       ref
//           .read(chatRoomControllerProvider.notifier)
//           .subscribe(roomId: chatRoomId);
//       log("chat message provider dispose roomNum: ${chatRoomId}");
//     });
//     return ChatMessagesNotifier(chatMessageRepository, chatRoomId);
//   },
// );

// final chatMessageRepositoryProvider = Provider.autoDispose.family(
//     (ref, Map<String, dynamic> data) => ChatMessageRepositoryImp(
//         ref.read(chatSocketNotifierProvider.notifier),
//         data['chatRoomId'],
//         data['box']));
