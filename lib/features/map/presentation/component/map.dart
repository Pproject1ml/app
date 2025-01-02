import 'dart:developer';
import 'package:chat_location/controller/location_controller.dart';
import 'package:chat_location/features/map/domain/entities/chat_room.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/presentation/component/refresh.dart';
import 'package:chat_location/features/map/presentation/provider/googl_map_controller.dart';
import 'package:chat_location/features/map/presentation/provider/landmark_controller.dart';

import 'package:chat_location/features/map/utils/map_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends ConsumerStatefulWidget {
  const Map({super.key, required this.chatRooms, this.landmarks = const []});
  final List<ChatRoom_> chatRooms;
  final List<Landmark_> landmarks;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoogleMapState();
}

class _GoogleMapState extends ConsumerState<Map> {
  late String _mapStyleString;

  @override
  void initState() {
    // TODO: implement initState
    log("map init");
    // google map dar theme 설정 파일 로드
    rootBundle
        .loadString('assets/json/google_map_dark_mode.json')
        .then((string) {
      _mapStyleString = string;
    });
    super.initState();
  }

  Future<void> handleClickRefresh(LatLng position) async {
    // 현재 위치를 바탕으로 landMark 정보를 다시 요청한다.
    try {
      ref.read(googleMapStateProvider.notifier).animateCamera(position);
      // 랜드마크 데이터 요청 api call
      await Future.delayed(Duration(seconds: 3));
      final List<Landmark_> LandmarkDatas = [
        Landmark_(
            id: 0,
            name: "경복궁",
            latitude: 37.579617,
            longitude: 126.977041,
            radius: 10),
        Landmark_(
            id: 1,
            name: "남산타워",
            latitude: 37.5511694,
            longitude: 126.9882266,
            radius: 10),
        Landmark_(
            id: 2,
            name: "덕수궁",
            latitude: 37.5658049,
            longitude: 126.9751461,
            radius: 10),
      ];

      await ref
          .read(landmarkListProvider.notifier)
          .getAvailableLangMarkFromServer(
              position:
                  ref.read(positionProvider.notifier).getCurrentPosition());

      // 가져온 정보로 marker update
      await ref
          .read(googleMapStateProvider.notifier)
          .updateMarker(LandmarkDatas);
      // 지도 중심을 이동
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(positionProvider);
    if (position == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final googleMapState = ref.watch(googleMapStateProvider);

    // _createCustomMarker();
    return Stack(
      children: [
        GoogleMap(
            onMapCreated:
                ref.read(googleMapStateProvider.notifier).onMapCreated,
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 12.0,
            ),
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            markers: googleMapState.markers,
            circles: googleMapState.circle.isEmpty
                ? createCircle(position)
                : googleMapState.circle),
        Positioned(
            bottom: 20,
            left: 12,
            child: RefreshLocation(
              onRefresh: () async {
                await handleClickRefresh(position);
              },
            )),
      ],
    );
  }
}
