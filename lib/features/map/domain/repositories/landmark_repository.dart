import 'package:chat_location/features/map/domain/entities/landmark.dart';

abstract class LandmarkRepository {
  Future<List<Landmark_>> getAllLandmark(double lat, double lon);
  Future<List<Landmark_>> getAvailableLandmark(double lat, double lon);
}
