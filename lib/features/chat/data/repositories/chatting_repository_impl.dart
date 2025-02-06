import 'dart:convert';
import 'dart:developer';

import 'package:chat_location/common/utils/index_util.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/core/newtwork/socket_client.dart';
import 'package:chat_location/features/chat/data/model/EnterLeave_message.dart';
import 'package:chat_location/features/chat/data/model/chat_message.dart';
import 'package:chat_location/features/chat/data/model/chatroom.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:chat_location/features/chat/domain/repositories/chatting_repository.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChattingRepositoryImp implements ChattingRepository {
  final SocketClient _socketClient;
  final ApiClient _apiClient;

  ChattingRepositoryImp(
    this._socketClient,
    this._apiClient,
  );
  LazyBox<ChatMessageHiveModel> _getHiveChatMessageBox(String boxKey) {
    if (!Hive.isBoxOpen(boxKey)) {
      throw Exception(
          'LazyBox "chatMessage is not open. Did you forget to open it?');
    }

    return Hive.lazyBox<ChatMessageHiveModel>(boxKey);
  }

  LazyBox<ChatRoomHiveModel> _getHiveChatRoomBox(String boxKey) {
    if (!Hive.isBoxOpen(boxKey)) {
      throw Exception(
          'LazyBox "chatRooms" is not open. Did you forget to open it?');
    }

    return Hive.lazyBox<ChatRoomHiveModel>(boxKey);
  }

// ----------------------------------------- socket ----------------------------------------------

  Future<void> connect({required void Function(StompFrame) onConnect}) async {
    await _socketClient.connect(
        onConnect: onConnect,
        onStompError: _onStompError,
        onDisconnect: _onDisconnect,
        onWebSocketError: _onWebSocketError);
  }

  void _onStompError(StompFrame frame) {}

  void _onDisconnect(StompFrame frame) {}

  void _onWebSocketError(dynamic error) {}

  @override
  Future updateChatRoom(String roomId, data) {
    // socket으로 구독을 한다.
    // 메세지가 올때마다 return 한다.

    throw UnimplementedError();
  }

  @override
  void subscribeChatRoom(
      {required String roomId,
      required void Function(StompFrame) onMessage,
      String? command,
      bool isPrivate = false,
      bool notSubsribeIfSubsbribed = false,
      Map<String, String>? headers}) {
    final destination =
        '$SUBSCRIBE_BASE_URL/${isPrivate ? 'private-room' : 'room'}/$roomId';
    final Map<String, String> _header = {};
    if (notSubsribeIfSubsbribed) {
      if (_socketClient.subscritions.containsKey(destination)) {
        return;
      }
    }

    if (command != null) _header.addAll({"COMMAND": command});
//     // headers가 존재할 경우 _header에 병합
    if (headers != null) {
      _header.addAll(headers);
    }
    _socketClient.subscribeToRoom(destination, onMessage, _header);
  }

  @override
  Future<void> unSubscribeChatRoom(
      {required String roomId,
      String? command,
      bool isPrivate = false,
      Map<String, String>? headers}) async {
    final destination =
        '$SUBSCRIBE_BASE_URL/${isPrivate ? 'private-room' : 'room'}/$roomId';
    final Map<String, String> _header = {"chatroomId": roomId};
    if (command != null) _header.addAll({"COMMAND": command});
    // headers가 존재할 경우 _header에 병합
    if (headers != null) {
      _header.addAll(headers);
    }
    _socketClient.unsubscribeRoom(destination: destination, headers: _header);
  }

  @override
  Future<void> disconnectSocket() async {
    _socketClient.disconnect();
  }

  @override
  Future<void> sendChatMessage(
      {required ChatMessageModel message, bool isPrivate = false}) async {
    final roomId = message.chatroomId;
    final destination =
        '$PUBLISH_BASE_URL/${isPrivate ? 'private-message' : 'message'}/$roomId';
    final json = jsonEncode(message.toJson());
    _socketClient.sendMessage(destination: destination, message: json);
  }

  @override
  Future<void> sendJoinMessage(
      {required String chatroomId, required String profileId}) async {
    final destination = '$PUBLISH_BASE_URL/join/$chatroomId';
    final json = jsonEncode({'chatroomId': chatroomId, 'profileId': profileId});
    _socketClient.sendMessage(destination: destination, message: json);
  }

  @override
  Future<void> sendDieMessage(
      {required String chatroomId, required String profileId}) async {
    final destination = '$PUBLISH_BASE_URL/die/$chatroomId';
    final json = jsonEncode({'chatroomId': chatroomId, 'profileId': profileId});
    _socketClient.sendMessage(destination: destination, message: json);
  }

  @override
  Future<void> sendEnterMessage(
      {required EnterLeaveModel data, bool isPrivate = false}) async {
    final roomId = data.chatroomId;
    final destination =
        '$PUBLISH_BASE_URL/${isPrivate ? 'private-enter' : 'enter'}/$roomId';
    final json = jsonEncode(data.toJson());
    _socketClient.sendMessage(destination: destination, message: json);
  }

  @override
  void sendLeaveMessage(
      {required EnterLeaveModel data, bool isPrivate = false}) {
    final roomId = data.chatroomId;
    final destination =
        '$PUBLISH_BASE_URL/${isPrivate ? 'private-leave' : 'leave'}/$roomId';
    final json = jsonEncode(data.toJson());
    _socketClient.sendMessage(destination: destination, message: json);
  }

  @override
  Future<ChatMessageModel> updateChatMessage(ChatMessageModel message) {
    // socket으로 메시지 업데이트 하기
    throw UnimplementedError();
  }
// ------------------------------------------- http ----------------------------------------

  @override
  Future<ChatRoomModel> createPrivateChatroom(
      {required String profileId}) async {
    try {
      final data = {"profileId": profileId};
      final res =
          await _apiClient.post(endpoint: '/chat/private-chat', data: data);
      final json = res['data'];
      return ChatRoomModel.fromJson(json as Map<String, dynamic>);
    } catch (e, stack_trace) {
      throw "1:1 채팅 생성하기에 실패하였습니다";
    }
  }

  @override
  Future<List<ChatRoomModel>> getAllChatRoomsFromServer(
      {required String profileId}) async {
    // http 로 채팅방 정보를 가져옴
    try {
      final queryParameters = {"id": profileId};
      final res = await _apiClient.get(
          endpoint: '/chat/list', queryParameters: queryParameters);

      final datas = res['data'] as List<dynamic>;

      final chatRooms = datas.map((json) {
        return ChatRoomModel.fromJson(json as Map<String, dynamic>);
      }).toList();

      return chatRooms;
    } catch (e, stack_trace) {
      throw "서버에서 채팅방 가저오기 실패하였습니다";
    }
  }

  @override
  Future<List<ChatRoomModel>> getAllPrvateChatRoomsFromServer(
      {required String profileId}) async {
    // http 로 채팅방 정보를 가져옴
    try {
      final queryParameters = {"id": profileId};
      final res = await _apiClient.get(
          endpoint: '/chat/private-list', queryParameters: queryParameters);

      final datas = res['data'] as List<dynamic>;

      final chatRooms = datas.map((json) {
        return ChatRoomModel.fromJson(json as Map<String, dynamic>);
      }).toList();

      return chatRooms;
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw "서버에서 채팅방 가저오기 실패하였습니다";
    }
  }

  @override
  Future<List<ChatMessageModel>> getChatMessages(
      {String? startChatId,
      String? endChatId,
      required String chatroomId}) async {
    // http로 메시지 가져오기
    try {
      final queryParameters = {
        "chatroom": chatroomId,
        'start': startChatId,
        'end': endChatId
      };
      final res = await _apiClient.get(
          endpoint: '/chat/refresh', queryParameters: queryParameters);

      final datas = res['data'] as List<dynamic>;

      final chatMessages = datas.map((json) {
        return ChatMessageModel.fromJson(json as Map<String, dynamic>);
      }).toList();

      return chatMessages;
    } catch (e, stack_trace) {
      throw "서버에서 채팅 가저오기 실패하였습니다";
    }
  }

  @override
  Future<List<ChatMessageModel>> getPrivateChatMessages(
      {String? startChatId,
      String? endChatId,
      required String chatroomId}) async {
    // http로 메시지 가져오기
    try {
      final queryParameters = {
        "chatroom": chatroomId,
        'start': startChatId,
        'end': endChatId
      };
      final res = await _apiClient.get(
          endpoint: '/private-chat/refresh', queryParameters: queryParameters);

      final datas = res['data'] as List<dynamic>;

      final chatMessages = datas.map((json) {
        return ChatMessageModel.fromJson(json as Map<String, dynamic>);
      }).toList();

      return chatMessages;
    } catch (e, stack_trace) {
      throw "서버에서 채팅 가저오기 실패하였습니다";
    }
  }

  @override
  Future<void> isJoinChatRoomAvailable(
      String chatroomId, String profileId) async {
    try {
      final body = {"chatroomId": chatroomId, "profileId": profileId};
      final res = await _apiClient.post(endpoint: '/chat/join', data: body);
    } catch (e, s) {
      throw "채팅방에 참여할 수 없습니다.";
    }
  }

  @override
  Future<void> setChatroomAlarm(
      String chatroomId, String profileId, bool alarm) async {
    try {
      final body = {
        "chatroomId": chatroomId,
        "profileId": profileId,
        "alarm": alarm
      };
      final res = await _apiClient.post(endpoint: '/chat/alarm', data: body);
    } catch (e, s) {}
  }
  //  -------------------------------------------- LOCAL -----------------------------------------

  @override
  Future<void> updateAlarmLocal(String chatroomId, bool alarm) async {
    try {
      const boxKey = HIVE_CHATROOM;
      final box = _getHiveChatRoomBox(boxKey);
      ChatRoomHiveModel? _prevState = await box.get(chatroomId);
      if (_prevState != null) {
        _prevState.copyWith(alarm: alarm);
        await box.put(chatroomId, _prevState);
      }
    } catch (e, s) {}
  }

  @override
  Future<void> saveMessageLocal(ChatMessageHiveModel data) async {
    try {
      final boxKey = HIVE_CHAT_MESSAGE + "${data.chatRoomId}";
      final box = _getHiveChatMessageBox(boxKey);
      await box.put(data.messageId, data);
    } catch (e, s) {}
  }

  @override
  Future<void> saveMessagesLocal(
      Map<String, ChatMessageHiveModel> data, String chatroomId) async {
    try {
      final boxKey = HIVE_CHAT_MESSAGE + "${chatroomId}";
      final box = _getHiveChatMessageBox(boxKey);
      await box.putAll(data);
    } catch (e, s) {}
  }

  @override
  Future<void> saveChatroomLocal(ChatRoomHiveModel data) async {
    try {
      final boxKey = HIVE_CHATROOM;
      final box = _getHiveChatRoomBox(boxKey);
      await box.put(data.chatroomId, data);
    } catch (e, s) {}
  }

  @override
  Future<void> deleteChatroomLocal(String chatroomId) async {
    try {
      final boxKey = HIVE_CHATROOM;
      final box = _getHiveChatRoomBox(boxKey);

      await box.delete(chatroomId);
    } catch (e, s) {}
  }

  @override
  Future<void> updateChatroomLocal(ChatRoomHiveModel data) async {
    try {
      final boxKey = HIVE_CHATROOM;
      final box = _getHiveChatRoomBox(boxKey);
      final chatroomKey = data.chatroomId;
      await box.put(chatroomKey, data);
    } catch (e, s) {
      throw '채팅방 업데이트에 실패하였습니다';
    }
  }

  @override
  Future<void> deleteMessageLocal(String chatroomId) async {
    try {
      final boxKey = HIVE_CHAT_MESSAGE + "${chatroomId}";
      final box = _getHiveChatMessageBox(boxKey);
      await box.deleteFromDisk();
    } catch (e, s) {}
  }

  @override
  Future<List<int>> getMessageKeysLocal(String chatroomId) async {
    try {
      final boxKey = HIVE_CHAT_MESSAGE + "${chatroomId}";
      final box = _getHiveChatMessageBox(boxKey);
      final keys = box.keys.map((key) => int.parse(key)).toList();
      keys.sort();
      return keys;
    } catch (e, s) {
      throw [];
    }
  }

  Future<void> createChatRoomLocal(ChatRoomHiveModel chatRoom) async {
    try {
      final boxKey = HIVE_CHATROOM;
      final box = _getHiveChatRoomBox(boxKey);
      await box.put(chatRoom.chatroomId, chatRoom);
    } catch (e, s) {
      throw '채팅방 추가에 실패하였습니다.';
    }
  }

// 이거는 예외적으로 interface를 return 하게 하였습니다. -> list 두번 돌리는건 비효율적인거 같아요.
// reverse 해서 줍니다.
  @override
  Future<List<ChatMessageInterface>> getMessageLocal(
      {required List<int> candidateKeys,
      String? lastMessageId,
      required String chatroomId}) async {
    const limit = 50;
    // candidateKeys 중에서 현재 index를 넘겨줍니다.
    int _getIndexOfCurrentMessage(String? messageId) {
      if (messageId == null) return -1;
      return candidateKeys.indexWhere((v) => v == int.parse(messageId));
    }

    final boxKey = HIVE_CHAT_MESSAGE + "${chatroomId}";
    final box = _getHiveChatMessageBox(boxKey);
    List<ChatMessageInterface> localMessages = [];
    // canidateKeys는 오름차순으로 구성되어있다.

    if (candidateKeys.length <= 0) return [];
    // local data가 있는 경우

    final lastMessageIndex = _getIndexOfCurrentMessage(lastMessageId);

    final _keys = getPrevItems(
        candidateKeys,
        lastMessageIndex <= -1 ? candidateKeys.length - 1 : lastMessageIndex,
        limit);

    for (var i = _keys.length - 1; i >= 0; i--) {
      final _message = await box.get(_keys[i].toString());
      if (_message != null) {
        localMessages.add(ChatMessageInterface.fromHiveModel(_message));
      }
    }

    return localMessages;
  }
}
