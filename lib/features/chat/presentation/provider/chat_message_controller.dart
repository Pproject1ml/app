// Chat Messages Notifier
import 'dart:developer';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/features/chat/data/repositories/chat_message_repository_imp.dart';
import 'package:chat_location/features/chat/presentation/provider/chat_room_controller.dart';
import 'package:chat_location/features/chat/presentation/provider/socket_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

const limit = 20;

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatMessageRepositoryImp chatRepository;
  final LazyBox<ChatMessage> _chatMessageBox;
  final String chatRoomId;
  int getIndex = 0;
  String boxKey = "";
  List<dynamic> candidateKeys = [];
  ChatMessagesNotifier(
      this.chatRepository, this._chatMessageBox, this.chatRoomId)
      : super([]) {
    boxKey = chatRoomId + "${chatRoomId}";
    log("${chatRoomId} initializw");
    _initializeChatMessages();
  }

  Future<void> _initializeChatMessages() async {
    // 1. local 채팅 불러오기
    candidateKeys = _chatMessageBox.keys.toList();
    await getMessageLocal();
    // 2. 마지막 채팅 id 찾기
    // 3. socket 에서 들어오는 메시지 temp 에 저장하기 - 비동기
    // 3. 서버에 요청하기 (local to temp[0])
    // 4. 순서에 맞게 list update
  }

  Future<void> loadMore() async {
    try {
      if (getIndex > 0) {
        List<dynamic> keys = [];
        if (getIndex - limit > 0) {
          keys = List.from(candidateKeys).sublist(getIndex - limit, (getIndex));
          getIndex = getIndex - limit;
        } else {
          keys = List.from(candidateKeys).sublist(0, (getIndex));
          getIndex = -1;
        }

        List<ChatMessage> localMessages = [];
        for (var i = keys.length - 1; i >= 0; i--) {
          final _message = await _chatMessageBox.get(keys[i]);
          if (_message != null) {
            localMessages.add(_message);
          }
        }

        state = [...state, ...localMessages];
      }
    } catch (e) {
      throw "마지막 메시지 입니다";
    }
  }

  Future<void> getMessageLocal() async {
    try {
      log("get message local start , length of candidate keys : ${candidateKeys.length}");
      List<dynamic> keys = [];
      if (candidateKeys.length - limit >= 0) {
        getIndex = candidateKeys.length - limit;
        keys =
            List.from(candidateKeys).sublist(getIndex, (candidateKeys.length));
      } else {
        getIndex = 0;
        keys = List.from(candidateKeys).sublist(0, (candidateKeys.length));
      }

      List<ChatMessage> localMessages = [];
      for (var i = keys.length - 1; i >= 0; i--) {
        final _message = await _chatMessageBox.get(keys[i]);
        if (_message != null) {
          localMessages.add(_message);
        }
      }
      state = localMessages;
    } catch (e) {
      log(e.toString());
      throw "메시지 불러오기에 실패하였습니다.";
    }
  }

  void addMessage(ChatMessage message) {
    state = [message, ...state];
  }

  void clearMessages() {
    state = [];
  }

  Future<void> sendMessage(String message, String userId) async {
    // message 보내기
    var uuid = Uuid();
    final key = uuid.v1();
    try {
      final now = DateTime.now();
      final ChatMessage _message = ChatMessage(
          id: key,
          chatRoomId: chatRoomId,
          senderId: userId,
          message: message,
          timestamp: now);
      await Future.delayed(Duration(seconds: 0));
      log('서버 저장 완료');
      addMessage(_message);
      log('message state 변경');
      await _chatMessageBox.put(key, _message);
      log("messgae 저장 완료");
    } catch (e) {
      log(e.toString());
      throw "메시지 전송에 실패하였습니다.";
    }
  }
}

// Hive LazyBox Provider
final chatMessageLazyBoxProvider =
    Provider.family<LazyBox<ChatMessage>, String>((ref, chatRoomId) {
  // LazyBox 열기
  final String boxKey = HIVE_CHAT_MESSAGE + "${chatRoomId}";
  if (!Hive.isBoxOpen(boxKey)) {
    throw Exception(
        'LazyBox "chatRooms" is not open. Did you forget to open it?');
  }
  return Hive.lazyBox<ChatMessage>(boxKey);
});

// Chat Messages State Provider
final chatMessagesProvider = StateNotifierProvider.autoDispose
    .family<ChatMessagesNotifier, List<ChatMessage>, String>(
  (ref, chatRoomId) {
    final chatMessageRepository = ref.read(chatmessageRepositoryProvider);
    final box = ref.read((chatMessageLazyBoxProvider(chatRoomId)));
    ref.onDispose(() {
      log("chat message provider dispose roomNum: ${chatRoomId}");
    });
    return ChatMessagesNotifier(chatMessageRepository, box, chatRoomId);
  },
);

final chatmessageRepositoryProvider =
    Provider((ref) => ChatMessageRepositoryImp(ref.read(socketClientProvider)));
