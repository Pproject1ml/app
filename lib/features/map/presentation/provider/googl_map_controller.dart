import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
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
  Map<String, BitmapDescriptor>? cachedLandmarkMarker; // Landmark 마커 캐싱
  GoogleMapStateNotifier() : super(GoogleMapState()) {
    _cacheLandmarkMarker(); // 마커를 미리 캐싱
  }
  // 지도가 build 되고 해당 함수가 실행. 이후 _controller 할당
  Future<void> onMapCreated(
    GoogleMapController controller,
    String? mapStyle,
    Future<void> Function() callback,
  ) async {
    _controller = controller;
    if (mapStyle != null) {
      _controller.setMapStyle(mapStyle);
    }
    await callback();
  }

  Future<void> _cacheLandmarkMarker() async {
    final _smallMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/marker_s.png',
      width: widthRatio(10),
      height: widthRatio(10),
    );
    final _mediumMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/marker_m.png',
      width: widthRatio(20),
      height: widthRatio(20),
    );
    final _largeMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/marker_l.png',
      width: widthRatio(30),
      height: widthRatio(30),
    );
    final _xlargeMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/marker_xl.png',
      width: widthRatio(35),
      height: widthRatio(35),
    );
    final _xxlargeMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/marker_xxl.png',
      width: widthRatio(40),
      height: widthRatio(40),
    );
    final _defaultMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/marker_s.png',
      width: widthRatio(10),
      height: widthRatio(10),
    );
    final _customMarkers = {
      'default': _defaultMarker,
      's': _smallMarker,
      'm': _mediumMarker,
      'l': _largeMarker,
      'xl': _xlargeMarker,
      'xxl': _xxlargeMarker
    };
    cachedLandmarkMarker = _customMarkers;
  }

  Future<Set<Marker>> _createCustomMarker({
    required List<LandmarkInterface> datas,
    required BuildContext context,
  }) async {
    Set<Marker> _markers = {};

    for (final data in datas) {
      // final markerIcon = await createLandmarkMarkers();

      BitmapDescriptor? _marker;
      try {
        final _count = data.chatroom?.count ?? 0;
        if (_count > 500) {
          _marker = cachedLandmarkMarker!['xxl'];
        } else if (_count > 100) {
          _marker = cachedLandmarkMarker!['xxl'];
        } else if (_count > 20) {
          _marker = cachedLandmarkMarker!['xl'];
        } else if (_count > 0) {
          _marker = cachedLandmarkMarker!['l'];
        } else {
          _marker = cachedLandmarkMarker!['m'];
        }
      } catch (e, s) {
        _marker = cachedLandmarkMarker!['default'];
      }
      _markers.add(
        Marker(
            markerId: MarkerId(data.landmarkId.toString()),
            position: LatLng(data.latitude, data.longitude),
            icon: _marker!,
            onTap: () {
              landmarkDialog(context, data, null);
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
      final newCircles = createCircle(currentLocation);

      // 상태를 업데이트
      state = state.copyWith(circle: newCircles);

      // 지도 중심을 이동
      // _controller.animateCamera(
      //   CameraUpdate.newLatLng(currentLocation),
      // );
    } else {}
  }

  Future<void> updateMarker(
      List<LandmarkInterface> landmarkData, BuildContext context) async {
    try {
      final _markers =
          await _createCustomMarker(context: context, datas: landmarkData);
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
      CameraUpdate.newLatLngZoom(position, 13),
    );
  }
}

final googleMapStateProvider =
    StateNotifierProvider<GoogleMapStateNotifier, GoogleMapState>(
  (ref) {
    return GoogleMapStateNotifier();
  },
);

// 현재 위치 정보 받아와야함
