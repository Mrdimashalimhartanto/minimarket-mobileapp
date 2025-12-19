import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bootstrap/providers.dart';

class RouteGuards {
  static Future<String?> redirect(WidgetRef ref, String location) async {
    final storage = ref.read(secureStorageProvider);

    final token = await storage.getAccessToken();
    final otpRequired = await storage.getOtpRequired();

    final isAuthPages =
        location.startsWith('/login') || location.startsWith('/register');
    final isOtpPage = location.startsWith('/otp');

    // belum login
    if (token == null || token.isEmpty) {
      // kalau lagi di auth pages, biarin
      if (isAuthPages) return null;
      return '/login';
    }

    // sudah login tapi butuh OTP
    if (otpRequired) {
      if (isOtpPage) return null;
      return '/otp';
    }

    // sudah fully auth, jangan balik ke login/register/otp
    if (isAuthPages || isOtpPage) return '/dashboard';

    return null;
  }
}
