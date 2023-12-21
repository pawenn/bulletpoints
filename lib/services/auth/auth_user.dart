import 'package:firebase_auth/firebase_auth.dart' show User;
  
class AuthUser {
  final bool isEmailverified;
  const AuthUser(this.isEmailverified);
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
