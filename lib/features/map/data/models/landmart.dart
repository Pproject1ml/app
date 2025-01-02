class LandmarkModel {
  final String name; // Corresponds to name (varchar(255))
  final double latitude; // Corresponds to latitude (double)
  final double longitude; // Corresponds to longitude (double)
  final int radius; // Corresponds to radius (int(11))
  final String? imagePath; // Corresponds to image_path (varchar(255))
  final int chatRoomId; // Corresponds to chat_room_id (int(11))

  LandmarkModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.imagePath,
    required this.chatRoomId,
  });

  // Factory constructor for creating a LandmarkModel instance from a JSON object
  factory LandmarkModel.fromJson(Map<String, dynamic> json) {
    return LandmarkModel(
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      radius: json['radius'] as int,
      imagePath: json['imagePath'],
      chatRoomId: json['chatRoomId'] as int,
    );
  }

  // Method for converting a LandmarkModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'imagePath': imagePath,
      'chatRoomId': chatRoomId,
    };
  }
}
