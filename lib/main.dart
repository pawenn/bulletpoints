import 'package:bulletpoints/constants/routes.dart';
import 'package:bulletpoints/constants/globals.dart' as globals;
import 'package:bulletpoints/services/auth/auth_service.dart';
import 'package:bulletpoints/views/login_view.dart';
import 'package:bulletpoints/views/notes/create_update_note_view.dart';
import 'package:bulletpoints/views/notes/notes_view.dart';
import 'package:bulletpoints/views/register_view.dart';
import 'package:bulletpoints/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.backend(globals.authProvider).initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.backend(globals.authProvider).currentUser;
            devtools.log("Current user: $user");
            if (user != null) {
              return const NotesView();
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
