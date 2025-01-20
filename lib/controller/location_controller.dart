import 'dart:async';
import 'dart:developer';
import 'package:chat_location/common/utils/is_within_radius.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/presentation/provider/googl_map_controller.dart';
import 'package:chat_location/features/map/presentation/provider/landmark_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PositionNotifier extends StateNotifier<LatLng?> {
  final Ref ref;
  PositionNotifier(this.googleMapNotifier, this.ref) : super(null);
  final GoogleMapStateNotifier googleMapNotifier;
  // 위치 스트림 구독하여 위치 업데이트
  StreamSubscription<Position>? _positionStream;

  LatLng? getCurrentPosition() {
    return state;
  }

  //position stream으로 현재 위치 업데이트하기
  Future<void> startPositionStream() async {
    // location settings -> 10미터 이동마다 업데이트 하도록 한다.
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );
    // 위치정보 서비스 이용 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('위치 서비스가 비활성화되었습니다.');
      return;
    }
    // 위치정보 서비스 이용 동의 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('위치 권한이 거부되었습니다.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('위치 권한이 영구적으로 거부되었습니다.');
      return;
    }

    // 위치 스트림 구독 및 변경마다 상태 변경
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) {
      final newPosition = LatLng(position.latitude, position.longitude);

      state = newPosition; // Riverpod 상태 업데이트

      // 1. 현재 구독 중인 채팅방 변경하기
      final AsyncValue<List<ChatRoomInterface>> subscribedChatrooms =
          ref.read(chattingControllerProvider.notifier).get();

      subscribedChatrooms.when(
        data: (rooms) {
          for (final room in rooms) {
            final _prevState = room.available;
            final _distance = getDistance(
              position.latitude,
              position.longitude,
              room.latitude,
              room.longitude,
            );

            final _isWithinRadius = isWithinRadius(
              _distance,
              AVAILABLE_RADIUS_M,
            );

            if (_prevState != _isWithinRadius) {
              ref
                  .read(chattingControllerProvider.notifier)
                  .updateChatRoomAvilable(room, _isWithinRadius);
            }
          }
        },
        loading: () {},
        error: (error, stack) {},
      );

      // 2. 이용 가능한 랜드마크 업데이트
      final landmarks = ref.read(landmarkListProvider.notifier).get();

      final List<LandmarkInterface> chagedLandmarks = [];
      for (final landmark in landmarks) {
        final _distance = getDistance(
          position.latitude,
          position.longitude,
          landmark.latitude,
          landmark.longitude,
        );
        final _isWithinRadius = isWithinRadius(
          _distance,
          AVAILABLE_RADIUS_M,
        );
        final _updatedRoom = landmark.copyWith(
            chatroom: landmark.chatroom!
                .copyWith(available: _isWithinRadius, distance: _distance));
        chagedLandmarks.add(_updatedRoom);
      }
      ref.read(landmarkListProvider.notifier).updateLandmarks(chagedLandmarks);

      // marker 업데이트
      googleMapNotifier.updateCircle(newPosition);
    }, onError: (e, s) => log(e.toString() + s.toString()));
  }

  @override
  void dispose() {
    _positionStream?.cancel(); // 스트림 구독 해제
    super.dispose();
  }
}

final positionProvider =
    StateNotifierProvider<PositionNotifier, LatLng?>((ref) {
  final googleMapStateNotifier = ref.read(googleMapStateProvider.notifier);
  return PositionNotifier(googleMapStateNotifier, ref);
});
