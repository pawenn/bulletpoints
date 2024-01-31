import 'package:bulletpoints/services/auth/supabase_auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as devtools show log;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthProvider {
  late GoogleSignIn _googleSignIn;

  /// Web Client ID that you registered with Google Cloud.
  final webClientId =
      '866567165605-srpnicuuhrvkcid0u1cr2bce3295pj0d.apps.googleusercontent.com';

  /// iOS Client ID that you registered with Google Cloud.
  final iosClientId = 'my-ios.apps.googleusercontent.com';

  final androidClientId =
      '866567165605-uantmlauigdrfkf9rfjfb5t09jlhlgkg.apps.googleusercontent.com';

  GoogleSignInAccount? _googleUser = null;

  bool _isAuthorized = false;

  static const List<String> scopes = <String>['email', 'profile', 'openid'];

  // Private constructor
  GoogleAuthProvider._();
  // Singleton instance
  static final GoogleAuthProvider _instance = GoogleAuthProvider._();

  //SupabaseAuthprover
  late SupabaseAuthProvider _supabaseAuthProvider;

  factory GoogleAuthProvider.instance() {
    return _instance;
  }

  Future<void> initialize(SupabaseAuthProvider supabaseAuthProvider) async {
    print("Initializing GoogleAuthProvider");

    //For Web plugin
    //_googleSignInPlugin = GoogleSignInPlugin();
    //_googleSignInPlugin.init();
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId: webClientId,
        scopes: <String>['email', 'profile', 'openid'],
      );
    } else if (Platform.isIOS) {
      _googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        scopes: <String>['email', 'profile', 'openid'],
      );
    } else {
      _googleSignIn = GoogleSignIn(
        clientId: webClientId,
        scopes: <String>['email', 'profile', 'openid'],
      );
    }
    //Setup Listner for web Plugin
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // #docregion CanAccessScopes
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, on web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
        setCurrentUser(account, isAuthorized);
      }
    });

    //Set Instance of SupabaseAuthprovider
    _supabaseAuthProvider = supabaseAuthProvider;

    //SignInSilently
    await _googleSignIn.signInSilently();
  }

  GoogleSignIn? get googleSignIn => _googleSignIn;

  GoogleSignInAccount? get googleUser => _googleUser;

  bool get isAuthorized => _isAuthorized;

  void setCurrentUser(GoogleSignInAccount? user, bool isAuthorized) async {
    _googleUser = user;
    final supabase = Supabase.instance.client;
    devtools.log("User: $user");
    if (user != null) {
      devtools.log("Signeing in to Supabase.");

      final authentication = await _googleUser?.authentication;

      final idToken = authentication?.idToken;
      final accessToken = authentication?.accessToken;
      devtools.log("Idtoke: $idToken, AccessToken: $accessToken");

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken ?? '',
        accessToken: accessToken,
      );
      devtools.log("Signed in to Supabase. $response");
    } else {
      supabase.auth.signOut();
    }

    _isAuthorized = isAuthorized;

    print("Signed in to Supabase.");
  }

  Future<void> signinWithGoogle() async {
    print("Logging in with googleAuthProvider.");

    if (kIsWeb) {
      print(_googleSignIn);
      _googleUser = await _googleSignIn.signInSilently();
    } else {
      _googleUser = await _googleSignIn.signIn();
    }

    //get Access tokens
    final googleAuth = await _googleUser!.authentication;
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
  }

  Future<void> signoutWithGoogle() async {
    await _googleSignIn.signOut();
  }

  // Prompts the user to authorize `scopes`.
  //
  // This action is **required** in platforms that don't perform Authentication
  // and Authorization at the same time (like the web).
  //
  // On the web, this must be called from an user interaction (button click).
  // #docregion RequestScopes
  Future<void> handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
    // #enddocregion RequestScopes

    _isAuthorized = isAuthorized;

    // #docregion RequestScopes

    // #enddocregion RequestScopes
  }

  Future<void> handleSignIn() async {
    devtools.log("Signing in via google");
    try {
      final googleUser = await _googleSignIn.signIn();
      setCurrentUser(googleUser, true);
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() {
    setCurrentUser(null, false);
    return _googleSignIn.disconnect();
  }
}
