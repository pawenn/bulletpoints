import 'package:bulletpoints/services/auth/auth_providers.dart';
import 'package:bulletpoints/services/auth/auth_user.dart';
import 'package:bulletpoints/services/auth/firebase_auth_provider.dart';
import 'package:bulletpoints/services/auth/supabase_auth_provider.dart';

class AuthService implements CustomAuthProvider {
  final CustomAuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.backend(String backend) {
    if (backend == "firebase") {
      return AuthService(FirebaseAuthProvider());
    } else {
      return AuthService(SupabaseAuthProvider());
    }
  }

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
