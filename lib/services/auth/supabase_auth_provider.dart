import 'package:bulletpoints/services/auth/auth_exceptions.dart';
import 'package:bulletpoints/services/auth/auth_providers.dart';
import 'package:bulletpoints/services/auth/auth_user.dart' as authUser;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as devtools show log;

class SupabaseAuthProvider implements CustomAuthProvider {
  late Supabase _supabase;
  @override
  Future<void> initialize() async {
    devtools.log("Initialized Supabase.");
    await Supabase.initialize(
      url: 'https://kyecrrequjgsibmhfyax.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5ZWNycmVxdWpnc2libWhmeWF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ2NzEzNDMsImV4cCI6MjAyMDI0NzM0M30.KDNIgTfNRLOb8TIj5Lk-i5zR-aZS0WPrCXk8um_88Yc',
    );
  }

  @override
  Future<void> createUser(
      {required String email, required String password}) async {
    devtools.log("Creating supabase user.");

    try {
      final supabase = Supabase.instance.client;
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: "io.supabase.flutterquickstart://login-callback/",
      );
      final user = currentUser;
      devtools.log("Created user: $user");
    } on AuthException catch (e) {
      throw SupabaseAuthException();
    }
  }

  @override
  authUser.AuthUser? get currentUser {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      return authUser.AuthUser.fromSupabase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Future<authUser.AuthUser> login(
      {required String email, required String password}) async {
    devtools.log("Logging in supabase user.");
    final supabase = Supabase.instance.client;
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on AuthException catch (e) {
      throw SupabaseAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    throw UnimplementedError();
  }
}
