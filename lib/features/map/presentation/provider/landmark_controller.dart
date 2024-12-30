import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/map/data/repositories/landmark_repository_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';

class LandmarkListNotifier extends StateNotifier<List<Landmark_>> {
  final LandmarkRepositoryImp landmarkRepository;
  LandmarkListNotifier(this.landmarkRepository) : super([]);

  // 내 위치에서 모든 랜드마크 가져오기
  Future<void> getAllLandMarkFromServer(
      {required double currentLat, required double currentLon}) async {}

  // 내 위치에서 접근 가능한 랜드마크 서버에서 가져오기
  Future<void> getAvailableLangMarkFromServer(
      {required double currentLat, required double currentLon}) async {}

  // 현재 State에서 접근 가능한 landMark 가져오기
  void getAvailableLandMark() {}

  // 채팅방에 들어가기전 현재 위치와 채팅방 위치를 비교해 들어갈 수 있는지 확인
  bool isAvailableLandmark(
      {required Landmark_ target,
      required double currentLat,
      required double currentLon}) {
    // isWithinRadius
    return false;
  }

  /// 랜드마크 추가
  void addLandmark(Landmark_ landmark) {
    state = [...state, landmark];
  }

  /// 랜드마크 제거
  void removeLandmark(int id) {
    state = state.where((landmark) => landmark.id != id).toList();
  }

  /// 랜드마크 업데이트
  void updateLandmark(Landmark_ updatedLandmark) {
    state = state.map((landmark) {
      return landmark.id == updatedLandmark.id ? updatedLandmark : landmark;
    }).toList();
  }

  /// 모든 랜드마크 초기화
  void clearLandmarks() {
    state = [];
  }

  /// 특정 랜드마크 가져오기
  Landmark_? getLandmarkById(int id) {
    // return state.firstWhere((landmark) => landmark.id == id,
    //     orElse: () => null);
  }
}

final landmarkListProvider =
    StateNotifierProvider.autoDispose<LandmarkListNotifier, List<Landmark_>>(
        (ref) {
  final landmarkRepository = ref.read(landmarkRepositoryProvider);
  return LandmarkListNotifier(landmarkRepository);
});

// base Url입력하면 됩니다.
final apiClientProvider =
    Provider((ref) => ApiClient("http://192.168.0.11:8080/"));

// landmark 관련 provider
final landmarkRepositoryProvider =
    Provider((ref) => LandmarkRepositoryImp(ref.read(apiClientProvider)));
