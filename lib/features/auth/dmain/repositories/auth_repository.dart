import 'package:chat_location/features/auth/data/models/oauth.dart';
import 'package:chat_location/features/auth/data/models/signup.dart';

abstract class AuthRepository {
  Future<bool> isNicknameValid(String nickname);
  Future<dynamic> signIn(OauthModel user);
  Future<dynamic> signUp(SignUpModel user);
}
