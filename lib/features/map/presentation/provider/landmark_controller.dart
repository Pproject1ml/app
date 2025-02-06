import 'dart:developer';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/map/data/repositories/landmark_repository_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandmarkListNotifier extends StateNotifier<List<LandmarkInterface>> {
  final LandmarkRepositoryImp landmarkRepository;
  LandmarkListNotifier(this.landmarkRepository) : super([]);

  // 내 위치에서 모든 랜드마크 가져오기
  Future<List<LandmarkInterface>> getAllLandMarkFromServer(
      LatLng currentPosition) async {
    try {
      final res = await landmarkRepository.getAvailableLandmark(
          currentPosition.latitude, currentPosition.longitude);

      final landmarks =
          res.map((v) => LandmarkInterface.fromLandmarkModel(v)).toList();

      state = landmarks;
      return landmarks;
    } catch (e, s) {
      log(e.toString() + s.toString());
      throw "랜드마크 불러오기에 실패하였습니다.";
    }
  }

  /// 랜드마크 추가
  void addLandmark(LandmarkInterface landmark) {
    state = [...state, landmark];
  }

  /// 랜드마크 제거
  void removeLandmark(int id) {
    state = state.where((landmark) => landmark.landmarkId != id).toList();
  }

  /// 랜드마크들 중에 바뀐것 업데이트
  void updateLandmarks(List<LandmarkInterface> updatedLandmarks) {
    final updatedMap = {
      for (var landmark in updatedLandmarks) landmark.landmarkId: landmark
    };

    state = state.map((landmark) {
      return updatedMap[landmark.landmarkId] ?? landmark;
    }).toList();
  }

  /// 랜드마크 업데이트
  void updateLandmark(LandmarkInterface updatedLandmark) {
    state = state.map((landmark) {
      return landmark.landmarkId == updatedLandmark.landmarkId
          ? updatedLandmark
          : landmark;
    }).toList();
  }

  /// 모든 랜드마크 초기화
  void clearLandmarks() {
    state = [];
  }

  List<LandmarkInterface> get() {
    return state;
  }
}

final landmarkListProvider = StateNotifierProvider.autoDispose<
    LandmarkListNotifier, List<LandmarkInterface>>((ref) {
  final landmarkRepository = ref.read(landmarkRepositoryProvider);
  return LandmarkListNotifier(landmarkRepository);
});

// base Url입력하면 됩니다.
final apiClientProvider =
    Provider((ref) => ApiClient(BASE_URL, HTTPS_BASE_URL));

// landmark 관련 provider
final landmarkRepositoryProvider =
    Provider((ref) => LandmarkRepositoryImp(ref.read(apiClientProvider)));
