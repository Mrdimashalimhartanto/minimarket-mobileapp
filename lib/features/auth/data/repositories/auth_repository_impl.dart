import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimarket/bootstrap/providers.dart';
import 'package:minimarket/features/auth/data/models/auth_session.dart';
import 'package:minimarket/features/auth/data/models/google_login_request.dart';

import '../../../../core/storage/secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_api.dart';
import '../models/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._storage);

  final AuthApi _api;
  final SecureStorage _storage;

  @override
  Future<LoginResponse> login(String email, String password) async {
    final res = await _api.login(email: email, password: password);

    // ✅ kalau login langsung return token (tanpa 2FA)
    if ((res.accessToken ?? '').isNotEmpty && !res.otpRequired) {
      await _storage.setAccessToken(res.accessToken!);
      await _storage.setOtpRequired(false);
      return res;
    }

    // ✅ kalau butuh 2FA
    if (res.otpRequired) {
      await _storage.setOtpRequired(true);
    }

    return res;
  }

  // ✅ verify 2FA pakai email + code
  @override
  Future<String> verifyOtp(String email, String code) async {
    final token = await _api.verifyOtp(email: email, code: code);

    await _storage.setAccessToken(token);
    await _storage.setOtpRequired(false);

    return token;
  }

  @override
  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (_) {
      // logout API boleh gagal, tapi clear lokal tetap jalan
    } finally {
      await _storage.clearAll();
    }
  }

  /// ✅ FIX PENTING: simpan access_token hasil login google ke storage
  @override
  Future<AuthSession> loginWithGoogleIdToken(String idToken) async {
    final session = await _api.loginWithGoogle(
      GoogleLoginRequest(idToken: idToken),
    );

    // 🔥 ini yang bikin dashboard 401 kalau ga ada
    if (session.accessToken.isNotEmpty) {
      await _storage.setAccessToken(session.accessToken);
    }

    // google login harusnya ga butuh otp
    await _storage.setOtpRequired(false);

    return session;
  }
}

// Providers
final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApi(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authApiProvider),
    ref.watch(secureStorageProvider),
  );
});
