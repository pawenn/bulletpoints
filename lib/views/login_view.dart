import 'package:bulletpoints/constants/routes.dart';
import 'package:bulletpoints/services/auth/auth_exceptions.dart';
import 'package:bulletpoints/services/auth/auth_service.dart';
import 'package:bulletpoints/utils/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:bulletpoints/constants/globals.dart' as globals;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter Email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter Password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.backend(globals.authProvider)
                    .login(email: email, password: password);
                final user =
                    AuthService.backend(globals.authProvider).currentUser;
                if (context.mounted && (user?.isEmailverified ?? false)) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (_) => false,
                  );
                } else if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (_) => false,
                  );
                }
              } on InvalidCredentialAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'invalid-credential');
                }
              } on InvalidEmailAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'invalid-email');
                }
              } on GenericAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'Authentication error');
                }
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
