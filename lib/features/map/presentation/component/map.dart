import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/controller/location_controller.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/presentation/provider/googl_map_controller.dart';
import 'package:chat_location/features/map/presentation/provider/landmark_controller.dart';
import 'package:chat_location/features/map/presentation/component/refreh_button.dart';
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
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    try {
      _mapStyleString =
          await rootBundle.loadString('assets/json/google_map_dark_mode.json');
    } catch (e) {
      _mapStyleString = '';
    }
  }

  Future<void> _refreshLandmarks(LatLng position) async {
    try {
      final currentPosition =
          ref.read(positionProvider.notifier).getCurrentPosition();
      if (currentPosition == null) throw Exception("현재 위치 정보를 사용할 수 없습니다.");

      ref.read(googleMapStateProvider.notifier).animateCamera(position);
      final landmarks = await ref
          .read(landmarkListProvider.notifier)
          .getAllLandMarkFromServer(currentPosition);

      await ref
          .read(googleMapStateProvider.notifier)
          .updateMarker(landmarks, context);
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  Future<void> _initializeMap(LatLng position) async {
    try {
      final landmarks = await ref
          .read(landmarkListProvider.notifier)
          .getAllLandMarkFromServer(position);

      await ref
          .read(googleMapStateProvider.notifier)
          .updateMarker(landmarks, context);
    } catch (e) {
      showSnackBar(context: context, message: '랜드마크 불러오기에 실패하였습니다.');
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
            ref.read(googleMapStateProvider.notifier).onMapCreated(
                  controller,
                  _mapStyleString,
                  () => _initializeMap(position),
                );
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
              : googleMapState.circle,
        ),
        Positioned(
          bottom: 20,
          left: 12,
          child: RefreshButton(
            onRefresh: () => _refreshLandmarks(position),
          ),
        ),
      ],
    );
  }
}
