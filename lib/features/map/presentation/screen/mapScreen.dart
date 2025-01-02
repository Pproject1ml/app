import 'dart:developer';

import 'package:chat_location/controller/location_controller.dart';
import 'package:chat_location/features/map/domain/entities/chat_room.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/presentation/component/chat_list.dart';

import 'package:chat_location/features/map/presentation/component/map.dart';
import 'package:chat_location/features/map/presentation/component/refresh.dart';
import 'package:chat_location/features/map/presentation/provider/googl_map_controller.dart';
import 'package:chat_location/features/map/presentation/provider/landmark_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final List<ChatRoom_> chatRooms = [
  ChatRoom_(
    id: 0,
    title: "경복궁",
    landmark: Landmark_(
        id: 0,
        name: "경복궁",
        latitude: 37.579617,
        longitude: 126.977041,
        radius: 10),
  ),
  ChatRoom_(
    id: 1,
    title: "남산타워",
    landmark: Landmark_(
        id: 1,
        name: "남산타워",
        latitude: 37.5511694,
        longitude: 126.9882266,
        radius: 10),
  ),
  ChatRoom_(
    id: 2,
    title: "덕수궁",
    landmark: Landmark_(
        id: 2,
        name: "덕수궁",
        latitude: 37.5658049,
        longitude: 126.9751461,
        radius: 10),
  )
];

class MapScreen extends ConsumerStatefulWidget {
  static const String routeName = '/map'; // routeName 정의
  static const String pageName = " map";
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      await ref.read(positionProvider.notifier).startPositionStream();
    });

    Future.delayed(Duration.zero, () async {
      await ref
          .read(landmarkListProvider.notifier)
          .getAvailableLangMarkFromServer(
              position:
                  ref.read(positionProvider.notifier).getCurrentPosition());
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(positionProvider);
    final landmarks = ref.watch(landmarkListProvider);

    return Scaffold(
      body: Stack(
        children: [
          Map(
            chatRooms: chatRooms,
            landmarks: landmarks,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: ChatListBox(
                    chatRooms: chatRooms,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
