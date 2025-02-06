import 'dart:convert';
import 'dart:developer';

import 'package:chat_location/constants/data.dart';

import 'package:chat_location/controller/notification_controller.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/newtwork/api_client.dart';

import 'package:chat_location/features/chat/data/model/chat_message.dart';
import 'package:chat_location/features/chat/data/model/chatroom.dart';

import 'package:chat_location/features/chat/data/repositories/chatting_repository_impl.dart';
import 'package:chat_location/features/chat/domain/entities/chat_message.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';

import 'package:chat_location/features/user/domain/entities/profile.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive/hive.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class PsersonalChattingController
    extends StateNotifier<AsyncValue<List<ChatRoomInterface>>> {
  final LazyBox<ChatRoomHiveModel> _chatRoomBox;
  final ChattingRepositoryImp chattingRepository;
  final ProfileInterface userInfo;
  String? _currentRoomId;
  final void Function({
    required String body,
    required int id,
    required String title,
  }) notificationAction;
  PsersonalChattingController(this._chatRoomBox, this.chattingRepository,
      this.userInfo, this.notificationAction)
      : super(const AsyncValue.loading());

  Future<ChatRoomInterface> createPrivateChatroom(String profileId) async {
    try {
      final chatroomInfo =
          await chattingRepository.createPrivateChatroom(profileId: profileId);
      // title 수정하기

      ChatRoomInterface chatroom =
          ChatRoomInterface.fromChatRoomModel(chatroomInfo);
      final titleKey =
          chatroom.profiles.keys.firstWhere((key) => key != userInfo.profileId);
      final chatroomTitle = chatroom.profiles[titleKey]?.nickname ?? '알수없음';
      chatroom = chatroom.copyWith(
          title: chatroomTitle,
          imagePath: chatroom.profiles[titleKey]?.profileImage);
      await joinAction(chatroom);
      return chatroom;
    } catch (e, s) {
      throw e.toString();
    }
  }

  // --------------chatting  actions ------------------

  Future<void> joinAction(ChatRoomInterface chatroom) async {
    try {
      await chattingRepository.isJoinChatRoomAvailable(
          chatroom.chatroomId, userInfo.profileId);
      final chatroomId = chatroom.chatroomId;

      // 1. Local db에 채팅방을 추가한다.
      await chattingRepository.createChatRoomLocal(chatroom.toHiveModel());

      // 2. Local db에 채팅을 추가한다. (Open box)
      await _openChattingMessageBox(chatroomId);

      // 3. state에 채팅방을 추가한다.
      await _addChatRoomState(chatroom);

      // 4. socket에 구독 요청을 보낸다.
      final joinHeader = {"profileId": userInfo.profileId};
      chattingRepository.subscribeChatRoom(
          roomId: chatroomId,
          isPrivate: true,
          onMessage: onMessageHandler,
          command: "JOIN",
          headers: joinHeader);
      _currentRoomId = chatroomId;
    } catch (e, s) {
      log(e.toString() + s.toString());
      _currentRoomId = null;
      throw "채팅방에 입장할 수 없습니다.";
    }
  }

  Future<void> dieAction(String chatroomId) async {
    try {
      // 1. Socket 구독 취소를 한다.( unsubscribe/die)
      _unsubscribe(
        roomId: chatroomId,
        command: "DIE",
        profileId: userInfo.profileId,
      );

      //2. staet에서 삭제한다.
      await _removeChatRoomState(chatroomId);

      //3. Local db에 채팅방을 뺀다.
      chattingRepository.deleteChatroomLocal(chatroomId);

      //4. Local db에 채팅을 삭제한다. ( delete)
      chattingRepository.deleteMessageLocal(chatroomId);

      _currentRoomId = null;
    } catch (e, s) {
      log(e.toString() + s.toString());
      _currentRoomId = null;
    }
  }

  Future<void> initAction() async {
    try {
      final hiveChatroomKeys = _chatRoomBox.keys.toList();

      List<ChatRoomInterface> chatrooms = [];

      // 1. 서버에서 채팅방을 가져온다.(http)
      bool _fetchSuccess = false;
      List<ChatRoomInterface> _fetchedRooms = [];
      try {
        _fetchedRooms = await _fetchChatRoomList();
        _fetchSuccess = true;
      } catch (e, s) {
        log(e.toString() + s.toString());
        _fetchSuccess = false;
      }

      if (_fetchSuccess) {
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
          if (_room.active) {
            // 채팅 box가 안켜져 있다면 키도록
            await _openChattingMessageBox(chatroomId);

            // 채팅방 구독하기
            chattingRepository.subscribeChatRoom(
                roomId: chatroomId,
                isPrivate: true,
                onMessage: onMessageHandler,
                notSubsribeIfSubsbribed: true);
            // 해당 채팅방의 기존 채팅 keys 가져오기
          }
          final _hiveChattingkeys =
              await chattingRepository.getMessageKeysLocal(chatroomId);

          // obj 업데이트
          final _roomData = _room.copyWith(hiveKeys: _hiveChattingkeys);
          chatrooms.add(_roomData);
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
          if (_room.active) {
            // 채팅방을 local에 추가
            await chattingRepository.createChatRoomLocal(_room.toHiveModel());

            // 채팅 box가 안켜져 있다면 키도록
            await _openChattingMessageBox(chatroomId);

            // 채팅방 구독하기
            chattingRepository.subscribeChatRoom(
                roomId: chatroomId,
                isPrivate: true,
                onMessage: onMessageHandler,
                notSubsribeIfSubsbribed: true);

            // 임시 List에 추가
            chatrooms.add(_room);
            // chattingRepository.createChatRoomLocal(_room.toHiveModel());
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
      }
      if (!_fetchSuccess) {
        List<ChatRoomInterface> _hiveChatrooms = [];
        for (final key in hiveChatroomKeys) {
          final ChatRoomHiveModel? _hiveRoom = await _chatRoomBox.get(key);
          if (_hiveRoom != null) {
            _hiveChatrooms.add(ChatRoomInterface.fromHiveModel(_hiveRoom));
          }
        }
        for (final _room in _hiveChatrooms) {
          final chatroomId = _room.chatroomId;

          // 해당 채팅방이 Active 이라면
          if (_room.active) {
            // 채팅 box가 안켜져 있다면 키도록
            await _openChattingMessageBox(chatroomId);

            // 채팅방 구독하기
            chattingRepository.subscribeChatRoom(
                roomId: chatroomId,
                isPrivate: true,
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
      }
      // 상태를 업데이트 한다.
      chatrooms.sort((a, b) {
        if (a.active != b.active) {
          return (a.active ? 1 : 0) - (b.active ? 1 : 0);
        }

        if (a.lastMessageAt == null && b.lastMessageAt == null) {
          // 둘 다 null이면 순서를 유지
          return 0;
        } else if (a.lastMessageAt == null) {
          // dateA가 null이면 아래로
          return -1;
        } else if (b.lastMessageAt == null) {
          // dateB가 null이면 아래로
          return 1;
        }
        return b.lastMessageAt!.compareTo(a.lastMessageAt!);
      });
      state = AsyncData(chatrooms);
      if (!_fetchSuccess) {
        throw "채팅방 정보를 가져올 수 없습니다.";
      }
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw "채팅방 정보를 가져올 수 없습니다.";
    }
  }

  Future<void> refreshAction() async {
    final List<ChatRoomInterface> currentState =
        state.maybeWhen(data: (v) => v, orElse: () => throw "state 문제");
    try {
      // 0. 메모리에서 채팅방을 가져온다.(state)

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
          .map((room) {
        final updatedRoom = _fetchedRooms.firstWhere(
            (fetchedRoom) => fetchedRoom.chatroomId == room.chatroomId);
        return room.copyWith(
            profiles: updatedRoom.profiles,
            title: updatedRoom.title,
            count: updatedRoom.count,
            active: updatedRoom.active,
            lastMessage: updatedRoom.lastMessage,
            lastMessageAt: updatedRoom.lastMessageAt,
            latitude: updatedRoom.latitude,
            longitude: updatedRoom.longitude,
            alarm: updatedRoom.alarm);
      }).toList();

      chatrooms.addAll(normalRooms);

      final needtoAddIds =
          _fetchedChatroomIdsSet.difference(_currentStateIdsSet);
      final needtoAddRooms = _fetchedRooms
          .where((room) => needtoAddIds.contains(room.chatroomId))
          .toList();

      for (final _room in needtoAddRooms) {
        final chatroomId = _room.chatroomId;

        // able인 경우
        if (_room.active) {
          // 채팅방을 local에 추가
          await chattingRepository.createChatRoomLocal(_room.toHiveModel());

          // 채팅 box가 안켜져 있다면 키도록
          await _openChattingMessageBox(chatroomId);

          // 채팅방 구독하기
          chattingRepository.subscribeChatRoom(
              roomId: chatroomId,
              isPrivate: true,
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
      state = AsyncData(currentState);
      // throw '채팅방 가져오기에 실패하였습니다.';
    }
  }

  Future<void> leaveAction() async {
    try {
      _currentRoomId = null;
      // socket으로 leave action 보내기
    } catch (e, s) {
      log(e.toString() + s.toString());
      _currentRoomId = null;
    }
  }

  Future<void> enterAction(String chatroomId) async {
    ChatRoomInterface _roomInfo = state.maybeWhen(
        data: (v) => v.firstWhere((room) => room.chatroomId == chatroomId),
        orElse: () => throw "state 문제");

    try {
      // 2. 해당 오브젝트에서 hive_keys 를 통해 이전 채팅 데이터 키를 가져온다.  key의 마지막과 chatting state의 첫번째를 비교해서 chating state 의 id가 더 크다면 안불러와도됩니다.
      final bool needToFetchLocal = _roomInfo.hiveKeys.isEmpty
          ? false
          : _roomInfo.chatting.isEmpty
              ? true
              : _roomInfo.hiveKeys[_roomInfo.hiveKeys.length - 1] <
                  int.parse(_roomInfo
                      .chatting[_roomInfo.chatting.length - 1].messageId!);

      final _localChatKeys = _roomInfo.hiveKeys;

      final String? _lastMessageId = _roomInfo.chatting.isNotEmpty
          ? _roomInfo.chatting[_roomInfo.chatting.length - 1].messageId
          : null;

      List<ChatMessageInterface> localMessages = [];

      // local db에서 채팅을 불러와야 할 경우 채팅을 불러온다.
      if (needToFetchLocal) {
        // 내림차순 정렬
        localMessages = await chattingRepository.getMessageLocal(
            candidateKeys: _localChatKeys,
            lastMessageId: _lastMessageId,
            chatroomId: chatroomId);
      }

      // http로 요청 보내서 사이 데이터 받아오기

      // messageId 로 오름차순
      final serverData = await chattingRepository.getPrivateChatMessages(
          chatroomId: chatroomId,
          startChatId:
              localMessages.isNotEmpty ? localMessages[0].messageId : null,
          endChatId: _roomInfo.chatting.isNotEmpty
              ? _roomInfo.chatting[_roomInfo.chatting.length - 1].messageId
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
        ...localMessages.toList()
      ];

      state = AsyncData(state
          .maybeWhen(data: (v) => v, orElse: () => throw "state 문제")
          .map((v) => v.chatroomId == _roomInfo.chatroomId
              ? v.copyWith(chatting: [...v.chatting, ..._updatedChatMessages])
              : v)
          .toList());

      // http 응답 데이터 local 저장하기
      final Map<String, ChatMessageHiveModel> _hiveData = {
        for (int i = 0; i < serverData.length; i++)
          serverData[i].messageId!: serverData[i].toHiveMessage()
      };
      _currentRoomId = chatroomId;
      // 비동기로 처리하기
      chattingRepository.saveMessagesLocal(_hiveData, chatroomId);
    } catch (e, s) {
      log(e.toString() + s.toString());
      _currentRoomId = null;
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

      await chattingRepository.sendChatMessage(
          message: _message.toChatMessageModel(), isPrivate: true);
    } catch (e) {
      log(e.toString());
      throw "메시지 전송에 실패하였습니다.";
    }
  }

  Future<void> loadMoreAction(String chatroomId) async {
    try {
      ChatRoomInterface _roomInfo = state.maybeWhen(
          data: (v) => v.firstWhere((room) => room.chatroomId == chatroomId),
          orElse: () => throw "state 문제");

      // 만약 현재의 마지막 messageId가 hive 의 [0] 보다 크다면 loadmore를 해야합니다.
      final _hiveKeys = _roomInfo.hiveKeys;

      final _lastIndex = _roomInfo.chatting.length - 1;

      String? _lastMessageId;

      if (_lastIndex > 0) {
        _lastMessageId = _roomInfo.chatting[_lastIndex].messageId!;
      }

      // loadmore 로직
      if (_lastMessageId != null &&
          _hiveKeys.isNotEmpty &&
          int.parse(_lastMessageId) > _hiveKeys[0]) {
        final List<ChatMessageInterface> _localDatas =
            await chattingRepository.getMessageLocal(
                candidateKeys: _hiveKeys,
                chatroomId: chatroomId,
                lastMessageId: _lastMessageId);

        List<ChatRoomInterface> updatedList = state
            .maybeWhen(data: (v) => v, orElse: () => throw "state 문제")
            .map((room) => room.chatroomId != _roomInfo.chatroomId
                ? room
                : room.copyWith(chatting: [...room.chatting, ..._localDatas]))
            .toList();

        state = AsyncValue.data(updatedList);
      }
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  Future<void> alarmSettingAction(String chatroomId, bool alarm) async {
    try {
      // 서버에 요청
      await chattingRepository.setChatroomAlarm(
          chatroomId, userInfo.profileId, alarm);
      // state 변경
      _updateAlarm(chatroomId, alarm);
      // local 변경
      chattingRepository.updateAlarmLocal(chatroomId, alarm);
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw ("alarm 변경에 실패하였습니다.");
    }
  }

  // --------------socket actions ------------------------

  void _unsubscribe(
      {required String roomId, String? command, String? profileId}) async {
    Map<String, String>? _header;
    if (profileId != null) {
      _header = {'profileId': profileId};
    }
    ;

    chattingRepository.unSubscribeChatRoom(
        roomId: roomId, command: command, headers: _header, isPrivate: true);
  }

// -------------- onMessage actions -------------------
  // command에 따라서 메세지 처리를 해줍니다.
  Future<void> onMessageHandler(StompFrame onMessage) async {
    log("onMessage call");
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
    if (isFromOtherUser &&
        isTextMessage &&
        _currentRoomId != message.chatroomId) {
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

      // local에 저장하기
      _saveMessageLocal(res);

      _saveChatRoomLocal(_currentRoom.toChatRoomModel());
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  void _onReceiveJOIN(dynamic data) {
    try {
      // TODO: 1. 해당방을 업데이트 해주자.  2. 채팅 업데이트 해주자.  2.profiles 업데이트 하기  4. local에 저장하자

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

      List<ChatMessageInterface> _chatting = _currentRoom.chatting;
      _chatting = [
        message,
        ..._chatting,
      ];
      // TODO: 프로필 업데이트 하기
      Map<String, ProfileInterface>? _profiles;
      if (message.profiles != null) {
        _profiles = {
          for (final profile in message.profiles!) profile.profileId: profile
        };
      }

      _currentRoom = _currentRoom.copyWith(
          lastMessage: message.content,
          lastMessageAt: message.createdAt,
          chatting: _chatting,
          profiles: _profiles);

      List<ChatRoomInterface> filteredList = state
          .maybeWhen(data: (v) => v, orElse: () => throw "state 문제")
          .where((room) => room.chatroomId != _currentRoom.chatroomId)
          .toList();

      // 상태 변경해주기
      state = AsyncValue.data([_currentRoom, ...filteredList]);

      // local에 저장하기
      _saveMessageLocal(res);

      _saveChatRoomLocal(_currentRoom.toChatRoomModel());
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
  }

  void _onReceiveDIE(dynamic _message) {
    try {
      // TODO: 1. 해당방을 업데이트 해주자.  2. 채팅 업데이트 해주자.  2.profiles 업데이트 하기  4. local에 저장하자

      final _chatroomId = _message!['chatroomId'];

      final _content = _message!['content'];

      final _lastMessageAt = DateTime.parse(_message['createdAt'] as String);

      // model convert
      final ChatMessageModel res = ChatMessageModel.fromJson(_message);

      // ㅡmodel convert
      final ChatMessageInterface message =
          ChatMessageInterface.fromChatMessageModel(res);

      // ㅡchatroom temp model
      ChatRoomInterface _currentRoom = state.maybeWhen(
          data: (v) => v.firstWhere((room) => room.chatroomId == _chatroomId),
          orElse: () => throw "state 문제");

      List<ChatMessageInterface> _chatting = _currentRoom.chatting;
      _chatting = [
        message,
        ..._chatting,
      ];
      // TODO: 프로필 업데이트 하기
      Map<String, ProfileInterface>? _profiles;
      if (message.profiles != null) {
        _profiles = {
          for (final profile in message.profiles!) profile.profileId: profile
        };
      }

      _currentRoom = _currentRoom.copyWith(
          lastMessage: message.content,
          lastMessageAt: message.createdAt,
          chatting: _chatting,
          profiles: _profiles);

      List<ChatRoomInterface> filteredList = state
          .maybeWhen(data: (v) => v, orElse: () => throw "state 문제")
          .where((room) => room.chatroomId != _currentRoom.chatroomId)
          .toList();

      // 상태 변경해주기
      state = AsyncValue.data([_currentRoom, ...filteredList]);

      // local에 저장하기
      _saveMessageLocal(res);

      _saveChatRoomLocal(_currentRoom.toChatRoomModel());
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
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
  Future<void> _openChattingMessageBox(
    String chatRoomId,
  ) async {
    final boxName = HIVE_PERSONAL_CHAT_MESSAGE + "${chatRoomId}";

    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openLazyBox<ChatMessageHiveModel>(boxName);
      }
    } catch (e) {
      throw '핸드폰에 저장된 채팅정보를 불러오는데 실패하였습니다.';
    }
  }

  // chat room list 가져오기
  Future<List<ChatRoomInterface>> _fetchChatRoomList() async {
    try {
      // 서버에서 모든 room 정보를 가져옵니다.
      final res = await chattingRepository
          .getAllPrvateChatRoomsFromServer(profileId: userInfo.profileId)
          .then((v) {
        return v.map((v2) {
          final profileIndex = v2.profiles?.indexWhere(
            (key) => key.profileId != userInfo.profileId,
          );

          String chatroomTitle = '알수없음';
          String? profileImage = null;

          if (profileIndex != null && profileIndex >= 0) {
            chatroomTitle = v2.profiles![profileIndex].nickname;
            profileImage = v2.profiles![profileIndex].profileImage;
          }

          return ChatRoomInterface.fromChatRoomModel(v2)
              .copyWith(title: chatroomTitle, imagePath: profileImage);
        }).toList();
      });

      return res;
    } catch (e, s) {
      state = AsyncValue.error('채팅방 정보를 가져오는데 실패하였습니다.', s);
      throw '채팅방 정보를 가져오는데 실패하였습니다.';
    }
  }

  // ---------------- state action ------------------------

  // 채팅방 추가하기
  Future<void> _addChatRoomState(ChatRoomInterface chatRoom) async {
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
  Future<void> _removeChatRoomState(String chatRoomId) async {
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

  Future<void> _updateChatRoomState(ChatRoomInterface chatroom) async {
    try {
      final prevState =
          state.maybeWhen(data: (v) => v, orElse: () => throw 'state error');
      state = AsyncData([
        for (final room in prevState)
          if (room.chatroomId == chatroom.chatroomId) chatroom else room
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

  void _updateAlarm(String chatroomId, bool alarm) {
    try {
      final prevState =
          state.maybeWhen(data: (v) => v, orElse: () => throw 'state error');
      state = AsyncData([
        for (final room in prevState)
          if (room.chatroomId == chatroomId)
            room.copyWith(alarm: alarm)
          else
            room
      ]);
    } catch (e, s) {
      log(e.toString() + s.toString());
    }
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

  // -------------------- hive action ---------------------------
  Future<void> _saveMessageLocal(ChatMessageModel message) async {
    try {
      final ChatMessageHiveModel _message = message.toHiveMessage();

      await chattingRepository.saveMessageLocal(_message);
    } catch (e, s) {}
  }

  Future<void> _saveChatRoomLocal(ChatRoomModel chatroom) async {
    try {
      final ChatRoomHiveModel _room = chatroom.toHiveModel();

      await chattingRepository.saveChatroomLocal(_room);
    } catch (e, s) {}
  }

  // -------------------getter ----------------------------
  AsyncValue<List<ChatRoomInterface>> get() => state;
  List<ChatRoomInterface> getData() {
    try {
      final List<ChatRoomInterface> value =
          state.maybeWhen(data: (v) => v, orElse: () => throw "state 문제");
      return value;
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw e;
    }
  }

  String? getCurrentRoomId() => _currentRoomId;
}

// Hive LazyBox Provider
final chatRoomLazyBoxProvider = Provider<LazyBox<ChatRoomHiveModel>>((ref) {
  // LazyBox 열기
  if (!Hive.isBoxOpen(HIVE_PERSONAL_CHATROOM)) {
    throw Exception(
        'LazyBox "chatRooms" is not open. Did you forget to open it?');
  }
  return Hive.lazyBox<ChatRoomHiveModel>(HIVE_PERSONAL_CHATROOM);
});

// ChatRoomController Provider
final personalchattingControllerProvider = StateNotifierProvider<
    PsersonalChattingController, AsyncValue<List<ChatRoomInterface>>>((ref) {
  final box = ref.read(chatRoomLazyBoxProvider);
  final chatRepository = ref.read(chattingRepositoryProvider);
  final userInfo = ref.read(userProvider)?.profile;
  // final isolateController = ref.read(hiveIsolateProvider);
  assert(userInfo != null);

  ref.onDispose(
    () {
      log("personal chat dispoded");
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
  return PsersonalChattingController(
      box, chatRepository, userInfo!, notificationAction);
});

// chatRoom 관련 provider
final chattingRepositoryProvider = Provider((ref) => ChattingRepositoryImp(
    ref.read(sockeClientProvier), ref.read(apiClientProvider)));

final apiClientProvider =
    Provider((ref) => ApiClient(BASE_URL, HTTPS_BASE_URL));
