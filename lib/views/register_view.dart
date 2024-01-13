import 'package:bulletpoints/constants/routes.dart';
import 'package:bulletpoints/services/auth/auth_exceptions.dart';
import 'package:bulletpoints/services/auth/auth_service.dart';
import 'package:bulletpoints/utils/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bulletpoints/constants/globals.dart' as globals;
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
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
              devtools.log("Pressing register button");
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.backend(globals.authProvider)
                    .createUser(email: email, password: password);
                devtools.log("Go to verifyemailview.");
                if (context.mounted) {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
              } on InvalidEmailAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'invalid-email');
                }
              } on EmailAlreadyInUseAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'email-already-in-use');
                }
              } on WeakPasswordAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'weak-password');
                }
              } on GenericAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'Something went wrong.');
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Log in here!'),
          ),
        ],
      ),
    );
  }
}
