import 'package:chat_location/features/map/domain/entities/landmark.dart';

class ChatRoomInterface {
  final int id; // 채팅방 고유 ID
  final LandmarkInterface landmark; // 랜드마크 객체
  final String title; // 채팅방 이름
  final DateTime? createdAt; // 생성 일자
  final DateTime? updatedAt; // 업데이트 일자

  ChatRoomInterface({
    required this.id,
    required this.landmark,
    required this.title,
    this.createdAt,
    this.updatedAt,
  });

  // JSON 변환용 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'landmark': landmark.toJson(),
      'title': title,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ChatRoomInterface.fromJson(Map<String, dynamic> json) {
    return ChatRoomInterface(
      id: json['id'] as int,
      landmark:
          LandmarkInterface.fromJson(json['landmark'] as Map<String, dynamic>),
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // copyWith 메서드 추가
  ChatRoomInterface copyWith({
    int? id,
    LandmarkInterface? landmark,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatRoomInterface(
      id: id ?? this.id,
      landmark: landmark ?? this.landmark,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
