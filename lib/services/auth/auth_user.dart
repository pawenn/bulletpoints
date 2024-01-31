import 'package:supabase_flutter/supabase_flutter.dart' as Supabase show User;

class AuthUser {
  final bool isEmailverified;
  final String? email;
  const AuthUser({required this.isEmailverified, required this.email});

  factory AuthUser.fromSupabase(Supabase.User user) => AuthUser(
        isEmailverified: user.emailConfirmedAt !=
            null, // Assuming email is verified if emailConfirmedAt is not null
        email: user.email,
      );
}
