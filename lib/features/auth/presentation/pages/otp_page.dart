import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_controller.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final emailC = TextEditingController(text: 'email@example.com');
  final codeC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    codeC.dispose();
    super.dispose();
  }

  Future<void> _onVerify() async {
    final email = emailC.text.trim();
    final code = codeC.text.trim();

    if (email.isEmpty || code.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan code wajib diisi')),
      );
      return;
    }

    final ok = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(email, code);

    if (ok && mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verify 2FA')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Masukkan Email & Code (2FA) dari backend'),
            const SizedBox(height: 12),

            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 12),

            TextField(
              controller: codeC,
              decoration: const InputDecoration(labelText: 'Code (OTP)'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => state.loading ? null : _onVerify(),
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
                onPressed: state.loading ? null : _onVerify,
                child: state.loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
