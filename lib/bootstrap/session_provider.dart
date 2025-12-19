import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/secure_storage.dart';
import 'providers.dart';

enum SessionStatus {
  unknown,
  unauthenticated,
  otpRequired,
  authenticated,
}

class AuthSessionState {
  final SessionStatus status;

  const AuthSessionState(this.status);

  bool get isLoading => status == SessionStatus.unknown;
}

class AuthSessionNotifier extends Notifier<AuthSessionState> {
  SecureStorage get _storage => ref.read(secureStorageProvider);

  @override
  AuthSessionState build() {
    // awalnya unknown, lalu load dari storage
    _load();
    return const AuthSessionState(SessionStatus.unknown);
  }

  Future<void> _load() async {
    final token = await _storage.getAccessToken();
    final otpRequired = await _storage.getOtpRequired();

    if (token == null || token.isEmpty) {
      state = const AuthSessionState(SessionStatus.unauthenticated);
      return;
    }

    if (otpRequired) {
      state = const AuthSessionState(SessionStatus.otpRequired);
      return;
    }

    state = const AuthSessionState(SessionStatus.authenticated);
  }

  Future<void> refresh() => _load();

  Future<void> setAuthenticated() async {
    await _storage.setOtpRequired(false);
    state = const AuthSessionState(SessionStatus.authenticated);
  }

  Future<void> setOtpRequired() async {
    await _storage.setOtpRequired(true);
    state = const AuthSessionState(SessionStatus.otpRequired);
  }

  Future<void> logout() async {
    await _storage.clearAll();
    state = const AuthSessionState(SessionStatus.unauthenticated);
  }
}

final authSessionProvider =
    NotifierProvider<AuthSessionNotifier, AuthSessionState>(() => AuthSessionNotifier());
