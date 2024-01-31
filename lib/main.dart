import 'package:bulletpoints/constants/routes.dart';
import 'package:bulletpoints/services/auth/supabase_auth_provider.dart';
import 'package:bulletpoints/views/login_view.dart';
import 'package:bulletpoints/views/notes/create_update_note_view.dart';
import 'package:bulletpoints/views/notes/notes_view.dart';
import 'package:bulletpoints/views/register_view.dart';
import 'package:bulletpoints/views/verify_email_view.dart';
import 'package:flutter/material.dart';

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
      future: SupabaseAuthProvider.instance().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = SupabaseAuthProvider.instance().currentUser;
            //final email = user?.email;
            //Delete this later, just for testing

            //#########################
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
