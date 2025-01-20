import 'dart:developer';
import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/controller/location_controller.dart';

import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/presentation/component/refresh.dart';
import 'package:chat_location/features/map/presentation/provider/googl_map_controller.dart';
import 'package:chat_location/features/map/presentation/provider/landmark_controller.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';

import 'package:chat_location/features/map/utils/map_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends ConsumerStatefulWidget {
  const Map({super.key, this.landmarks = const []});

  final List<LandmarkInterface> landmarks;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoogleMapState();
}

class _GoogleMapState extends ConsumerState<Map> {
  late String _mapStyleString;

  @override
  void initState() {
    // TODO: implement initState

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
      final currentPositon =
          ref.read(positionProvider.notifier).getCurrentPosition();
      if (currentPositon == null) {
        {
          throw "현재 위치정보를 사용할 수 없습니다.";
        }
      }

      final landmarks = await ref
          .read(landmarkListProvider.notifier)
          .getAllLandMarkFromServer(currentPositon);

      // 가져온 정보로 marker update
      await ref.read(googleMapStateProvider.notifier).updateMarker(landmarks);
      // 지도 중심을 이동
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  Future<void> onMapCreatedCallback(LatLng position) async {
    try {
      final data = await ref
          .read(landmarkListProvider.notifier)
          .getAllLandMarkFromServer(position);
      await ref.read(googleMapStateProvider.notifier).updateMarker(data);
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw '랜드마크 불러오기에 실패하였습니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(positionProvider);
    if (position == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final googleMapState = ref.watch(googleMapStateProvider);

    return Stack(
      children: [
        GoogleMap(
            onMapCreated: (controller) {
              ref
                  .read(googleMapStateProvider.notifier)
                  .onMapCreated(controller, _mapStyleString, () async {
                await onMapCreatedCallback(position);
              });
            },
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 13.0,
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
