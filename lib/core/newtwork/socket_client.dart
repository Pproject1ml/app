import 'dart:developer';

import 'package:chat_location/core/database/secure_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class SocketClient {
  final String baseUrl;
  final String endPoint;
  StompClient? stompClient;
  final Map<String, void Function({Map<String, String>? unsubscribeHeaders})>
      subscritions = {};

  SocketClient(this.baseUrl, this.endPoint);

  // WebSocket 연결 초기화
  Future<void> connect(
      {required void Function(StompFrame frame) onConnect,
      required void Function(StompFrame) onStompError,
      required void Function(dynamic) onWebSocketError,
      required void Function(StompFrame) onDisconnect}) async {
    if (stompClient != null && stompClient!.isActive) {
      return;
    }
    final headers = await _getHeaders();
    final uri = "http://${baseUrl}${endPoint}";

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: uri,
        onConnect: onConnect,
        onStompError: onStompError,
        onWebSocketError: onWebSocketError,
        onDisconnect: onDisconnect,
        stompConnectHeaders: headers,
        webSocketConnectHeaders: headers,
        onDebugMessage: (p0) {
          log("socket dubg: ${p0}");
        },

        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
        reconnectDelay: const Duration(seconds: 30), // 재연결 간격
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
  void subscribeToRoom(String destination,
      void Function(StompFrame frame) onMessage, Map<String, String>? headers) {
    if (!_isClientInitailized()) return;

    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot subscribe.');
      return;
    }
    final subScriber = stompClient!.subscribe(
        destination: destination, callback: onMessage, headers: headers);
    subscritions[destination] = subScriber;
    log('Subscribed to: $destination');
  }

  void unsubscribeRoom(
      {required String destination, Map<String, String>? headers}) {
    if (!_isClientInitailized()) return;
    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot unsubscribe.');
      return;
    }

    final void Function({Map<String, String>? unsubscribeHeaders}) fun =
        subscritions[destination]!;

    fun(unsubscribeHeaders: headers);
    subscritions.remove(destination);
  }

  // 발행 메서드 (pub/message/{roomId})
  void sendMessage({required String destination, required String message}) {
    if (!_isClientInitailized()) return;
    if (!stompClient!.connected) {
      log('WebSocket not connected. Cannot send message.');
      return;
    }
    stompClient!.send(
      destination: destination,
      body: message,
    );
    log('Message sent to $destination: $message');
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
