// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../bootstrap/session_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/dashboard/dashboard_page.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this.ref) {
    // setiap authSession berubah -> refresh router
    ref.listen<AuthSessionState>(
      authSessionProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref ref;
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final session = ref.read(authSessionProvider);
      final loc = state.uri.toString();

      final isAuthPages =
          loc.startsWith('/login') || loc.startsWith('/register');
      final isOtpPage = loc.startsWith('/otp');

      // tunggu status kebaca dari storage
      if (session.isLoading) return null;

      // belum login
      if (session.status == SessionStatus.unauthenticated) {
        return isAuthPages ? null : '/login';
      }

      // butuh otp
      if (session.status == SessionStatus.otpRequired) {
        return isOtpPage ? null : '/otp';
      }

      // sudah authenticated
      if (session.status == SessionStatus.authenticated) {
        if (isAuthPages || isOtpPage) return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/otp', builder: (_, __) => const OtpPage()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
    ],
  );
});
