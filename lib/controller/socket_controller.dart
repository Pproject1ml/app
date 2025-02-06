// import 'package:chat_location/constants/data.dart';
// import 'package:chat_location/core/newtwork/socket_client.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SocketController extends StateNotifier<SocketClient> {
//   final SocketClient cli;
//   final Future<void> Function() onConnectHandler;
//   SocketController(this.cli, this.onConnectHandler) : super(cli){

//   }

// }

// final socketControllerProvider =
//     StateNotifierProvider<SocketController, SocketClient>((ref) {
//   final cli = SocketClient(BASE_URL, "/ws", HTTPS_BASE_URL);
//   Future<void> onConnectHandler() async {}
//   return SocketController(cli, onConnectHandler);
// });
