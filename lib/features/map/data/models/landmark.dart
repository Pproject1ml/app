import 'dart:developer';

import 'package:chat_location/features/chat/data/model/chatroom.dart';

class LandmarkModel {
  final String landmarkId;
  final String name;
  final double latitude;
  final double longitude;
  final int radius;
  final String? imagePath;
  final ChatRoomModel? chatroom;

  LandmarkModel(
      {required this.landmarkId,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.radius,
      this.imagePath,
      this.chatroom});

  // Factory constructor for creating a LandmarkModel instance from a JSON object
  factory LandmarkModel.fromJson(Map<String, dynamic> json) {
    return LandmarkModel(
        landmarkId: json['landmarkId'] as String,
        name: json['name'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        radius: json['radius'] as int,
        imagePath: json['imagePath'] as String?,
        chatroom: json['chatroom'] != null
            ? ChatRoomModel.fromJson(json['chatroom'] as Map<String, dynamic>)
            : null);
  }

  // Method for converting a LandmarkModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      "landmarkId": landmarkId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'imagePath': imagePath,
      'chatroom': chatroom?.toJson()
    };
  }
}
