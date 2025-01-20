// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageHiveModelAdapter extends TypeAdapter<ChatMessageHiveModel> {
  @override
  final int typeId = 0;

  @override
  ChatMessageHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageHiveModel(
      messageId: fields[0] as String,
      chatRoomId: fields[1] as String,
      profileId: fields[2] as String,
      content: fields[3] as String,
      messageType: fields[4] as String,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.chatRoomId)
      ..writeByte(2)
      ..write(obj.profileId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.messageType)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageHiveModel _$ChatMessageHiveModelFromJson(
        Map<String, dynamic> json) =>
    ChatMessageHiveModel(
      messageId: json['messageId'] as String,
      chatRoomId: json['chatRoomId'] as String,
      profileId: json['profileId'] as String,
      content: json['content'] as String,
      messageType: json['messageType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChatMessageHiveModelToJson(
        ChatMessageHiveModel instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'chatRoomId': instance.chatRoomId,
      'profileId': instance.profileId,
      'content': instance.content,
      'messageType': instance.messageType,
      'createdAt': instance.createdAt.toIso8601String(),
    };
