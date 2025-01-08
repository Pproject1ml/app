// Chat Rooms Notifier
import 'dart:convert';
import 'dart:developer';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/chat/data/repositories/chat_message_repository_imp.dart';
import 'package:chat_location/features/chat/data/repositories/chat_room_repository_impl.dart';
import 'package:chat_location/features/chat/presentation/provider/socket_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatRoomController extends StateNotifier<List<ChatRoom>> {
  final LazyBox<ChatRoom> _chatRoomBox;
  final ChatRoomRepositoryImp chatRoomRepository;
  ChatRoomController(this._chatRoomBox, this.chatRoomRepository) : super([]) {
    _initializeChatRooms();
  }

  // 채팅방 initialize
  Future<void> _initializeChatRooms() async {
    // 서버에서 채팅룸 요청 - 비동기
    final Future<List<ChatRoom>> _fetchCahtRoomData = _fetchChatRoomList();

    // local chatRoom key 가져오기
    final keys = _chatRoomBox.keys.toList();

    List<ChatRoom> localRooms = [];

    for (final key in keys) {
      final room = await _chatRoomBox.get(key);
      if (room != null) {
        localRooms.add(room);
        await _openChattingMessageBox(key);
      }
    }

    state = localRooms;
    try {
      final serverData = await _fetchCahtRoomData;
      // state 변경
      await _syncronizeChatRooms(serverData);

      state = serverData;
    } catch (e) {
      throw '채팅방을 불러오는데 실패하였습니다.';
    }
  }

  // Future<void> _
  // message local db 열기
  Future<void> _openChattingMessageBox(String chatRoomId) async {
    final boxName = HIVE_CHAT_MESSAGE + "${chatRoomId}";
    log("message box name : ${boxName}");
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openLazyBox<ChatMessage>(boxName);
      }
    } catch (e) {
      log("채팅 박스 열기 실패");
      throw '핸드폰에 저장된 채팅정보를 불러오는데 실패하였습니다.';
    }
  }

  // chat room list 가져오기
  Future<List<ChatRoom>> _fetchChatRoomList() async {
    try {
      // 서버에서 모든 room 정보를 가져옵니다.
      final res = await chatRoomRepository.getAllChatRooms();
      return res;
    } catch (e) {
      log(e.toString());
      throw '채팅방 정보를 가져오는데 실패하였습니다.';
    }
  }

  // 채팅방 추가하기
  Future<void> addChatRoom(ChatRoom chatRoom) async {
    try {
      // local db - 채팅방 추가
      await _chatRoomBox.put(chatRoom.chatroomId, chatRoom);
      // local db - 해당 채팅방 생성
      await _openChattingMessageBox(chatRoom.chatroomId);
      // 상태 변경
      state = [...state, chatRoom];
    } catch (e) {
      log(e.toString());
      throw "채팅방 추가하기에 실패하였습니다.";
    }
  }

  // 채팅방 삭제
  Future<void> removeChatRoom(String chatRoomId) async {
    try {
      final boxName = HIVE_CHAT_MESSAGE + "${chatRoomId}";
      // local db -  해당 채팅방을 삭제
      await _chatRoomBox.delete(chatRoomId);
      // local db -  해당 채팅 모두 삭제
      await Hive.lazyBox<ChatMessage>(boxName).deleteFromDisk();
      // state 변경
      state = state.where((room) => room.chatroomId != chatRoomId).toList();
    } catch (e) {
      log(e.toString());
      throw "채팅방 삭제에 실패하였습니다.";
    }
  }

  // 채팅방 업데이트
  Future<void> updateChatRoom(ChatRoom updatedRoom) async {
    try {
      //  local db - 해당 채팅방 업데이트
      await _chatRoomBox.put(updatedRoom.chatroomId, updatedRoom);
      // state 변경
      state = [
        for (final room in state)
          if (room.chatroomId == updatedRoom.chatroomId) updatedRoom else room
      ];
    } catch (e) {
      log(e.toString());
      throw '채팅방 업데이트에 실패했습니다.';
    }
  }

  // 여러 채팅방 업데이트
  Future<void> _syncronizeChatRooms(List<ChatRoom> updatedRooms) async {
    for (final room in updatedRooms) {
      // local db - 변경사항 저장
      await _chatRoomBox.put(room.chatroomId, room);
      // 채팅방 box가 안켜져 있다면 키도록
      await _openChattingMessageBox(room.chatroomId);
      // 채팅 provider 켜기

      // 채팅방 구독하기
      chatRoomRepository.subscribeChatRoom(room.chatroomId, _onMessage);
    }

    // 상태 업데이트
    final updatedRoomMap = {
      for (var room in updatedRooms) room.chatroomId: room
    };
    state = [
      for (var room in state)
        updatedRoomMap[room.chatroomId] ??
            room, // updatedRoomMap에 있으면 업데이트된 room 사용, 없으면 기존 room 유지
      ...updatedRooms.where((room) =>
          !state.any((r) => r.chatroomId == room.chatroomId)), // 새로운 room 추가
    ];
  }

  Future<void> _onMessage(StompFrame onMessage) async {
    switch (onMessage.command) {
      case "SEND":
        if (onMessage.body != null) {
          final data = json.decode(onMessage.body!);
          // 1. update chat room
          // updateChatRoom(updatedRoom)
          // 2. update chat message
        }

        break;
    }
  }

  Future<void> joinChatRoom(String chatRoomId) async {
    // 1. 서버에 join을 알림,
    // 2. local에 추가함
    // 3. state 변경
  }
  Future<void> dieChatRoom(String chatRoomId) async {
    // 1. 서버에 die 알림,
    // 2. local에 삭제함
    // 3. state 변경
  }

  // ChatRoom? getChatRoom(String chatRoomId) {
  //   try {
  //     return state.firstWhere((room) => room.id == chatRoomId);
  //   } catch (e) {
  //     return null;
  //   }
  // }
}

// Hive LazyBox Provider
final chatRoomLazyBoxProvider = Provider<LazyBox<ChatRoom>>((ref) {
  // LazyBox 열기
  if (!Hive.isBoxOpen(HIVE_CHATROOM)) {
    throw Exception(
        'LazyBox "chatRooms" is not open. Did you forget to open it?');
  }
  return Hive.lazyBox<ChatRoom>(HIVE_CHATROOM);
});

// ChatRoomController Provider
final chatRoomControllerProvider =
    StateNotifierProvider.autoDispose<ChatRoomController, List<ChatRoom>>(
        (ref) {
  final box = ref.read(chatRoomLazyBoxProvider);
  final chatRepository = ref.read(chatRoomRepositoryProvider);
  log("chat room controller start");
  ref.onDispose(
    () {
      log("chat room controller dispose");
    },
  );
  return ChatRoomController(box, chatRepository);
});

// chatRoom 관련 provider
final chatRoomRepositoryProvider = Provider((ref) => ChatRoomRepositoryImp(
    ref.read(socketClientProvider), ref.read(apiClientProvider)));

final apiClientProvider = Provider((ref) => ApiClient(BASE_URL));
