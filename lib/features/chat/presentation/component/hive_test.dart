import 'dart:developer';
import 'dart:math' as math;
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/features/chat/presentation/provider/chat_room_controller.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HiveTest extends ConsumerWidget {
  int currentRoomNumber = 0;
  HiveTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(chatRoomControllerProvider);
    final notifier = ref.read(chatRoomControllerProvider.notifier);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("hive test"),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  log("creat clicked");
                  // notifier.addChatRoom(ChatRoom(
                  //     id: currentRoomNumber.toString(),
                  //     name: "test${currentRoomNumber.toString()}",
                  //     participants: [],
                  //     lastMessage: "lastMessage",
                  //     lastReadMessageId: "id2"));
                  currentRoomNumber += 1;
                },
                child: Container(
                  color: Colors.amber,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("create room"),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  log("creat clicked");
                  String random = new math.Random().nextInt(100).toString();
                },
                child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("update rooms"),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: data
                .map((room) => Container(
                      child: Row(
                        children: [
                          Text("name: ${room.title}"),
                          Text("id: ${room.chatroomId}"),
                          GestureDetector(
                            onTap: () {
                              log("creat clicked");
                              // notifier.removeChatRoom(room.id);
                            },
                            child: Container(
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("delete room"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              String random =
                                  new math.Random().nextInt(100).toString();
                              log("update clicked: ${random}");
                              notifier.updateChatRoom(ChatRoom(
                                  chatroomId: room.chatroomId,
                                  title: random,
                                  members: [],
                                  lastMessage: "lastMessage",
                                  lastReadMessageId: "id2",
                                  updatedAt: DateTime.now()));
                            },
                            child: Container(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("update room"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(ChatPage.pageName,
                                  pathParameters: {'id': room.chatroomId});
                            },
                            child: Container(
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("go"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
