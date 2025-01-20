import 'dart:developer';

import 'package:chat_location/common/utils/is_within_radius.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/controller/location_controller.dart';

import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/presentation/component/chat_list.dart';

import 'package:chat_location/features/map/presentation/component/map.dart';
import 'package:chat_location/features/map/presentation/provider/landmark_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<LandmarkInterface> landmarks = [];

class MapScreen extends ConsumerStatefulWidget {
  static const String routeName = '/map'; // routeName 정의
  static const String pageName = " map";
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      await ref.read(positionProvider.notifier).startPositionStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(positionProvider);
    final landmarks = ref.watch(landmarkListProvider);

    return Scaffold(
      body: Stack(
        children: [
          Map(
            landmarks: landmarks,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: ChatListBox(
                        landmarks: landmarks.where((v) {
                          if (currentPosition == null) {
                            return false;
                          }
                          final _distance = getDistance(
                            currentPosition.latitude,
                            currentPosition.longitude,
                            v.latitude,
                            v.longitude,
                          );

                          final _isWithinRadius = isWithinRadius(
                            _distance,
                            AVAILABLE_RADIUS_M,
                          );

                          return _isWithinRadius;
                        }).toList(),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
