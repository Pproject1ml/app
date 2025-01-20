// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileHiveModelAdapter extends TypeAdapter<ProfileHiveModel> {
  @override
  final int typeId = 2;

  @override
  ProfileHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileHiveModel(
      profileId: fields[0] as String,
      nickname: fields[1] as String,
      email: fields[2] as String?,
      profileImage: fields[3] as String?,
      introduction: fields[4] as String?,
      age: fields[5] as int?,
      gender: fields[6] as String?,
      isVisible: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.profileId)
      ..writeByte(1)
      ..write(obj.nickname)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.profileImage)
      ..writeByte(4)
      ..write(obj.introduction)
      ..writeByte(5)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.isVisible);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileHiveModel _$ProfileHiveModelFromJson(Map<String, dynamic> json) =>
    ProfileHiveModel(
      profileId: json['profileId'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      introduction: json['introduction'] as String?,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      isVisible: json['isVisible'] as bool,
    );

Map<String, dynamic> _$ProfileHiveModelToJson(ProfileHiveModel instance) =>
    <String, dynamic>{
      'profileId': instance.profileId,
      'nickname': instance.nickname,
      'email': instance.email,
      'profileImage': instance.profileImage,
      'introduction': instance.introduction,
      'age': instance.age,
      'gender': instance.gender,
      'isVisible': instance.isVisible,
    };
