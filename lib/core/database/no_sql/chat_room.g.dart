// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatRoomAdapter extends TypeAdapter<ChatRoom> {
  @override
  final int typeId = 1;

  @override
  ChatRoom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatRoom(
      chatroomId: fields[0] as String,
      title: fields[1] as String,
      members: (fields[2] as List).cast<ProfileModel>(),
      lastMessage: fields[3] as String,
      lastReadMessageId: fields[4] as String,
      updatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoom obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.chatroomId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.members)
      ..writeByte(3)
      ..write(obj.lastMessage)
      ..writeByte(4)
      ..write(obj.lastReadMessageId)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      chatroomId: json['chatroomId'] as String,
      title: json['title'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] as String,
      lastReadMessageId: json['lastReadMessageId'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'chatroomId': instance.chatroomId,
      'title': instance.title,
      'members': instance.members,
      'lastMessage': instance.lastMessage,
      'lastReadMessageId': instance.lastReadMessageId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
