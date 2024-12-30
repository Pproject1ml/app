import '../entities/user.dart';

abstract class UserRepository {
  Future<AppUser> getUserProfile();
  Future<void> updateUser(AppUser user);
  Future<AppUser?> signIn(Map<String, dynamic> body);
  Future<AppUser> signUp(Map<String, dynamic> body);
}
