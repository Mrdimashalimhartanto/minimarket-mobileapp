import 'package:dio/dio.dart';
import 'package:minimarket/features/auth/data/models/auth_session.dart';
import 'package:minimarket/features/auth/data/models/google_login_request.dart';
import 'package:minimarket/features/auth/data/models/login_response.dart';
import '../../../../core/config/endpoints.dart';

class AuthApi {
  AuthApi(this._dio);
  final Dio _dio;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      Endpoints.login,
      data: {'email': email, 'password': password},
    );

    final raw = res.data;
    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    final rawPayload = map['data'];
    final payload = (rawPayload is Map)
        ? Map<String, dynamic>.from(rawPayload)
        : <String, dynamic>{};

    return LoginResponse.fromJson(payload);
  }

  Future<void> logout() async {
    await _dio.post(Endpoints.logout);
  }

  Future<String> verifyOtp({
    required String email,
    required String code,
  }) async {
    final res = await _dio.post(
      Endpoints.login2faVerify,
      data: {'email': email, 'code': code},
    );

    final raw = res.data;
    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    final rawData = map['data'];
    final data = (rawData is Map) ? Map<String, dynamic>.from(rawData) : map;

    final token = (data['access_token'] ?? data['token']) as String?;

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan dari response 2FA');
    }

    return token;
  }

  // Google
  Future<AuthSession> loginWithGoogle(GoogleLoginRequest req) async {
    final res = await _dio.post(Endpoints.googleLogin, data: req.toJson());
    final raw = res.data;

    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    return AuthSession.fromJson(map);
  }
}
