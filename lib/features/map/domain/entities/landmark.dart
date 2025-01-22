import 'package:chat_location/features/chat/domain/entities/chatroom.dart';
import 'package:chat_location/features/map/data/models/landmark.dart';

class LandmarkInterface {
  final String landmarkId;
  final String name; // 랜드마크 이름
  final double latitude; // 랜드마크의 위도
  final double longitude; // 랜드마크의 경도
  final int radius; // 랜드마크 반경 (미터 단위)
  final String? imagePath;
  final ChatRoomInterface? chatroom;
  final String? address;
  LandmarkInterface(
      {required this.landmarkId,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.radius,
      this.imagePath,
      this.chatroom,
      this.address});

  factory LandmarkInterface.fromLandmarkModel(LandmarkModel data) {
    return LandmarkInterface(
        landmarkId: data.landmarkId,
        name: data.name,
        latitude: data.latitude,
        longitude: data.longitude,
        radius: data.radius,
        imagePath: data.imagePath,
        chatroom: data.chatroom != null
            ? ChatRoomInterface.fromChatRoomModel(data.chatroom!)
            : null,
        address: data.address);
  }
  // copyWith 메서드 추가
  LandmarkInterface copyWith(
      {String? landmarkId,
      String? name,
      double? latitude,
      double? longitude,
      int? radius,
      String? imagePath,
      ChatRoomInterface? chatroom,
      String? address}) {
    return LandmarkInterface(
        landmarkId: landmarkId ?? this.landmarkId,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        radius: radius ?? this.radius,
        imagePath: imagePath ?? this.imagePath,
        chatroom: chatroom ?? this.chatroom,
        address: address ?? this.address);
  }
}
