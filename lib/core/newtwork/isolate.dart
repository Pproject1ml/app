// // // import 'dart:async';
// // // import 'dart:collection';
// import 'dart:async';
// import 'dart:collection';
// import 'dart:isolate';

// import 'package:flutter/services.dart';
// // // import 'package:flutter/services.dart';

// // Isolate를 다루는 mixin 클래스
// mixin IsolateHelperMixin {
//   // 동시에 실행할 수 있는 Isolate의 최대 개수 설정
//   static const int _maxIsolates = 5;

//   // 현재 실행 중인 Isolate의 개수를 추적
//   int _currentIsolates = 0;

//   // 보류 중인 작업을 저장하는 큐
//   final Queue<Function> _taskQueue = Queue();

//   // Isolate를 생성하여 함수를 실행하거나, 만약 현재 실행 중인 Isolate의 개수가 최대치에 도달한 경우 큐에 작업을 추가
//   Future<T> loadWithIsolate<T>(Future<T> Function() function) async {
//     if (_currentIsolates < _maxIsolates) {
//       _currentIsolates++;
//       return _executeIsolate(function);
//     } else {
//       final completer = Completer<T>();
//       _taskQueue.add(() async {
//         final result = await _executeIsolate(function);
//         completer.complete(result);
//       });
//       return completer.future;
//     }
//   }

//   // 새로운 Isolate를 생성하여 주어진 함수를 실행
//   Future<T> _executeIsolate<T>(Future<T> Function() function) async {
//     final ReceivePort receivePort = ReceivePort();
//     final RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

//     final isolate = await Isolate.spawn(
//       _isolateEntry,
//       _IsolateEntryPayload(
//         function: function,
//         sendPort: receivePort.sendPort,
//         rootIsolateToken: rootIsolateToken,
//       ),
//     );

//     // Isolate의 결과를 받고, 이 Isolate를 종료한 후, 큐에서 다음 작업을 실행
//     return receivePort.first.then(
//       (dynamic data) {
//         _currentIsolates--;
//         _runNextTask();
//         if (data is T) {
//           isolate.kill(priority: Isolate.immediate);
//           return data;
//         } else {
//           isolate.kill(priority: Isolate.immediate);
//           throw data;
//         }
//       },
//     );
//   }

//   // 큐에서 다음 작업을 꺼내어 실행
//   void _runNextTask() {
//     if (_taskQueue.isNotEmpty) {
//       final nextTask = _taskQueue.removeFirst();
//       nextTask();
//     }
//   }
// }

// // Isolate에서 실행되는 함수
// Future<void> _isolateEntry(_IsolateEntryPayload payload) async {
//   final Function function = payload.function;

//   try {
//     BackgroundIsolateBinaryMessenger.ensureInitialized(
//       payload.rootIsolateToken,
//     );
//   } on MissingPluginException catch (e) {
//     print(e.toString());
//     return Future.error(e.toString());
//   }

//   // payload로 전달받은 함수 실행 후 결과를 sendPort를 통해 메인 Isolate로 보냄
//   final result = await function();
//   payload.sendPort.send(result);
// }

// // Isolate 생성 시 필요한 데이터를 담는 클래스
// class _IsolateEntryPayload {
//   const _IsolateEntryPayload({
//     required this.function,
//     required this.sendPort,
//     required this.rootIsolateToken,
//   });

//   final Future<dynamic> Function() function; // Isolate에서 실행할 함수
//   final SendPort sendPort; // 메인 Isolate로 데이터를 보내기 위한 SendPort
//   final RootIsolateToken rootIsolateToken; // Isolate간 통신을 위한 토큰
// }

// import 'dart:isolate';

// class IsolateExecutor<T> {
//   IsolateExecutor({
//     required T Function() function,
//   }) {
//     _function = function;
//   }

//   late final Function() _function;

//   bool _isExecute = false;

//   Future<T?> executeIsolate() async {
//     if (_isExecute) return null;
//     _isExecute = true;

//     final ReceivePort receivePort = ReceivePort();

//     final isolate = await Isolate.spawn(
//       _isolateEntryPoint,
//       _IsolateMessage(
//         function: _function,
//         sendPort: receivePort.sendPort,
//       ),
//     );

//     final result = await receivePort.first as T;
//     receivePort.close();
//     isolate.kill(priority: Isolate.immediate);
//     _isExecute = false;
//     return result;
//   }

//   void _isolateEntryPoint(_IsolateMessage message) {
//     final result = message.function();
//     message.sendPort.send(result);
//   }
// }

// class _IsolateMessage {
//   _IsolateMessage({
//     required this.function,
//     required this.sendPort,
//   });

//   final dynamic Function() function;
//   final SendPort sendPort;
// }

// import 'dart:isolate';

// class IsolateExecutor {
//   IsolateExecutor();

//   Future<T> executeIsolate<T>(Function() function) async {
//     final ReceivePort receivePort = ReceivePort();

//     final isolate = await Isolate.spawn(
//       _isolateEntryPoint,
//       _IsolateMessage(
//         function: function,
//         sendPort: receivePort.sendPort,
//       ),
//     );

//     final result = await receivePort.first as T;
//     receivePort.close();
//     isolate.kill(priority: Isolate.immediate);
//     return result;
//   }

//   void _isolateEntryPoint(_IsolateMessage message) async {
//     final result = await message.function();
//     message.sendPort.send(result);
//   }
// }

// class _IsolateMessage {
//   _IsolateMessage({
//     required this.function,
//     required this.sendPort,
//   });

//   final dynamic Function() function;
//   final SendPort sendPort;
// }

// import 'dart:developer';
// import 'dart:isolate';
// import 'dart:async';
// import 'package:chat_location/core/database/no_sql/chat_message.dart';
// import 'package:chat_location/core/database/no_sql/chat_room.dart';
// import 'package:flutter/services.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';

// void hiveIsolateEntry(Map<String, dynamic> message) async {
//   final sendPort = message['sendPort'] as SendPort;
//   final operation = message['operation'] as String;
//   final data = message['data'];
//   final boxKey = message['boxKey'] as String; // Box key 전달
//   final rootIsolateToken = message['rootIsolateToken'] as RootIsolateToken;

//   try {
//     // final RootIsolateToken rootIsolateToken = RootIsolateToken.instance;
//     BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
//     // Isolate에서 Hive 초기화
//     final dir = await getApplicationDocumentsDirectory();
//     Hive.init(dir.path);
//     Hive.registerAdapter(ChatMessageHiveModelAdapter()); // 채팅 어댑터
//     // 전달받은 Box key를 사용하여 Box 열기
//     final box = await Hive.openBox<ChatMessageHiveModel>(boxKey);

//     if (operation == 'write') {
//       // 데이터 저장
//       log("저장하기:  ${data['value']}");
//       await box.put(data['key'], data['value']);
//       sendPort.send(data['value']);
//     } else if (operation == 'keys') {
//       final result = box.keys.toList();
//       sendPort.send(result);
//     } else if (operation == 'read') {
//       // 데이터 읽기
//       final result = box.get(data['key']);
//       sendPort.send(result);
//     }

//     // await box.close(); // Box 닫기
//   } catch (e) {
//     log("isolate error: ${e.toString()}");
//     // 에러 발생 시 에러 메시지를 전송
//     sendPort.send('Error in box "$boxKey": ${e.toString()}');
//   }
// }

// Future<dynamic> runHiveTask(
//     {required String operation,
//     required String boxKey,
//     required Map<String, dynamic> data}) async {
//   final receivePort = ReceivePort();

//   // Isolate 생성 및 작업 전달
//   await Isolate.spawn(
//     hiveIsolateEntry,
//     {
//       'sendPort': receivePort.sendPort,
//       'operation': operation,
//       'data': data,
//       'boxKey': boxKey, // Box key 전달
//       'rootIsolateToken': RootIsolateToken.instance,
//     },
//   );

//   // 결과 수신
//   final result = await receivePort.first;

//   return result;
// }
