import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../models/user.dart';

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  // static const _baseUrl = 'http://localhost:3000/api/v1';
  static const _baseUrl = 'http://10.0.2.2:3000/api/v1';

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _userKey = 'currentUser';

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late final Dio dio = Dio(BaseOptions(baseUrl: _baseUrl));
  GoRouter? router;
  bool _isRefreshing = false;

  void init({GoRouter? appRouter}) {
    router = appRouter;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: _accessTokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && !_isRefreshing) {
            _isRefreshing = true;
            final ok = await _refreshToken();
            _isRefreshing = false;

            if (ok) {
              final token = await storage.read(key: _accessTokenKey);
              final req = error.requestOptions;
              req.headers['Authorization'] = 'Bearer $token';
              final retry = await dio.fetch(req);
              return handler.resolve(retry);
            }

            await clearTokens();
            router?.go('/login');
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await storage.read(key: _refreshTokenKey);
      if (refreshToken == null) return false;

      final tempDio = Dio(BaseOptions(baseUrl: _baseUrl));
      final res = await tempDio
          .post('/auth/refresh', data: {'refreshToken': refreshToken});
      if (res.data['success'] == true) {
        await saveTokens(
          accessToken: res.data['accessToken'],
          refreshToken: res.data['refreshToken'],
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    await storage.write(key: _accessTokenKey, value: accessToken);
    await storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> saveCurrentUser(User user) async {
    await storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<User?> getCurrentUser() async {
    final raw = await storage.read(key: _userKey);
    if (raw == null || raw.isEmpty) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return User.fromJson(map);
  }

  Future<void> clearTokens() async {
    await storage.delete(key: _accessTokenKey);
    await storage.delete(key: _refreshTokenKey);
    await storage.delete(key: _userKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }
}
