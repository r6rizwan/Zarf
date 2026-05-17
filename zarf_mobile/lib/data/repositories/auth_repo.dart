import '../models/user.dart';
import '../services/api_service.dart';

class AuthRepo {
  final api = ApiService.instance;

  Future<User> login(String email, String password) async {
    final res = await api.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    await api.saveTokens(
      accessToken: res.data['accessToken'],
      refreshToken: res.data['refreshToken'],
    );

    final user = User.fromJson(res.data['user']);
    await api.saveCurrentUser(user);
    return user;
  }

  Future<void> logout() => api.clearTokens();
}
