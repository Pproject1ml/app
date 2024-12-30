import 'package:chat_location/controller/location_controller.dart';
import 'package:chat_location/features/map/component/chat_list.dart';
import 'package:chat_location/features/map/component/map.dart';
import 'package:chat_location/features/map/component/refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const LOCATION_DATA = [
  {"lat": 37.5658049, "lon": 126.9751461, "name": "덕수궁"},
  {"lat": 37.5511694, "lon": 126.9882266, "name": "남산타워"},
  {"lat": 37.579617, "lon": 126.977041, "name": "경복궁"},
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

    ref.read(positionProvider.notifier).startPositionStream();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(positionProvider);

    return const Scaffold(
      body: Stack(
        children: [
          Map(
            LOCATION_DATA: LOCATION_DATA,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: ChatListBox(
                    LOCATION_DATA: LOCATION_DATA,
                  )),
            ),
          ),
          Positioned(bottom: 20, left: 12, child: RefreshLocation()),
          // Positioned(
          //     bottom: 20,
          //     right: 12,
          //     child: GestureDetector(
          //         onTap: () {
          //           ref.read(positionProvider.notifier).move();
          //         },
          //         child: const Text('move')))
        ],
      ),
    );
  }
}
