// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatRoomHiveModelAdapter extends TypeAdapter<ChatRoomHiveModel> {
  @override
  final int typeId = 1;

  @override
  ChatRoomHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatRoomHiveModel(
      chatroomId: fields[0] as String,
      title: fields[1] as String,
      count: fields[2] as int?,
      profiles: (fields[3] as List).cast<ProfileHiveModel>(),
      lastMessage: fields[4] as String?,
      lastReadMessageId: fields[5] as String?,
      longitude: fields[6] as double,
      latitude: fields[7] as double,
      lastMessageAt: fields[8] as DateTime?,
      imagePath: fields[9] as String?,
      active: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoomHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.chatroomId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.profiles)
      ..writeByte(4)
      ..write(obj.lastMessage)
      ..writeByte(5)
      ..write(obj.lastReadMessageId)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.lastMessageAt)
      ..writeByte(9)
      ..write(obj.imagePath)
      ..writeByte(10)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoomHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomHiveModel _$ChatRoomHiveModelFromJson(Map<String, dynamic> json) =>
    ChatRoomHiveModel(
      chatroomId: json['chatroomId'] as String,
      title: json['title'] as String,
      count: (json['count'] as num?)?.toInt(),
      profiles: (json['profiles'] as List<dynamic>)
          .map((e) => ProfileHiveModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] as String?,
      lastReadMessageId: json['lastReadMessageId'] as String?,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      imagePath: json['imagePath'] as String?,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$ChatRoomHiveModelToJson(ChatRoomHiveModel instance) =>
    <String, dynamic>{
      'chatroomId': instance.chatroomId,
      'title': instance.title,
      'count': instance.count,
      'profiles': instance.profiles,
      'lastMessage': instance.lastMessage,
      'lastReadMessageId': instance.lastReadMessageId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'imagePath': instance.imagePath,
      'active': instance.active,
    };
