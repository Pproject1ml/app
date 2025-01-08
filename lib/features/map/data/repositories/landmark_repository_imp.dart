import 'dart:developer';

import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/map/data/models/landmart.dart';

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
      log("$lat, $lon");
      final queryParameters = {
        'longitude': lon.toString(),
        'latitude': lat.toString(),
        "radius": 5000.toString()
      };

      final response = await apiClient.get(
          endpoint: '/landmark', queryParameters: queryParameters);
      final datas = response['data'];

      final landMarkModels = datas.map((json) => LandmarkModel.fromJson(json));

      return landMarkModels;
    } catch (e) {
      log(e.toString());
      throw '랜드마크를 불러오는데 실패하였습니다';
    }
  }
}
