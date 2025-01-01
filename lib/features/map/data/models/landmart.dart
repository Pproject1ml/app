class LandmarkModel {
  final int LandmarkModelId; // Corresponds to chat_room_id (int(11))
  final int radius; // Corresponds to radius (int(11))
  final DateTime createdAt; // Corresponds to created_at (datetime(6))
  final BigInt id; // Corresponds to id (bigint(20) AI PK)
  final DateTime updatedAt; // Corresponds to update_at (datetime(6))
  final String imagePath; // Corresponds to image_path (varchar(255))
  final String latitude; // Corresponds to latitude (varchar(255))
  final String longitude; // Corresponds to longitude (varchar(255))
  final String name; // Corresponds to name (varchar(255))

  LandmarkModel({
    required this.LandmarkModelId,
    required this.radius,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  // Factory constructor for creating a LandmarkModel instance from a JSON object
  factory LandmarkModel.fromJson(Map<String, dynamic> json) {
    return LandmarkModel(
      LandmarkModelId: json['chat_room_id'] as int,
      radius: json['radius'] as int,
      createdAt: DateTime.parse(json['created_at']),
      id: BigInt.parse(json['id'].toString()),
      updatedAt: DateTime.parse(json['update_at']),
      imagePath: json['image_path'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      name: json['name'] as String,
    );
  }

  // Method for converting a LandmarkModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'chat_room_id': LandmarkModelId,
      'radius': radius,
      'created_at': createdAt.toIso8601String(),
      'id': id.toString(),
      'update_at': updatedAt.toIso8601String(),
      'image_path': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }
}
