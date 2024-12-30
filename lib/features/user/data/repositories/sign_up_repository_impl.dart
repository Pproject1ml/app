import 'package:chat_location/features/user/domain/repositories/sign_up_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  @override
  Future<bool> isNicknameValid(String nickname) async {
    return true;
  }
}
