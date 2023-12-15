import 'package:bulletpoints/firebase_options.dart';
import 'package:bulletpoints/views/login_view.dart';
import 'package:bulletpoints/views/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/' : (context) => const RegisterView(),
      },
    )
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done: 
              /* final user = FirebaseAuth.instance.currentUser;
              print(user);
              if (user?.emailVerified ?? false){
                return const Text('Done.');
              }else{
                return const VeriyfyEmailView();
              } */
              return const LoginView();
            default:
              return const CircularProgressIndicator(); 

          }
           
        },
      );
  }
}

