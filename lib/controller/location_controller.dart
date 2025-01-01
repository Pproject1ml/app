import 'dart:async';
import 'dart:developer';
import 'package:chat_location/features/map/presentation/provider/googl_map_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PositionNotifier extends StateNotifier<LatLng?> {
  PositionNotifier(this.googleMapNotifier) : super(null);
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
      distanceFilter: 10,
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
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      final newPosition = LatLng(position.latitude, position.longitude);
      state = newPosition; // Riverpod 상태 업데이트
      // marker 업데이트
      googleMapNotifier.updateCircle(newPosition);
    });
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
  return PositionNotifier(googleMapStateNotifier);
});
