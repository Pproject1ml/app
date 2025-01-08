import 'dart:developer';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/map/data/repositories/landmark_repository_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandmarkListNotifier extends StateNotifier<List<LandmarkInterface>> {
  final LandmarkRepositoryImp landmarkRepository;
  LandmarkListNotifier(this.landmarkRepository)
      : super([
          LandmarkInterface(
              id: 0,
              name: "경복궁",
              latitude: 37.579617,
              longitude: 126.977041,
              radius: 10),
          LandmarkInterface(
              id: 1,
              name: "남산타워",
              latitude: 37.5511694,
              longitude: 126.9882266,
              radius: 10),
          LandmarkInterface(
              id: 2,
              name: "덕수궁",
              latitude: 37.5658049,
              longitude: 126.9751461,
              radius: 10),
        ]);

  // 내 위치에서 모든 랜드마크 가져오기
  Future<void> getAllLandMarkFromServer({LatLng? currentPosition}) async {
    log("get all current Position");
    await Future.delayed(Duration(seconds: 5));
    LandmarkInterface tmp = state[state.length - 1].copyWith(
        latitude: state[state.length - 1].latitude + 100,
        longitude: state[state.length - 1].longitude + 10);
    state = [...state, tmp];
    log(tmp.latitude.toString());
  }

  // 내 위치에서 접근 가능한 랜드마크 서버에서 가져오기
  Future<void> getAvailableLangMarkFromServer({LatLng? position}) async {
    try {
      await landmarkRepository.getAvailableLandmark(
          position!.latitude, position!.longitude);
    } catch (e) {
      throw e;
    }
  }

  // 현재 State에서 접근 가능한 landMark 가져오기
  void getAvailableLandMark() {}

  // 채팅방에 들어가기전 현재 위치와 채팅방 위치를 비교해 들어갈 수 있는지 확인
  bool isAvailableLandmark(
      {required LandmarkInterface target,
      required double currentLat,
      required double currentLon}) {
    // isWithinRadius
    return false;
  }

  /// 랜드마크 추가
  void addLandmark(LandmarkInterface landmark) {
    state = [...state, landmark];
  }

  /// 랜드마크 제거
  void removeLandmark(int id) {
    state = state.where((landmark) => landmark.id != id).toList();
  }

  /// 랜드마크 업데이트
  void updateLandmark(LandmarkInterface updatedLandmark) {
    state = state.map((landmark) {
      return landmark.id == updatedLandmark.id ? updatedLandmark : landmark;
    }).toList();
  }

  /// 모든 랜드마크 초기화
  void clearLandmarks() {
    state = [];
  }

  /// 특정 랜드마크 가져오기
  LandmarkInterface? getLandmarkById(int id) {
    // return state.firstWhere((landmark) => landmark.id == id,
    //     orElse: () => null);
  }
}

final landmarkListProvider = StateNotifierProvider.autoDispose<
    LandmarkListNotifier, List<LandmarkInterface>>((ref) {
  final landmarkRepository = ref.read(landmarkRepositoryProvider);
  return LandmarkListNotifier(landmarkRepository);
});

// base Url입력하면 됩니다.
final apiClientProvider = Provider((ref) => ApiClient(BASE_URL));

// landmark 관련 provider
final landmarkRepositoryProvider =
    Provider((ref) => LandmarkRepositoryImp(ref.read(apiClientProvider)));
