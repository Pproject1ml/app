import 'package:chat_location/core/database/secure_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class SocketClient {
  final String baseUrl;
  final String endPoint;
  final String httpsBaseUrl;
  final bool isHttps = false;
  StompClient? stompClient;
  final Map<String, void Function({Map<String, String>? unsubscribeHeaders})>
      subscritions = {};

  SocketClient(this.baseUrl, this.endPoint, this.httpsBaseUrl);

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
    final uri = isHttps
        ? "wss://${httpsBaseUrl}${endPoint}"
        : "ws://${baseUrl}${endPoint}";

    stompClient = StompClient(
      config: StompConfig(
        url: uri,
        onConnect: onConnect,
        onStompError: onStompError,
        onWebSocketError: onWebSocketError,
        onDisconnect: onDisconnect,
        stompConnectHeaders: headers,
        webSocketConnectHeaders: headers,
        onDebugMessage: (p0) {},

        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
        reconnectDelay: const Duration(seconds: 30), // 재연결 간격
      ),
    );
    if (_isClientInitailized()) {
      stompClient!.activate();
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
      return;
    }
    final subScriber = stompClient!.subscribe(
        destination: destination, callback: onMessage, headers: headers);
    subscritions[destination] = subScriber;
  }

  void unsubscribeRoom(
      {required String destination, Map<String, String>? headers}) {
    if (!_isClientInitailized()) return;
    if (!stompClient!.connected) {
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
      return;
    }
    stompClient!.send(
      destination: destination,
      body: message,
    );
  }

  // WebSocket 연결 종료
  void disconnect() {
    if (!_isClientInitailized()) return;
    if (stompClient!.connected) {
      stompClient!.deactivate();
    }
  }

  // 헤더 생성
  Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorageHelper.getAuthToken();

    return {
      'Authorization': token ?? '',
    };
  }
}
