import 'package:chat_location/features/user/data/models/member.dart';
import 'package:chat_location/features/user/data/models/profile.dart';

abstract class UserRepository {
  Future<MemeberModel> getUserProfile();
  Future<void> updateUser(ProfileModel user);
  Future<void> fetchUser();
  Future<void> fetchRoomList();
}
