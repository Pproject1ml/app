import 'package:chat_location/core/newtwork/api_client.dart';
import 'package:chat_location/features/user/domain/repositories/sign_up_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final ApiClient apiClient;

  SignUpRepositoryImpl(this.apiClient);
  @override
  Future<bool> isNicknameValid(String nickname) async {
    try {
      final Map<String, String> data = {'nickname': nickname};
      await apiClient.post(endpoint: "auth/check-nickname", data: data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
