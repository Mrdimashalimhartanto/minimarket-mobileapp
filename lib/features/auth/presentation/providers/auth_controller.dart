import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimarket/bootstrap/providers.dart';
import 'package:minimarket/features/auth/data/models/auth_session.dart';

import '../../../../bootstrap/session_provider.dart';
import '../../data/models/login_response.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthState {
  final bool loading;
  final String? error;
  final bool otpRequired;

  const AuthState({this.loading = false, this.error, this.otpRequired = false});

  AuthState copyWith({bool? loading, String? error, bool? otpRequired}) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
      otpRequired: otpRequired ?? this.otpRequired,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  // ✅ ambil google service dari provider
  // Pastikan provider ini ada di bootstrap/providers.dart:
  // final googleSignInServiceProvider = Provider<GoogleSignInService>((ref) => GoogleSignInService(...));
  get _google => ref.read(googleSignInServiceProvider);

  Future<LoginResponse?> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final res = await _repo.login(email, password);

      if (res.otpRequired) {
        await ref.read(authSessionProvider.notifier).setOtpRequired();
      } else if ((res.accessToken ?? '').isNotEmpty) {
        await ref.read(authSessionProvider.notifier).setAuthenticated();
      } else {
        // fallback
        await ref.read(authSessionProvider.notifier).refresh();
      }

      state = state.copyWith(loading: false, otpRequired: res.otpRequired);
      return res;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return null;
    }
  }

  Future<bool> verifyOtp(String email, String code) async {
    state = state.copyWith(loading: true, error: null);

    try {
      await _repo.verifyOtp(email, code);

      await ref.read(authSessionProvider.notifier).refresh();

      state = state.copyWith(loading: false, otpRequired: false);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  /// ✅ Google Sign-In:
  /// - ambil idToken dari Google
  /// - tukar ke Laravel (/api/v1/auth/google) via repo.loginWithGoogleIdToken
  /// - set authenticated di session provider
  Future<AuthSession?> loginWithGoogle() async {
    if (state.loading) return null;

    state = state.copyWith(loading: true, error: null);

    try {
      final idToken = await _google.getIdToken();

      // user cancel / token kosong
      if (idToken == null || idToken.isEmpty) {
        state = state.copyWith(loading: false);
        return null;
      }

      final session = await _repo.loginWithGoogleIdToken(idToken);

      // Google login normalnya ga pake OTP
      await ref.read(authSessionProvider.notifier).setAuthenticated();

      state = state.copyWith(loading: false, otpRequired: false, error: null);
      return session;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _repo.logout();
    } finally {
      await ref.read(authSessionProvider.notifier).logout();
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  () => AuthController(),
);
