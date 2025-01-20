import 'dart:isolate';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/database/no_sql/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveIsolateController {
  Isolate? _isolate;
  SendPort? _sendPort;
  final ReceivePort _receivePort = ReceivePort();

  // Isolate 초기화 및 Box 열기
  Future<void> initialize(List<String> boxKeys) async {
    if (_isolate != null) return;

    _isolate = await Isolate.spawn(_isolateEntry, _receivePort.sendPort);

    // Isolate에서 SendPort 받기
    _sendPort = await _receivePort.first as SendPort;

    // Hive 초기화 및 Box 열기
    final dir = await getApplicationDocumentsDirectory();
    final responsePort = ReceivePort();

    _sendPort?.send({
      'type': 'initialize',
      'path': dir.path,
      'boxKeys': boxKeys,
      'responsePort': responsePort.sendPort,
    });

    await responsePort.first; // 초기화 완료 대기
  }

  // 작업 요청
  Future<dynamic> runTask({
    required String operation,
    required String boxKey,
    required Map<String, dynamic> data,
  }) async {
    if (_sendPort == null) throw Exception('Isolate not initialized');

    final responsePort = ReceivePort();

    _sendPort?.send({
      'type': 'task',
      'operation': operation,
      'boxKey': boxKey,
      'data': data,
      'responsePort': responsePort.sendPort,
    });

    final result = await responsePort.first;
    responsePort.close();
    return result;
  }

  // Isolate 종료
  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
    _receivePort.close();
  }

  // Isolate Entry
  static void _isolateEntry(SendPort mainSendPort) async {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    final Map<String, Box> openBoxes = {};

    await for (final message in receivePort) {
      final type = message['type'];
      final sendPort = message['responsePort'] as SendPort?;

      try {
        if (type == 'initialize') {
          final path = message['path'] as String;
          final boxKeys = List<String>.from(message['boxKeys'] ?? []);
          Hive.init(path);
          Hive.registerAdapter(ChatMessageHiveModelAdapter());
          Hive.registerAdapter(ChatRoomHiveModelAdapter()); // 채팅방 어댑터
          Hive.registerAdapter(ChatMessageHiveModelAdapter()); // 채팅 어댑터
          Hive.registerAdapter(ProfileHiveModelAdapter());
          openBoxes[HIVE_CHATROOM] = await Hive.openBox<ChatRoomHiveModel>(
              HIVE_CHATROOM); // LazyBox 열기
          // Box 열기
          for (final boxKey in boxKeys) {
            if (!openBoxes.containsKey(boxKey)) {
              if (boxKey.startsWith(HIVE_CHAT_MESSAGE)) {
                openBoxes[boxKey] =
                    await Hive.openBox<ChatMessageHiveModel>(boxKey);
              } else if (boxKey.startsWith(HIVE_PROFILE)) {
                // progfile
              }
            }
          }
          sendPort?.send('Hive initialized and boxes opened: $boxKeys');
        } else if (type == 'task') {
          final operation = message['operation'] as String;
          final boxKey = message['boxKey'] as String;
          final data = message['data'];

          // 작업 수행

          Box<dynamic>? box = openBoxes[boxKey];
          if (box == null) {
            if (boxKey.startsWith(HIVE_CHAT_MESSAGE)) {
              openBoxes[boxKey] =
                  await Hive.openBox<ChatMessageHiveModel>(boxKey);
            } else if (boxKey.startsWith(HIVE_PROFILE)) {
              // progfile
            }

            box = openBoxes[boxKey];
          }
          assert(box != null);
          if (operation == 'write') {
            await box!.put(data['key'], data['value']);
            sendPort?.send('Data written: ${data['value']}');
          } else if (operation == 'read') {
            final result = box!.get(data['key']);
            sendPort?.send(result);
          } else if (operation == 'keys') {
            final result = box!.keys.toList();
            sendPort?.send(result);
          }
        }
      } catch (e) {
        sendPort?.send('Error: $e');
      }
    }
  }
}

// final hiveIsolateProvider = Provider.autoDispose<HiveIsolateController>((ref) {
//   final controller = HiveIsolateController();
//   ref.onDispose(controller.dispose);
//   return controller;
// });
