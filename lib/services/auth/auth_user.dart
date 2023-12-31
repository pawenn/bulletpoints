import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final bool isEmailverified;
  final String? email;
  const AuthUser({required this.isEmailverified, required this.email});

  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailverified: user.emailVerified,
        email: user.email,
      );
}
