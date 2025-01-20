// // Chat Rooms Notifier
// import 'dart:convert';
// import 'dart:developer';

// import 'package:chat_location/constants/data.dart';
// import 'package:chat_location/controller/isolate_controller.dart';
// import 'package:chat_location/core/database/no_sql/chat_message.dart';
// import 'package:chat_location/core/database/no_sql/chat_room.dart';
// import 'package:chat_location/core/newtwork/api_client.dart';
// import 'package:chat_location/features/chat/data/model/chatroom.dart';
// import 'package:chat_location/features/chat/data/repositories/chat_message_repository_imp.dart';
// import 'package:chat_location/features/chat/data/repositories/chat_room_repository_impl.dart';
// import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
// import 'package:chat_location/features/chat/presentation/provider/socket_controller.dart';

// import 'package:chat_location/features/user/domain/entities/profile.dart';
// import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';
// import 'package:stomp_dart_client/stomp_dart_client.dart';

// class ChatRoomController extends StateNotifier<List<ChatRoomInterface>> {
//   final LazyBox<ChatRoomHiveModel> _chatRoomBox;
//   final ChatRoomRepositoryImp chatRoomRepository;
//   // final HiveIsolateController isolateController;
//   final ProfileInterface userInfo;
//   ChatRoomController(
//     this._chatRoomBox,
//     this.chatRoomRepository,
//     this.userInfo,
//   ) : super([]) {
//     _initializeChatRooms();
//   }

//   // 채팅방 initialize
//   Future<void> _initializeChatRooms() async {
//     log("채팅룸 initializer");
//     // 서버에서 채팅룸 요청 - 비동기
//     final Future<List<ChatRoomInterface>> _fetchCahtRoomData =
//         fetchChatRoomList();

//     // local chatRoom key 가져오기
//     final keys = _chatRoomBox.keys.toList();

//     List<ChatRoomHiveModel> localRooms = [];

//     for (final key in keys) {
//       final room = await _chatRoomBox.get(key);
//       if (room != null) {
//         localRooms.add(room);
//         await _openChattingMessageBox(key);
//       }
//     }

//     state = localRooms.map((v) => ChatRoomInterface.fromHiveModel(v)).toList();
//     try {
//       final serverData = await _fetchCahtRoomData;
//       // state 변경
//       await _syncronizeChatRooms(serverData);
//       state = serverData;
//     } catch (e) {
//       throw '채팅방을 불러오는데 실패하였습니다.';
//     }
//   }

//   Map<String, ProfileInterface> getChatRoomInterFace(String id) {
//     final roomIndex = state.indexWhere((ele) => ele.chatroomId == id);
//     if (roomIndex == -1) return {};
//     return state[roomIndex].profiles;
//   }

//   // Future<void> _
//   // message local db 열기
//   Future<void> _openChattingMessageBox(String chatRoomId) async {
//     final boxName = HIVE_CHAT_MESSAGE + "${chatRoomId}";
//     log("message box name : ${boxName}");
//     try {
//       if (!Hive.isBoxOpen(boxName)) {
//         await Hive.openLazyBox<ChatMessageHiveModel>(boxName);
//       }
//     } catch (e) {
//       log("채팅 박스 열기 실패");
//       throw '핸드폰에 저장된 채팅정보를 불러오는데 실패하였습니다.';
//     }
//   }

//   // chat room list 가져오기
//   Future<List<ChatRoomInterface>> fetchChatRoomList() async {
//     try {
//       // 서버에서 모든 room 정보를 가져옵니다.
//       final res = await chatRoomRepository
//           .getAllChatRoomsFromServer(profileId: userInfo.profileId)
//           .then((v) {
//         return v.map((v2) => ChatRoomInterface.fromChatRoomModel(v2)).toList();
//       });

//       return res;
//     } catch (e, s) {
//       throw '채팅방 정보를 가져오는데 실패하였습니다.';
//     }
//   }

//   // 채팅방 추가하기
//   Future<void> addChatRoom(ChatRoomInterface chatRoom) async {
//     try {
//       // local db - 채팅방 추가
//       await _chatRoomBox.put(chatRoom.chatroomId, chatRoom.toHiveModel());
//       // local db - 해당 채팅방 생성
//       await _openChattingMessageBox(chatRoom.chatroomId);
//       // 상태 변경
//       state = [...state, chatRoom];
//     } catch (e) {
//       log(e.toString());
//       throw "채팅방 추가하기에 실패하였습니다.";
//     }
//   }

//   // 채팅방 삭제
//   Future<void> removeChatRoom(String chatRoomId) async {
//     try {
//       final boxName = HIVE_CHAT_MESSAGE + "${chatRoomId}";
//       // local db -  해당 채팅방을 삭제
//       await _chatRoomBox.delete(chatRoomId);
//       // local db -  해당 채팅 모두 삭제
//       await Hive.lazyBox<ChatMessageHiveModel>(boxName).deleteFromDisk();
//       // state 변경
//       state = state.where((room) => room.chatroomId != chatRoomId).toList();
//     } catch (e) {
//       log(e.toString());
//       throw "채팅방 삭제에 실패하였습니다.";
//     }
//   }

//   // 채팅방 업데이트
//   Future<void> updateChatRoom(ChatRoomInterface updatedRoom) async {
//     try {
//       //  local db - 해당 채팅방 업데이트
//       _chatRoomBox.put(updatedRoom.chatroomId, updatedRoom.toHiveModel());
//       // state 변경
//       state = [
//         for (final room in state)
//           if (room.chatroomId == updatedRoom.chatroomId) updatedRoom else room
//       ];
//     } catch (e) {
//       log(e.toString());
//       throw '채팅방 업데이트에 실패했습니다.';
//     }
//   }

//   // 여러 채팅방 업데이트
//   Future<void> _syncronizeChatRooms(
//       List<ChatRoomInterface> updatedRooms) async {
//     try {
//       for (final room in updatedRooms) {
//         // local db - 변경사항 저장
//         await _chatRoomBox.put(room.chatroomId, room.toHiveModel());
//         // 채팅방 box가 안켜져 있다면 키도록
//         await _openChattingMessageBox(room.chatroomId);
//         // 채팅 provider 켜기

//         // 채팅방 구독하기
//         chatRoomRepository.subscribeChatRoom(
//           roomId: room.chatroomId,
//           onMessage: onMessage,
//         );
//       }

//       // 상태 업데이트
//       final updatedRoomMap = {
//         for (var room in updatedRooms) room.chatroomId: room
//       };
//       state = [
//         for (var room in state)
//           updatedRoomMap[room.chatroomId] ??
//               room, // updatedRoomMap에 있으면 업데이트된 room 사용, 없으면 기존 room 유지
//         ...updatedRooms.where((room) =>
//             !state.any((r) => r.chatroomId == room.chatroomId)), // 새로운 room 추가
//       ];
//     } catch (e, s) {
//       log('${e.toString()} ///${s.toString()}');
//     }
//   }

//   void unsubscribe(String roomId) async {
//     chatRoomRepository.unSubscribeChatRoom(roomId: roomId);
//   }

//   void subscribe({required String roomId, String? command}) {
//     chatRoomRepository.subscribeChatRoom(
//         roomId: roomId, onMessage: onMessage, command: command);
//   }

//   // 프로필 정보 추가 (JOIN)시 활용
//   void addProfile(String roomId, ProfileInterface profile) {
//     // 현재 데이터 저장 index 찾기
//     final roomIndex = state.indexWhere((ele) => ele.chatroomId == roomId);
//     if (roomIndex == -1) return;
//     // chatRoomInterface
//     ChatRoomInterface _tmpData = state[roomIndex];
//     // profiles
//     final _profiles = _tmpData.profiles;
//     // profiles에 추가
//     _profiles.addAll({profile.profileId: profile});
//     _tmpData = _tmpData.copyWith(profiles: _profiles);
//     // state 변경
//     state = [_tmpData, ...state.sublist(roomIndex)];
//   }

//   // 프로필 정보 추가 (DIE)시 활용
//   void deleteProfile(String roomId, ProfileInterface profile) {
//     // 현재 데이터 저장 index 찾기
//     final roomIndex = state.indexWhere((ele) => ele.chatroomId == roomId);
//     if (roomIndex == -1) return;
//     // chatRoomInterface
//     ChatRoomInterface _tmpData = state[roomIndex];
//     // profiles
//     final _profiles = _tmpData.profiles;
//     // profiles에 삭제
//     _profiles.removeWhere((k, v) => k == profile.profileId);
//     _tmpData = _tmpData.copyWith(profiles: _profiles);
//     // state 변경
//     state = [_tmpData, ...state.sublist(roomIndex)];
//   }

//   Future<void> refreshChatRoom() async {
//     try {
//       // 1. 서버에서 채팅방을 가져온다.
//       final _chatrooms = await fetchChatRoomList();
//       // 2.  새로운 채팅방이면 local db에 추가한다. , _openChattingMessageBox 한다. subscribe 한다.,
//       final _needToSubScribe =
//           _chatrooms.toSet().difference(state.toSet()).toList();
//       // 3. 없는 채팅방이면  unSubscribe 한다. local db에 삭제 한다. chattingmessagebox 삭제한다.
//       final _needToUnsubscribe =
//           state.toSet().difference(_chatrooms.toSet()).toList();
//       // 4. state를 _chatrooms 로 최신화 한다.
//       state = _chatrooms;
//     } catch (e) {}
//   }

//   Future<void> onMessage(StompFrame onMessage) async {
//     switch (onMessage.command) {
//       case "SEND":
//         if (onMessage.body != null) {
//           final res = json.decode(onMessage.body!);
//           final data = ChatRoomModel.fromJson(res);
//           final interface = ChatRoomInterface.fromChatRoomModel(data);
//           // 1. update chat room
//           updateChatRoom(interface);
//         }

//         break;
//     }
//   }

//   Future<void> joinChatRoom(String chatRoomId) async {
//     // 1. 서버에 join을 알림,
//     // 2. local에 추가함
//     // 3. state 변경
//   }
//   Future<void> dieChatRoom(String chatRoomId) async {
//     // 1. 서버에 die 알림,
//     // 2. local에 삭제함
//     // 3. state 변경
//   }

//   // ChatRoom? getChatRoom(String chatRoomId) {
//   //   try {
//   //     return state.firstWhere((room) => room.id == chatRoomId);
//   //   } catch (e) {
//   //     return null;
//   //   }
//   // }
// }

// // Hive LazyBox Provider
// final chatRoomLazyBoxProvider = Provider<LazyBox<ChatRoomHiveModel>>((ref) {
//   // LazyBox 열기
//   if (!Hive.isBoxOpen(HIVE_CHATROOM)) {
//     throw Exception(
//         'LazyBox "chatRooms" is not open. Did you forget to open it?');
//   }
//   return Hive.lazyBox<ChatRoomHiveModel>(HIVE_CHATROOM);
// });

// // ChatRoomController Provider
// final chatRoomControllerProvider =
//     StateNotifierProvider<ChatRoomController, List<ChatRoomInterface>>((ref) {
//   final box = ref.read(chatRoomLazyBoxProvider);
//   final chatRepository = ref.read(chatRoomRepositoryProvider);
//   final userInfo = ref.read(userProvider)?.profile;
//   // final isolateController = ref.read(hiveIsolateProvider);
//   assert(userInfo != null);
//   log("chat room controller start");
//   ref.onDispose(
//     () {
//       log("chat room controller dispose");
//     },
//   );
//   return ChatRoomController(box, chatRepository, userInfo!);
// });

// // chatRoom 관련 provider
// final chatRoomRepositoryProvider = Provider((ref) => ChatRoomRepositoryImp(
//     ref.read(chatSocketNotifierProvider.notifier),
//     ref.read(apiClientProvider)));

// final apiClientProvider = Provider((ref) => ApiClient(BASE_URL));
