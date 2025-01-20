import 'package:chat_location/features/map/data/models/landmark.dart';

abstract class LandmarkRepository {
  Future<List<LandmarkModel>> getAllLandmark(double lat, double lon);
  Future<List<LandmarkModel>> getAvailableLandmark(double lat, double lon);
}
