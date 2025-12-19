import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailC = TextEditingController(text: 'dimas@example.com');
  final passC = TextEditingController(text: 'password123');

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = emailC.text.trim();
    final password = passC.text;

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    final res = await ref
        .read(authControllerProvider.notifier)
        .login(email, password);

    if (res == null) return;
    if (!mounted) return;

    if (res.otpRequired) {
      context.go('/otp');
    } else {
      context.go('/dashboard');
    }
  }

  Future<void> _onGoogleLogin() async {
    if (ref.read(authControllerProvider).loading) return;

    try {
      final session = await ref
          .read(authControllerProvider.notifier)
          .loginWithGoogle();

      // user cancel / gagal
      if (session == null) return;
      if (!mounted) return;

      // ✅ Google login sukses -> langsung dashboard
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal login Google: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final isBusy = state.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !isBusy,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passC,
              obscureText: true,
              textInputAction: TextInputAction.done,
              enabled: !isBusy,
              onSubmitted: (_) => isBusy ? null : _onLogin(),
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),

            if (state.error != null) ...[
              Text(state.error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
            ],

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isBusy ? null : _onLogin,
                child: isBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: isBusy ? null : _onGoogleLogin,
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Continue with Google'),
              ),
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: isBusy ? null : () => context.go('/register'),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
