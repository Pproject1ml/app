import 'package:chat_location/common/utils/is_within_radius.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/controller/location_controller.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/presentation/component/available_landmark_list.dart';
import 'package:chat_location/features/map/presentation/component/map.dart';
import 'package:chat_location/features/map/presentation/provider/landmark_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapScreen extends ConsumerStatefulWidget {
  static const String routeName = '/map';
  static const String pageName = "Map";

  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
    _startPositionStream();
  }

  Future<void> _startPositionStream() async {
    await ref.read(positionProvider.notifier).startPositionStream();
  }

  List<LandmarkInterface> _filterLandmarks(
      List<LandmarkInterface> landmarks, dynamic currentPosition) {
    if (currentPosition == null) {
      return [];
    }

    return landmarks.where((landmark) {
      final distance = getDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        landmark.latitude,
        landmark.longitude,
      );
      return isWithinRadius(distance, AVAILABLE_RADIUS_M);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(positionProvider);
    final landmarks = ref.watch(landmarkListProvider);

    final filteredLandmarks = _filterLandmarks(landmarks, currentPosition);

    return Scaffold(
      body: Stack(
        children: [
          Map(landmarks: landmarks),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widthRatio(16),
                vertical: heightRatio(12),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: AvailableLandmarks(landmarks: filteredLandmarks),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
