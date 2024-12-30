import 'package:geolocator/geolocator.dart';

/// 특정 위도와 경도에서 반경 100m 이내인지 확인
bool isWithinRadius({
  required double targetLatitude,
  required double targetLongitude,
  required double radius,
  required double currentLatitude,
  required double currentLongitude,
}) {
  // 두 지점 간의 거리 계산
  double distance = Geolocator.distanceBetween(
    currentLatitude,
    currentLongitude,
    targetLatitude,
    targetLongitude,
  );

  // 거리 비교
  return distance <= radius;
}
