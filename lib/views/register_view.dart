
import 'package:bulletpoints/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State <RegisterView> createState() =>  RegisterViewState();
}

class  RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(
        title: const Text('Register')
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter Email"
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter Password"
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try{
                final userCredential = await  FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
              }on FirebaseAuthException catch (e){
                //print(e.code);
                switch (e.code){
                  case 'invalid-email':
                    print('invalid-email');
                    break;
                  case 'email-already-in-use':
                    print('email-already-in-use');
                    break;
                  case 'weak-password':
                    print('weak-password');
                    break; 
                }
              }
            },
            child: const Text("Register"),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login/', (route) => 
                false
            );
          }, 
          child: const Text('Already registered? Log in here!'),
        ),
        ],
      ),
    );
  }
}