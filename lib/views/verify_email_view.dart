import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VeriyfyEmailView extends StatefulWidget {
  const VeriyfyEmailView({super.key});

  @override
  State<VeriyfyEmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<VeriyfyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Column(
        children: [
          const Text('Please verify your Email adress.'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              print(user);
              await user?.sendEmailVerification();
            }, 
            child: const Text('Send Email verification.'),
          )
        ],
      ),
    );
  }
}