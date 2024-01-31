import 'package:bulletpoints/services/auth/auth_exceptions.dart';
import 'package:bulletpoints/services/auth/auth_providers.dart';
import 'package:bulletpoints/services/auth/auth_user.dart' as authUser;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as devtools show log;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class SupabaseAuthProvider {
  late Supabase _supabase;
  late GoogleSignIn _googleSignIn;

  // Private constructor
  SupabaseAuthProvider._();

  // Singleton instance
  static final SupabaseAuthProvider _instance = SupabaseAuthProvider._();

  factory SupabaseAuthProvider.instance() {
    return _instance;
  }
  
  Future<void> initialize() async {
    devtools.log("Initialized Supabase.");
    _supabase = await Supabase.initialize(
      url: 'https://kyecrrequjgsibmhfyax.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5ZWNycmVxdWpnc2libWhmeWF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ2NzEzNDMsImV4cCI6MjAyMDI0NzM0M30.KDNIgTfNRLOb8TIj5Lk-i5zR-aZS0WPrCXk8um_88Yc',
    );
  }

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

  authUser.AuthUser? get currentUser {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      return authUser.AuthUser.fromSupabase(user);
    } else {
      return null;
    }
  }

  Future<void> logOut() async {
    await Supabase.instance.client.auth.signOut();
    try {
      await _googleSignIn.signOut();
      devtools.log("Signed out from Google.");
    } catch (error) {
      devtools.log("Error signing out from Google: $error");
    }
  }

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

  Future<void> loginWithGoogle() async {
    devtools.log("Logging in with google.");
    print("Logging with google.");
    final supabase = Supabase.instance.client;

    /// Web Client ID that you registered with Google Cloud.
    const webClientId = '866567165605-srpnicuuhrvkcid0u1cr2bce3295pj0d.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = 'my-ios.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.
    String? clientId;
    if (kIsWeb) {
      devtools.log("Web client");
      clientId = webClientId;
      _googleSignIn = GoogleSignIn(
      clientId: clientId,
      scopes: <String>['email', 'profile', 'openid'],
    );
    } else if (Platform.isIOS) {
      devtools.log("iOS client");
      clientId = iosClientId;
      _googleSignIn = GoogleSignIn(
      clientId: clientId,
      
      );
    }
    // No clientId needed for Android

    
    GoogleSignInAccount? googleUser;
    if (kIsWeb) {
      print("Signing in web.");
      googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        print("No active session. Prompting user for sign-in.");
        googleUser = await _googleSignIn.signIn(); // Fallback to manual sign-in
      }
      print("Signing in via web was successful, User: $googleUser");
    } else if (Platform.isIOS) {
      print("Signing in iOS:");
      googleUser = await _googleSignIn.signIn();
    }
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    print("Access token: = $accessToken");
    final idToken = googleAuth.idToken;
    print("ID token: = $idToken");
    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> loginWithApple() async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signInWithOAuth(OAuthProvider.apple);
  }

  Future<void> sendEmailVerification() async {
    throw UnimplementedError();
  }
  
}
