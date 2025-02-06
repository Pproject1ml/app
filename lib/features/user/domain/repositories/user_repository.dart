import 'package:chat_location/features/user/data/models/profile.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Future<ProfileModel> getUserProfile();
  Future<void> updateUser({required ProfileModel user, XFile? profileImage});
  Future<void> fetchUser();
  Future<void> fetchRoomList();
}
