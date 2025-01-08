import 'dart:developer';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/newtwork/socket_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

final socketClientProvider = Provider((ref) {
  final client = SocketClient(BASE_URL, "/ws");
  // 소켓 연결 행동
  client.connect(onConnect: (frame) {
    log('WebSocket Connected');
  });

  return client;
});

// 특정 행동을 노출하는 StateNotifierProvider
class SocketClientNotifier extends StateNotifier<SocketClient> {
  SocketClientNotifier() : super(SocketClient(BASE_URL, "/ws"));

  Future<void> connect() async {
    await state.connect(onConnect: (frame) {
      log('WebSocket connected');
    });
  }

  void subscribeChatRoom(
      String roomId, void Function(StompFrame frame) onMessage) {
    state.subscribeToRoom(roomId, onMessage);
  }

  void sendMessage(ChatMessage message) {
    state.sendMessage(message);
  }

  void enterChatRoom(String roomId) {
    state.enterRoom(roomId);
  }

  void leaveChatRoom(String roomId) {
    state.leaveRoom(roomId);
  }

  void joinChatRoom(String roomId) {
    state.joinRoom(roomId);
  }

  void dietChatRoom(String roomId) {
    state.dieRoom(roomId);
  }

  void disconnect() {
    state.disconnect();
  }
}

final socketNotifierProvider =
    StateNotifierProvider<SocketClientNotifier, SocketClient>((ref) {
  return SocketClientNotifier();
});
