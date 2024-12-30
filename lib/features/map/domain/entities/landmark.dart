class Landmark_ {
  final int id; // 랜드마크 고유 ID
  final String name; // 랜드마크 이름
  final double latitude; // 랜드마크의 위도
  final double longitude; // 랜드마크의 경도
  final double radius; // 랜드마크 반경 (미터 단위)
  final DateTime? createdAt; // 생성 일자
  final DateTime? updatedAt; // 업데이트 일자

  Landmark_({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.createdAt,
    this.updatedAt,
  });

  // JSON 변환용 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Landmark_.fromJson(Map<String, dynamic> json) {
    return Landmark_(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      radius: json['radius'] as double,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // copyWith 메서드 추가
  Landmark_ copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    double? radius,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Landmark_(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
