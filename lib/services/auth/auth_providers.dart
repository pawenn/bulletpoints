import 'package:bulletpoints/services/auth/auth_user.dart';

abstract class CustomAuthProvider {
  AuthUser? get currentUser;

  Future<void> initialize();

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<void> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();
}
