import 'package:chat_location/features/user/domain/entities/user.dart';
import 'package:chat_location/features/user/domain/repositories/user_repository.dart';

class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  Future<AppUser> call() async {
    return await repository.getUserProfile();
  }
}
