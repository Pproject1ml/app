import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/map/domain/entities/landmark.dart';
import 'package:chat_location/features/map/domain/repositories/landmark_repository.dart';

class LandmarkRepositoryImp implements LandmarkRepository {
  final ApiClient apiClient;

  LandmarkRepositoryImp(this.apiClient);

  @override
  Future<List<Landmark_>> getAllLandmark(double lat, double lon) {
    // TODO: implement getAllLandmark
    throw UnimplementedError();
  }

  @override
  Future<List<Landmark_>> getAvailableLandmark(double lat, double lon) {
    // TODO: implement getAvailableLandmark
    throw UnimplementedError();
  }
}
