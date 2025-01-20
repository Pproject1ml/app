import 'dart:math';
import 'dart:developer' as dev;

double getDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const double earthRadiusKm = 6371.0;

  final double lat1Rad = lat1 * pi / 180;
  final double lon1Rad = lon1 * pi / 180;
  final double lat2Rad = lat2 * pi / 180;
  final double lon2Rad = lon2 * pi / 180;

  final double deltaLat = lat2Rad - lat1Rad;
  final double deltaLon = lon2Rad - lon1Rad;

  final double a = pow(sin(deltaLat / 2), 2) +
      cos(lat1Rad) * cos(lat2Rad) * pow(sin(deltaLon / 2), 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  final double distanceKm = earthRadiusKm * c;
  final double distanceMeters = distanceKm * 1000; // km를 m로 변환
  return distanceMeters;
}

bool isWithinRadius(double distanceMeter, double radiusMeters) {
  return distanceMeter <= radiusMeters; // 거리 비교
}
