import 'package:minimarket/features/auth/data/models/auth_session.dart';

import '../../data/models/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<String> verifyOtp(String email, String code); // ✅ FIX
  Future<void> logout();
  Future<AuthSession> loginWithGoogleIdToken(String idToken);
}