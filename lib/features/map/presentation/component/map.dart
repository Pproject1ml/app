import 'dart:async';
import 'package:chat_location/common/dialog/landmark_dialog.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/controller/location_controller.dart';
import 'package:chat_location/features/map/domain/entities/chat_room.dart';

import 'package:chat_location/features/map/utils/map_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends ConsumerStatefulWidget {
  const Map({super.key, required this.landmarks});
  final List<ChatRoom_> landmarks;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoogleMapState();
}

class _GoogleMapState extends ConsumerState<Map> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  BitmapDescriptor userMarker = BitmapDescriptor.defaultMarker;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
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
    _createUserCustomMarker();
    _createCustomMarker();
    super.initState();
  }

  void _createCustomMarker() async {
    Set<Marker> markers = {};

    for (var data in widget.landmarks) {
      final markerIcon = await createLandmarkMarkers();

      markers.add(
        Marker(
            markerId: MarkerId(data.id.toString()),
            position: LatLng(data.landmark.latitude, data.landmark.longitude),
            icon: markerIcon,
            // infoWindow: InfoWindow(title: data['name'] as String),
            onTap: () {
              landmarkDialog(context, data);
            }),
      );
    }
    setState(() {
      _markers = markers; // 상태 업데이트
    });
  }

  void _createUserCustomMarker() {
    BitmapDescriptor.asset(
            const ImageConfiguration(), "assets/images/user_marker.png",
            height: heightRatio(71.12), width: widthRatio(53))
        .then((icon) {
      setState(() {
        userMarker = icon;
      });
    });
  }

  void _setCircle(currentPosition) {
    setState(() {
      _circles = createCircle(currentPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController? mapController;
    void onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    final currentPosition = ref.watch(positionProvider);
    if (currentPosition == null) {
      return const CircularProgressIndicator();
    }
    _setCircle(currentPosition);
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: currentPosition,
        zoom: 15.0,
      ),
      myLocationButtonEnabled: true,
      circles: _circles, // 원 추가
      markers: {
        ..._markers,
        Marker(
            markerId: MarkerId('currentLocation'),
            position: currentPosition,
            icon: userMarker),
      },
      // style: _mapStyleString,
    );
  }
}
