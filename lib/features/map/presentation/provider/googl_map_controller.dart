import 'dart:developer';

import 'package:chat_location/common/dialog/landmark_dialog.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/utils/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapState {
  final Set<Circle> circle;
  final Set<Marker> markers;
  GoogleMapState({this.markers = const {}, this.circle = const {}});
  GoogleMapState copyWith({
    Set<Circle>? circle,
    Set<Marker>? markers,
  }) {
    return GoogleMapState(
      circle: circle ?? this.circle,
      markers: markers ?? this.markers,
    );
  }
}

class GoogleMapStateNotifier extends StateNotifier<GoogleMapState> {
  BitmapDescriptor userMarker = BitmapDescriptor.defaultMarker;
  late GoogleMapController _controller;
  GoogleMapStateNotifier() : super(GoogleMapState());
  // 지도가 build 되고 해당 함수가 실행. 이후 _controller 할당
  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    log("on Map created 로 인한 요금제 추가됨");
  }

  Future<Set<Marker>> _createCustomMarker(List<LandmarkInterface> datas) async {
    Set<Marker> _markers = {};

    log("custom marker");
    for (final data in datas) {
      final markerIcon = await createLandmarkMarkers();
      _markers.add(
        Marker(
            markerId: MarkerId(data.id.toString()),
            position: LatLng(data.latitude, data.longitude),
            icon: markerIcon,
            // infoWindow: InfoWindow(title: data['name'] as String),
            onTap: () {
              // landmarkDialog(context, data);
            }),
      );
    }
    return _markers;
  }

  Set<Circle> getCircle(LatLng position) {
    updateCircle(position);
    return state.circle;
  }

  void updateCircle(LatLng currentLocation) {
    if (_controller != null) {
      log("update");

      final newCircles = createCircle(currentLocation);

      // 상태를 업데이트
      state = state.copyWith(circle: newCircles);

      // 지도 중심을 이동
      _controller.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
    } else {
      log("no controller");
    }
  }

  Future<void> updateMarker(List<LandmarkInterface> landmarkData) async {
    try {
      final _markers = await _createCustomMarker(landmarkData);
      state = state.copyWith(markers: _markers);
    } catch (e) {
      throw "지도에 마커를 표시할 수 없습니다.";
    }
  }

  void _createUserCustomMarker() {
    BitmapDescriptor.asset(
            const ImageConfiguration(), "assets/images/user_marker.png",
            height: heightRatio(71.12), width: widthRatio(53))
        .then((icon) {
      userMarker = icon;
    });
  }

  void animateCamera(LatLng position) {
    _controller.animateCamera(
      CameraUpdate.newLatLngZoom(position, 12),
    );
  }
}

final googleMapStateProvider =
    StateNotifierProvider<GoogleMapStateNotifier, GoogleMapState>(
  (ref) {
    log('google Map provider init');
    return GoogleMapStateNotifier();
  },
);

// 현재 위치 정보 받아와야함
