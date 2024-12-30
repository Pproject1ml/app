import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PositionNotifier extends StateNotifier<LatLng?> {
  PositionNotifier() : super(null);

  // 위치 스트림 구독하여 위치 업데이트
  StreamSubscription<Position>? _positionStream;

// 앞으로 움직이는거 test용입니다.
  Future<void> move() async {
    if (state == null) return;

    // 10초 동안 주기적으로 위치를 업데이트
    for (int i = 0; i < 10; i++) {
      // 기존 위치를 기반으로 조금씩 이동
      final newPosition =
          LatLng(state!.latitude + 0.01, state!.longitude + 0.01);
      state = newPosition; // Riverpod 상태 업데이트

      // 1초마다 위치를 업데이트
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Future<void> startPositionStream() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('위치 서비스가 비활성화되었습니다.');
      return;
    }

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

    // 위치 스트림 구독
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      final newPosition = LatLng(position.latitude, position.longitude);
      state = newPosition; // Riverpod 상태 업데이트
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
  return PositionNotifier();
});
