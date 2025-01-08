import 'dart:convert';
import 'dart:developer';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/secure_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class SocketClient {
  final String baseUrl;
  final String endPoint;
  StompClient? stompClient;

  SocketClient(this.baseUrl, this.endPoint);

  // WebSocket 연결 초기화
  Future<void> connect(
      {required void Function(StompFrame frame) onConnect}) async {
    if (stompClient != null && stompClient!.isActive) {
      return;
    }
    final headers = await _getHeaders();
    final uri = "http://${baseUrl}${endPoint}";

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: uri,
        onConnect: onConnect,
        onStompError: (frame) {
          log('STOMP Error: ${frame.body}');
        },
        onWebSocketError: (error) {
          log('WebSocket Error: $error');
        },
        onDisconnect: (frame) {
          log('Disconnected from WebSocket');
        },
        stompConnectHeaders: headers,
        webSocketConnectHeaders: headers,
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
        reconnectDelay: const Duration(seconds: 5), // 재연결 간격
      ),
    );
    if (_isClientInitailized()) {
      stompClient!.activate();
      log('Connecting to WebSocket...');
    }
  }

  bool _isClientInitailized() {
    return (stompClient != null);
  }

  // 구독 메서드 (room/{roomId})
  void subscribeToRoom(
      String roomId, void Function(StompFrame frame) onMessage) {
    if (!_isClientInitailized()) return;
    final destination = '$SUBSCRIBE_BASE_URL/room/$roomId';
    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot subscribe.');
      return;
    }
    stompClient!.subscribe(
      destination: destination,
      callback: onMessage,
    );
    log('Subscribed to: $destination');
  }

  // 발행 메서드 (pub/message/{roomId})
  void sendMessage(ChatMessage message) {
    if (!_isClientInitailized()) return;
    final roomId = message.chatRoomId;
    final destination = '$PUBLISH_BASE_URL/message/$roomId';
    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot send message.');
      return;
    }
    stompClient!.send(
      destination: destination,
      body: jsonEncode(message),
    );
    log('Message sent to $destination: $message');
  }

  // 입장 발행 메서드 (pub/enter/{roomId})
  void enterRoom(String roomId) {
    if (!_isClientInitailized()) return;
    final destination = '$PUBLISH_BASE_URL/enter/$roomId';
    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot send enter message.');
      return;
    }
    stompClient!.send(destination: destination, body: jsonEncode({}));
    log('Entered room: $roomId');
  }

  // 퇴장 발행 메서드 (pub/leave/{roomId})
  void leaveRoom(String roomId) {
    if (!_isClientInitailized()) return;
    final destination = '$PUBLISH_BASE_URL/leave/$roomId';
    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot send leave message.');
      return;
    }
    stompClient!.send(destination: destination, body: jsonEncode({}));
    log('Left room: $roomId');
  }

  // 가입 발행 메서드 (pub/join/{roomId})
  void joinRoom(String roomId) {
    if (!_isClientInitailized()) return;
    final destination = '$PUBLISH_BASE_URL/join/$roomId';
    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot send leave message.');
      return;
    }
    stompClient!.send(destination: destination, body: jsonEncode({}));
    log('Left room: $roomId');
  }

  // 탈퇴 발행 메서드 (pub/die/{roomId})
  void dieRoom(String roomId) {
    if (!_isClientInitailized()) return;
    final destination = '$PUBLISH_BASE_URL/die/$roomId';
    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot send leave message.');
      return;
    }
    stompClient!.send(destination: destination, body: jsonEncode({}));
    log('Left room: $roomId');
  }

  // WebSocket 연결 종료
  void disconnect() {
    if (!_isClientInitailized()) return;
    if (stompClient!.connected) {
      stompClient!.deactivate();
      log('Disconnected from WebSocket');
    }
  }

  // 헤더 생성
  Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorageHelper.getAuthToken();
    log("header token: ${token}");
    return {
      'Authorization': token ?? '',
    };
  }
}
