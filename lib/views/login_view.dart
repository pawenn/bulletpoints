import 'package:bulletpoints/constants/routes.dart';
import 'package:bulletpoints/services/auth/auth_exceptions.dart';
import 'package:bulletpoints/services/auth/google_auth_provider.dart';
import 'package:bulletpoints/services/auth/supabase_auth_provider.dart';
import 'package:bulletpoints/utils/dialogs/error_dialog.dart';
import 'package:bulletpoints/views/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;

  late final TextEditingController _password;

  late final GoogleAuthProvider _googleAuthProvider;

  @override
  void initState() {
    _googleAuthProvider = GoogleAuthProvider.instance();
    _googleAuthProvider.initialize(SupabaseAuthProvider.instance());
    _setupSupabaseAuthListener();
    _email = TextEditingController();
    _password = TextEditingController();
    //_googleAuthProvider.handleSignOut();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _setupSupabaseAuthListener() {
    devtools.log("Setting up supabaseAuthListner");
    final supabase = Supabase.instance.client;
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      devtools.log("Event happend: $event");
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          notesRoute,
          (_) => false,
        );
      }
    });
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _googleAuthProvider.googleUser;
    if (user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          if (_googleAuthProvider.isAuthorized) ...<Widget>[
            // The user has Authorized all required scopes
            const Text("User is Authorized."),
            ElevatedButton(
              child: const Text('REFRESH'),
              onPressed: () {},
            ),
          ],
          if (_googleAuthProvider.isAuthorized) ...<Widget>[
            // The user has NOT Authorized all required scopes.
            // (Mobile users may never see this button!)
            const Text('Additional permissions needed to read your contacts.'),
            ElevatedButton(
              onPressed: _googleAuthProvider.handleAuthorizeScopes,
              child: const Text('REQUEST PERMISSIONS'),
            ),
          ],
          ElevatedButton(
            onPressed: _googleAuthProvider.handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      // The user is NOT Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          // This method is used to separate mobile from web code with conditional exports.
          // See: src/sign_in_button.dart
          buildSignInButton(
            onPressed: _googleAuthProvider.handleSignIn,
          ),
        ],
      );
    }
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
                await SupabaseAuthProvider.instance()
                    .login(email: email, password: password);
                final user = SupabaseAuthProvider.instance().currentUser;
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
          ElevatedButton(
            onPressed: () async {
              await GoogleAuthProvider.instance().signinWithGoogle();
            },
            child: const Text('Google login'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await SupabaseAuthProvider.instance().loginWithApple();
              } on SupabaseAuthException {
                devtools.log("Error with Apple Login.");
              }
            },
            child: const Text('Apple login'),
          ),
          _buildBody(),
          ElevatedButton(
            onPressed: () {
              String? user = _googleAuthProvider.googleUser?.email;
              bool isAuthorized = _googleAuthProvider.isAuthorized;
              devtools.log("Current User: $user");
              devtools.log("Is Authorized = $isAuthorized");
            },
            child: const Text("Get Current USer"),
          )
        ],
      ),
    );
  }
}
  /* return Scaffold(
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
                await SupabaseAuthProvider.instance()
                    .login(email: email, password: password);
                final user = SupabaseAuthProvider.instance().currentUser;
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
          ElevatedButton(
            onPressed: () async {
              await GoogleAuthProvider.instance().signinWithGoogle();
            },
            child: const Text('Google login'),
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  await SupabaseAuthProvider.instance().loginWithApple();
                } on SupabaseAuthException {
                  devtools.log("Error with Apple Login.");
                }
              },
              child: const Text('Apple login')),
          (GoogleSignInPlatform.instance as GoogleSignInPlugin).renderButton(),
          ElevatedButton(
              onPressed: () async {
                final user =
                    GoogleAuthProvider.instance().googleUser.toString();
                bool isSignedIn =
                    await (GoogleSignInPlatform.instance as GoogleSignInPlugin)
                        .isSignedIn();
                print("Current User: $user");
                print("Is Signed in: $isSignedIn");
              },
              child: const Text('Get current User'))
        ],
      ),
    ); */



