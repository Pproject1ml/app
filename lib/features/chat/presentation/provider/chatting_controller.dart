// Chat Rooms Notifier
import 'dart:convert';
import 'dart:developer';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/controller/isolate_controller.dart';
import 'package:chat_location/controller/location_controller.dart';
import 'package:chat_location/controller/notification_controller.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/core/newtwork/socket_client.dart';
import 'package:chat_location/features/chat/data/model/chat_message.dart';
import 'package:chat_location/features/chat/data/model/chatroom.dart';
import 'package:chat_location/features/chat/data/repositories/chat_message_repository_imp.dart';
import 'package:chat_location/features/chat/data/repositories/chat_room_repository_impl.dart';
import 'package:chat_location/features/chat/data/repositories/chatting_repository_impl.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';

import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChattingController
    extends StateNotifier<AsyncValue<List<ChatRoomInterface>>> {
  final LazyBox<ChatRoomHiveModel> _chatRoomBox;
  final ChattingRepositoryImp chattingRepository;
  final ProfileInterface userInfo;
  final void Function({
    required String body,
    required int id,
    required String title,
  }) notificationAction;
  ChattingController(this._chatRoomBox, this.chattingRepository, this.userInfo,
      this.notificationAction)
      : super(const AsyncValue.loading()) {
    _socketConnect();
    log("provider initialize");
  }
  // --------------chatting  actions ------------------
  Future<void> joinAction(ChatRoomInterface chatroom) async {
    try {
      await chattingRepository.isJoinChatRoomAvailable(
          chatroom.chatroomId, userInfo.profileId);
      final chatroomId = chatroom.chatroomId;
      log("joinAction : ${chatroom.toString()}");
      // 1. Local db에 채팅방을 추가한다.
      await chattingRepository.addChatRoomLocal(chatroom.toHiveModel());

      // 2. Local db에 채팅을 추가한다. (Open box)
      await _openChattingMessageBox(chatroomId);

      // 3. state에 채팅방을 추가한다.
      _addChatRoom(chatroom);

      // 4. socket에 구독 요청을 보낸다.
      final joinHeader = {"profileId": userInfo.profileId};
      chattingRepository.subscribeChatRoom(
          roomId: chatroomId,
          onMessage: onMessageHandler,
          command: "JOIN",
          headers: joinHeader);
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw "채팅방에 입장할 수 없습니다.";
    }
  }

  Future<void> dieAction(String chatroomId) async {
    try {
      log("die action");
      // 1. Socket 구독 취소를 한다.( unsubscribe/die)
      _unsubscribe(chatroomId);

      //2. staet에서 삭제한다.
      _removeChatRoom(chatroomId);

      //3. Local db에 채팅방을 뺀다.
      chattingRepository.deleteChatroomLocal(chatroomId);

      //4. Local db에 채팅을 삭제한다. ( delete)
      chattingRepository.deleteMessageLocal(chatroomId);
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  Future<void> updateChatRoomAvilable(
      ChatRoomInterface chatroom, bool available) async {
    try {
      if (available) {
        _abledAction(chatroom);
      } else {
        _disabledAction(chatroom);
      }
    } catch (e) {
      log(e.toString());
      throw '채팅방 업데이트에 실패했습니다.';
    }
  }

  Future<void> _disabledAction(ChatRoomInterface chatroom) async {
    try {
      final chatroomId = chatroom.chatroomId;

      //1. Socket 구독 취소한다.(unsubscribe/disabled)
      _unsubscribe(chatroomId);

      //2. State에서 room active를 false로 한다.
      await _updateChatRoomDisable(chatroomId);
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  Future<void> _abledAction(ChatRoomInterface chatroom) async {
    final chatroomId = chatroom.chatroomId;

    //1. socket에 구독 요청을 한다.
    chattingRepository.subscribeChatRoom(
        roomId: chatroomId,
        onMessage: onMessageHandler,
        notSubsribeIfSubsbribed: true);

    //2. state에서 room을 active로 바꾼다
    _updateChatRoomAble(chatroomId);
  }

  Future<void> initAction() async {
    log("init action start");
    try {
      final hiveChatroomKeys = _chatRoomBox.keys.toList();
      log("hiveChatroomKeys: ${hiveChatroomKeys}");
      List<ChatRoomInterface> chatrooms = [];

      // 1. 서버에서 채팅방을 가져온다.(http)
      final List<ChatRoomInterface> _fetchedRooms = await _fetchChatRoomList();

      // 2. server data를 기준으로 Local db와 서버 데이터를 비교한다.
      final _fetchedChatroomIdsSet =
          _fetchedRooms.map((room) => room.chatroomId).toSet();
      final _hiveChatroomIdsSet =
          hiveChatroomKeys.map((key) => key.toString()).toSet();

      // 정상 id
      final normalIds =
          _hiveChatroomIdsSet.intersection(_fetchedChatroomIdsSet);
      final normalRooms = _fetchedRooms
          .where((room) => normalIds.contains(room.chatroomId))
          .toList();

      for (final _room in normalRooms) {
        final chatroomId = _room.chatroomId;

        // 해당 채팅방이 Active 이라면
        if (_room.available) {
          // 채팅 box가 안켜져 있다면 키도록
          await _openChattingMessageBox(chatroomId);

          // 채팅방 구독하기
          chattingRepository.subscribeChatRoom(
              roomId: chatroomId,
              onMessage: onMessageHandler,
              notSubsribeIfSubsbribed: true);
          // 해당 채팅방의 기존 채팅 keys 가져오기
          final _hiveChattingkeys =
              await chattingRepository.getMessageKeysLocal(chatroomId);

          // obj 업데이트
          final _roomData = _room.copyWith(hiveKeys: _hiveChattingkeys);

          // 임시 stateList에 추가
          chatrooms.add(_roomData);
        } else
        // disabled 이라면
        {
          // 구독하지 않고 state에 추가한다(disabled 보여주기 위함)
          chatrooms.add(_room);
        }
      }

      // 추가해야하는 id
      final needtoAddIds =
          _fetchedChatroomIdsSet.difference(_hiveChatroomIdsSet);
      final needtoAddRooms = _fetchedRooms
          .where((room) => needtoAddIds.contains(room.chatroomId))
          .toList();

      for (final _room in needtoAddRooms) {
        final chatroomId = _room.chatroomId;

        // able인 경우
        if (_room.available) {
          // 채팅방을 local에 추가
          await chattingRepository.addChatRoomLocal(_room.toHiveModel());

          // 채팅 box가 안켜져 있다면 키도록
          await _openChattingMessageBox(chatroomId);

          // 채팅방 구독하기
          chattingRepository.subscribeChatRoom(
              roomId: chatroomId,
              onMessage: onMessageHandler,
              notSubsribeIfSubsbribed: true);

          // 임시 List에 추가
          chatrooms.add(_room);
          chattingRepository.addChatRoomLocal(_room.toHiveModel());
        }
        //disabled인 경우
        else {
          chatrooms.add(_room);
        }
      }

      // 삭제해야하는 id
      final needtoDeleteIds =
          _hiveChatroomIdsSet.difference(_fetchedChatroomIdsSet);
      final needtoDeleteRooms = _fetchedRooms
          .where((room) => needtoDeleteIds.contains(room.chatroomId))
          .toList();

      for (final _room in needtoDeleteRooms) {
        final chatroomId = _room.chatroomId;
        // local db에서 채팅방 삭제
        chattingRepository.deleteChatroomLocal(chatroomId);
        // local db에서 채팅 삭제
        chattingRepository.deleteMessageLocal(chatroomId);
      }

      // 상태를 업데이트 한다.

      state = AsyncData(chatrooms);
      log("init action finish");
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  Future<void> refreshAction() async {
    try {
      // 0. 메모리에서 채팅방을 가져온다.(state)
      final List<ChatRoomInterface> currentState =
          state.maybeWhen(data: (v) => v, orElse: () => throw "state 문제");
      List<ChatRoomInterface> chatrooms = [];

      // 1. 서버에서 채팅방을 가져온다.(http)
      final List<ChatRoomInterface> _fetchedRooms = await _fetchChatRoomList();

      // 2. server data를 기준으로 메모리에서와 서버 데이터를 비교한다.
      final _fetchedChatroomIdsSet =
          _fetchedRooms.map((room) => room.chatroomId).toSet();
      final _currentStateIdsSet =
          currentState.map((room) => room.chatroomId).toSet();

      final normalIds =
          _currentStateIdsSet.intersection(_fetchedChatroomIdsSet);
      final normalRooms = currentState
          .where((room) => normalIds.contains(room.chatroomId))
          .toList();

      chatrooms.addAll(normalRooms);

      final needtoAddIds =
          _fetchedChatroomIdsSet.difference(_currentStateIdsSet);
      final needtoAddRooms = _fetchedRooms
          .where((room) => needtoAddIds.contains(room.chatroomId))
          .toList();

      for (final _room in needtoAddRooms) {
        final chatroomId = _room.chatroomId;

        // able인 경우
        if (_room.available) {
          // 채팅방을 local에 추가
          await chattingRepository.addChatRoomLocal(_room.toHiveModel());

          // 채팅 box가 안켜져 있다면 키도록
          await _openChattingMessageBox(chatroomId);

          // 채팅방 구독하기
          chattingRepository.subscribeChatRoom(
              roomId: chatroomId,
              onMessage: onMessageHandler,
              notSubsribeIfSubsbribed: true);

          // 임시 List에 추가
          chatrooms.add(_room);
        }
        //disabled인 경우
        else {
          chatrooms.add(_room);
        }
      }

      // 삭제해야하는 room
      final needtoDeleteIds =
          _currentStateIdsSet.difference(_fetchedChatroomIdsSet);
      final needtoDeleteRooms = currentState
          .where((room) => needtoDeleteIds.contains(room.chatroomId))
          .toList();

      for (final _room in needtoDeleteRooms) {
        final chatroomId = _room.chatroomId;
        // local db에서 채팅방 삭제
        chattingRepository.deleteChatroomLocal(chatroomId);
        // local db에서 채팅 삭제
        chattingRepository.deleteMessageLocal(chatroomId);
      }

      // 상태를 업데이트 한다.

      state = AsyncData(chatrooms);
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  Future<void> enterAction(String chatroomId) async {
    try {
      ChatRoomInterface _roomInfo = state.maybeWhen(
          data: (v) => v.firstWhere((room) => room.chatroomId == chatroomId),
          orElse: () => throw "state 문제");

      // 2. 해당 오브젝트에서 hive_keys 를 통해 이전 채팅 데이터 키를 가져온다.  key의 마지막과 chatting state의 첫번째를 비교해서 chating state 의 id가 더 크다면 안불러와도됩니다.
      final bool needToFetchLocal = _roomInfo.hiveKeys.isEmpty
          ? false
          : _roomInfo.chatting.isEmpty
              ? true
              : _roomInfo.hiveKeys[_roomInfo.hiveKeys.length - 1] >
                  int.parse(_roomInfo.chatting[0].messageId!);

      final _localChatKeys = _roomInfo.hiveKeys;

      final String? _lastMessageId = _roomInfo.chatting.isNotEmpty
          ? _roomInfo.chatting[0].messageId
          : null;

      List<ChatMessageInterface> localMessages = [];

      // local db에서 채팅을 불러와야 할 경우 채팅을 불러온다.
      if (needToFetchLocal) {
        localMessages = await chattingRepository.getMessageLocal(
            candidateKeys: _localChatKeys,
            lastMessageId: _lastMessageId,
            chatroomId: chatroomId);
      }

      // http로 요청 보내서 사이 데이터 받아오기
      final serverData = await chattingRepository.getChatMessages(
          chatroomId: chatroomId,
          startChatId: localMessages.isNotEmpty
              ? localMessages[localMessages.length - 1].messageId
              : null,
          endChatId: _roomInfo.chatting.isNotEmpty
              ? _roomInfo.chatting[0].messageId
              : null);

      // server data convert
      final serverMessages = serverData
          .map(
            (e) => ChatMessageInterface.fromChatMessageModel(e),
          )
          .toList();

      // 상태 업데이트 하기 (서버데이터, local 데이터) -> [key 내림차순 정렬]
      final List<ChatMessageInterface> _updatedChatMessages = [
        ...serverMessages.reversed.toList(),
        ...localMessages.reversed.toList()
      ];

      // room 채팅 정보 변경
      _roomInfo = _roomInfo
          .copyWith(chatting: [..._roomInfo.chatting, ..._updatedChatMessages]);
      state = AsyncData(state
          .maybeWhen(data: (v) => v, orElse: () => throw "state 문제")
          .map((v) => v.chatroomId == _roomInfo.chatroomId ? _roomInfo : v)
          .toList());

      // http 응답 데이터 local 저장하기
      final Map<String, ChatMessageHiveModel> _hiveData = {
        for (int i = 0; i < serverData.length; i++)
          serverData[i].messageId!: serverData[i].toHiveMessage()
      };
      // 비동기로 처리하기
      chattingRepository.saveMessagesLocal(_hiveData, chatroomId);
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  Future<void> sendMessageAction(
      String message, String userId, String chatroomId) async {
    // socket에 message 보내기
    try {
      final ChatMessageInterface _message = ChatMessageInterface(
          chatroomId: chatroomId,
          profileId: userId,
          content: message,
          messageType: "TEXT");
      await chattingRepository.sendChatMessage(_message.toChatMessageModel());
    } catch (e) {
      log(e.toString());
      throw "메시지 전송에 실패하였습니다.";
    }
  }

  // --------------socket actions ------------------------
  Future<void> _socketConnect() async {
    await chattingRepository.connect(onConnect: (cli) async {
      log("socket connectd");

      await initAction();
    });
  }

  void _unsubscribe(String roomId) async {
    chattingRepository.unSubscribeChatRoom(roomId: roomId);
  }

// -------------- onMessage actions -------------------
  // command에 따라서 메세지 처리를 해줍니다.
  Future<void> onMessageHandler(StompFrame onMessage) async {
    switch (onMessage.command) {
      case "MESSAGE":
        _SocketMessageHandler(onMessage);
        break;
      case "SUBSCRIBE":
        break;
      case "UNSUBSCRIBE":
        break;
      case "CONNECT":
        break;
    }
  }

  // stomp command 가 MESSAGE 일때의 handler
  Future<void> _SocketMessageHandler(StompFrame stompMessage) async {
    final stompBody = jsonDecode(stompMessage.body!);
    log("_onSocketSendReceive: ${stompBody}");
    final _message = stompBody['data'];

    switch (_message['messageType']) {
      case "TEXT":
        _onReceiveText(_message);
        break;
      case "ENTER":
        _onReceiveENTER(_message);
        break;
      case "LEAVE":
        _onReceiveLEAVE(_message);
        break;
      case "JOIN":
        _onReceiveJOIN(_message);
        break;
      case "DIE":
        _onReceiveDIE(_message);
        break;
      case "DATE":
        _onReceiveDATE(_message);
        break;
    }
  }

  void _onReceiveText(dynamic data) {
    try {
      // TODO: 1. 해당방을 업데이트 해주자.  2. 채팅 업데이트 해주자. 3. local에 저장하자.

      final _chatroomId = data!['chatroomId'];

      final _content = data!['content'];

      final _lastMessageAt = DateTime.parse(data['createdAt'] as String);

      // 해당 채팅방을 가져옵니다.

      // model convert
      final ChatMessageModel res = ChatMessageModel.fromJson(data);

      // model convert
      final ChatMessageInterface message =
          ChatMessageInterface.fromChatMessageModel(res);

      // ㅡchatroom temp model
      ChatRoomInterface _currentRoom = state.maybeWhen(
          data: (v) => v.firstWhere((room) => room.chatroomId == _chatroomId),
          orElse: () => throw "state 문제");

      // -chatting list temp update
      List<ChatMessageInterface> _chatting = _currentRoom.chatting;
      _chatting = [
        message,
        ..._chatting,
      ];

      _currentRoom = _currentRoom.copyWith(
          lastMessage: _content,
          lastMessageAt: _lastMessageAt,
          chatting: _chatting);

      List<ChatRoomInterface> filteredList = state
          .maybeWhen(data: (v) => v, orElse: () => throw "state 문제")
          .where((room) => room.chatroomId != _currentRoom.chatroomId)
          .toList();

      // 상태 변경해주기
      state = AsyncValue.data([_currentRoom, ...filteredList]);

      // notification 주기
      _showNotification(res);

      // local에 메시지 저장하기
      _saveMessageLocal(res);

      //local에 채팅방 저장하기
      _saveChatRoomLocal(_currentRoom.toChatRoomModel());
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  void _showNotification(ChatMessageModel message) {
    final isFromOtherUser = userInfo.profileId != message.profileId;
    final isTextMessage = message.messageType == "TEXT";
    if (isFromOtherUser && isTextMessage) {
      notificationAction(
          id: int.parse(message.messageId!),
          body: message.content,
          title: message.chatroomId);
    }
  }

  void _onReceiveDATE(dynamic data) {
    try {
      // TODO: 1. 해당방을 업데이트 해주자.  2. 채팅 업데이트 해주자. 3. local에 저장하자.

      final _chatroomId = data!['chatroomId'];

      final _content = data!['content'];

      final _lastMessageAt = DateTime.parse(data['createdAt'] as String);

      // model convert
      final ChatMessageModel res = ChatMessageModel.fromJson(data);

      // ㅡmodel convert
      final ChatMessageInterface message =
          ChatMessageInterface.fromChatMessageModel(res);

      // ㅡchatroom temp model
      ChatRoomInterface _currentRoom = state.maybeWhen(
          data: (v) => v.firstWhere((room) => room.chatroomId == _chatroomId),
          orElse: () => throw "state 문제");

      // -chatting list temp update
      List<ChatMessageInterface> _chatting = _currentRoom.chatting;
      _chatting = [
        message,
        ..._chatting,
      ];
      _currentRoom = _currentRoom.copyWith(
          lastMessage: _content,
          lastMessageAt: _lastMessageAt,
          chatting: _chatting);

      List<ChatRoomInterface> filteredList = state
          .maybeWhen(data: (v) => v, orElse: () => throw "state 문제")
          .where((room) => room.chatroomId != _currentRoom.chatroomId)
          .toList();

      // 상태 변경해주기
      state = AsyncValue.data([_currentRoom, ...filteredList]);
      // notification 주기

      // local에 저장하기
      _saveMessageLocal(res);

      _saveChatRoomLocal(_currentRoom.toChatRoomModel());
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  void _onReceiveJOIN(dynamic _message) {
    log(_message);
    // profiles 업데이트 하기
  }

  void _onReceiveDIE(dynamic _message) {
    // profiles 업데이트 하기
  }
  void _onReceiveLEAVE(dynamic _message) {
    // profiles 업데이트 하기
  }
  void _onReceiveENTER(dynamic _message) {
    // profiles 업데이트 하기
  }

  // --------------------------------------------------

  int? getChatRoomIndex(String id) {
    final roomIndex = state
        .maybeWhen(data: (v) => v, orElse: () => throw 'state 문제')
        .indexWhere((ele) => ele.chatroomId == id);
    if (roomIndex == -1) return null;
    return roomIndex;
  }

  // message local db 열기
  Future<void> _openChattingMessageBox(String chatRoomId) async {
    final boxName = HIVE_CHAT_MESSAGE + "${chatRoomId}";
    log("message box name : ${boxName}");
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openLazyBox<ChatMessageHiveModel>(boxName);
        log("message box opened:${boxName}");
      }
    } catch (e) {
      log("채팅 박스 열기 실패");
      throw '핸드폰에 저장된 채팅정보를 불러오는데 실패하였습니다.';
    }
  }

  // chat room list 가져오기
  Future<List<ChatRoomInterface>> _fetchChatRoomList() async {
    try {
      // 서버에서 모든 room 정보를 가져옵니다.
      final res = await chattingRepository
          .getAllChatRoomsFromServer(profileId: userInfo.profileId)
          .then((v) {
        return v.map((v2) => ChatRoomInterface.fromChatRoomModel(v2)).toList();
      });

      return res;
    } catch (e, s) {
      state = AsyncValue.error('채팅방 정보를 가져오는데 실패하였습니다.', s);
      throw '채팅방 정보를 가져오는데 실패하였습니다.';
    }
  }

  // ---------------- state action ------------------------

  // 채팅방 추가하기
  Future<void> _addChatRoom(ChatRoomInterface chatRoom) async {
    try {
      // 상태 변경
      final prevdata =
          state.maybeWhen(data: (v) => v, orElse: () => throw "state 문제");
      state = AsyncData([chatRoom, ...prevdata]);
    } catch (e) {
      log(e.toString());
      throw "채팅방 추가하기에 실패하였습니다.";
    }
  }

  // 채팅방 삭제
  Future<void> _removeChatRoom(String chatRoomId) async {
    try {
      // state 변경
      final updateddata = state
          .maybeWhen(data: (v) => v, orElse: () => throw 'state error')
          .where((room) => room.chatroomId != chatRoomId)
          .toList();

      state = AsyncData(updateddata);
    } catch (e) {
      log(e.toString());
      throw "채팅방 삭제에 실패하였습니다.";
    }
  }

  Future<void> _updateChatRoomDisable(String chatroomId) async {
    try {
      final prevState =
          state.maybeWhen(data: (v) => v, orElse: () => throw 'state error');
      state = AsyncData([
        for (final room in prevState)
          if (room.chatroomId == chatroomId)
            room.copyWith(available: false)
          else
            room
      ]);
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  Future<void> _updateChatRoomAble(String chatroomId) async {
    try {
      final prevState =
          state.maybeWhen(data: (v) => v, orElse: () => throw 'state error');
      state = AsyncData([
        for (final room in prevState)
          if (room.chatroomId == chatroomId)
            room.copyWith(available: true)
          else
            room
      ]);
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  // 프로필 정보 추가 (JOIN)시 활용
  void addProfile(String roomId, ProfileInterface profile) {
    // 현재 데이터 저장 index 찾기
    final roomIndex = state
        .maybeWhen(data: (v) => v, orElse: () => throw 'state error')
        .indexWhere((ele) => ele.chatroomId == roomId);
    if (roomIndex == -1) return;
    // chatRoomInterface
    ChatRoomInterface _tmpData = state.maybeWhen(
        data: (v) => v[roomIndex], orElse: () => throw 'state error');
    // profiles
    final _profiles = _tmpData.profiles;
    // profiles에 추가
    _profiles.addAll({profile.profileId: profile});
    _tmpData = _tmpData.copyWith(profiles: _profiles);
    // state 변경
    // state = [_tmpData, ...state.sublist(roomIndex)];
  }

  // 프로필 정보 추가 (DIE)시 활용
  void deleteProfile(String roomId, ProfileInterface profile) {
    // // 현재 데이터 저장 index 찾기
    // final roomIndex = state.indexWhere((ele) => ele.chatroomId == roomId);
    // if (roomIndex == -1) return;
    // // chatRoomInterface
    // ChatRoomInterface _tmpData = state[roomIndex];
    // // profiles
    // final _profiles = _tmpData.profiles;
    // // profiles에 삭제
    // _profiles.removeWhere((k, v) => k == profile.profileId);
    // _tmpData = _tmpData.copyWith(profiles: _profiles);
    // // state 변경
    // state = [_tmpData, ...state.sublist(roomIndex)];
  }

  Future<void> _saveMessageLocal(ChatMessageModel message) async {
    try {
      final ChatMessageHiveModel _message = message.toHiveMessage();

      await chattingRepository.saveMessageLocal(_message);
    } catch (e, s) {
      log("save messag error");
      log("${e.toString()}, ${s.toString()}");
    }
  }

  Future<void> _saveChatRoomLocal(ChatRoomModel chatroom) async {
    try {
      final ChatRoomHiveModel _room = chatroom.toHiveModel();

      await chattingRepository.saveChatroomLocal(_room);
    } catch (e, s) {
      log("save chatroom error");
      log("${e.toString()}, ${s.toString()}");
    }
  }

  AsyncValue<List<ChatRoomInterface>> get() => state;
}

// Hive LazyBox Provider
final chatRoomLazyBoxProvider = Provider<LazyBox<ChatRoomHiveModel>>((ref) {
  // LazyBox 열기
  if (!Hive.isBoxOpen(HIVE_CHATROOM)) {
    throw Exception(
        'LazyBox "chatRooms" is not open. Did you forget to open it?');
  }
  return Hive.lazyBox<ChatRoomHiveModel>(HIVE_CHATROOM);
});

// ChatRoomController Provider
final chattingControllerProvider = StateNotifierProvider<ChattingController,
    AsyncValue<List<ChatRoomInterface>>>((ref) {
  final box = ref.read(chatRoomLazyBoxProvider);
  final chatRepository = ref.read(chattingRepositoryProvider);
  final userInfo = ref.read(userProvider)?.profile;
  // final isolateController = ref.read(hiveIsolateProvider);
  assert(userInfo != null);
  log("chat room controller start");
  ref.onDispose(
    () {
      chatRepository.disconnectSocket();
      log("chat room controller dispose");
    },
  );

  final void Function({
    required String body,
    required int id,
    required String title,
  }) notificationAction = ({
    required String body,
    required int id,
    required String title,
  }) {
    ref
        .read(notificationControllerProvider.notifier)
        .showNotification(body: body, id: id, title: title);
  };
  return ChattingController(box, chatRepository, userInfo!, notificationAction);
});

// chatRoom 관련 provider
final chattingRepositoryProvider = Provider((ref) => ChattingRepositoryImp(
    ref.read(sockeClientProvier), ref.read(apiClientProvider)));

final apiClientProvider = Provider((ref) => ApiClient(BASE_URL));
final sockeClientProvier = Provider((ref) => SocketClient(BASE_URL, "/ws"));
