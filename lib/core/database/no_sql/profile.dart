import 'package:chat_location/features/user/data/models/profile.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@HiveType(typeId: 2)
@JsonSerializable() // json_serializable 사용
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String profileId;

  @HiveField(1)
  final String nickname;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? profileImage;

  @HiveField(4)
  final String? introduction;

  @HiveField(5)
  final int? age;

  @HiveField(6)
  final String? gender;

  @HiveField(7)
  final bool isVisible;

  ProfileHiveModel(
      {required this.profileId,
      required this.nickname,
      this.email,
      this.profileImage,
      this.introduction,
      this.age,
      this.gender,
      required this.isVisible});

  factory ProfileHiveModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileHiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileHiveModelToJson(this);
}
