import 'dart:developer';

import 'package:chat_location/constants/data.dart';
import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/map/data/models/landmark.dart';

import 'package:chat_location/features/map/domain/repositories/landmark_repository.dart';

class LandmarkRepositoryImp implements LandmarkRepository {
  final ApiClient apiClient;

  LandmarkRepositoryImp(this.apiClient);

  @override
  Future<List<LandmarkModel>> getAllLandmark(double lat, double lon) {
    // TODO: implement getAllLandmark
    throw UnimplementedError();
  }

  @override
  Future<List<LandmarkModel>> getAvailableLandmark(
      double lat, double lon) async {
    try {
      final queryParameters = {
        'longitude': lon.toString(),
        'latitude': lat.toString(),
        "radius": (AVAILABLE_RADIUS_M * 1.2).toInt().toString()
      };

      final response = await apiClient.get(
          endpoint: '/landmark', queryParameters: queryParameters);

      final datas = response['data'] as List<dynamic>;

      final List<LandmarkModel> landMarkModels =
          datas.map((json) => LandmarkModel.fromJson(json)).toList();

      return landMarkModels;
    } catch (e, s) {
      log(e.toString() + s.toString());
      return [];
    }
  }
}
