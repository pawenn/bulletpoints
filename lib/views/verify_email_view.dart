import 'package:bulletpoints/constants/routes.dart';
import 'package:bulletpoints/services/auth/supabase_auth_provider.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account."),
          const Text(
              'If you havent recieved a email yet, press the button below.'),
          TextButton(
            onPressed: () async {
              await SupabaseAuthProvider.instance().sendEmailVerification();
            },
            child: const Text('Send Email verification again.'),
          ),
          TextButton(
            onPressed: () async {
              await SupabaseAuthProvider.instance().logOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (_) => false);
              }
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
