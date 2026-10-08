import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../firebase_options.dart';

enum SocialAuthStatus {
  success,
  canceled,
  error,
}

class SocialAuthResult {
  final SocialAuthStatus status;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? uid;
  final String? provider;
  final String? errorMessage;

  const SocialAuthResult({
    required this.status,
    this.email,
    this.displayName,
    this.photoUrl,
    this.uid,
    this.provider,
    this.errorMessage,
  });

  bool get isSuccess => status == SocialAuthStatus.success;
  bool get isCanceled => status == SocialAuthStatus.canceled;
  bool get isError => status == SocialAuthStatus.error;

  factory SocialAuthResult.success({
    required String email,
    required String displayName,
    String? photoUrl,
    String? uid,
    required String provider,
  }) {
    return SocialAuthResult(
      status: SocialAuthStatus.success,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      uid: uid,
      provider: provider,
    );
  }

  factory SocialAuthResult.canceled({String provider = 'Social'}) {
    return SocialAuthResult(
      status: SocialAuthStatus.canceled,
      provider: provider,
      errorMessage: 'Sign-in canceled',
    );
  }

  factory SocialAuthResult.error(String message, {String provider = 'Social'}) {
    return SocialAuthResult(
      status: SocialAuthStatus.error,
      provider: provider,
      errorMessage: message,
    );
  }
}

class SocialAuthService {
  static Future<FirebaseAuth> _getAuth() async {
    if (Firebase.apps.isEmpty) {
      debugPrint('SocialAuth: Firebase not initialized. Initializing now...');
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        debugPrint('SocialAuth fallback initializeApp error: $e');
        await Firebase.initializeApp();
      }
    }
    return FirebaseAuth.instance;
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Sign in with Google.
  /// Enforces account chooser dialog by signing out before opening picker.
  static Future<SocialAuthResult> signInWithGoogle() async {
    try {
      // 1. Force account selection dialog on every login attempt (avoids silent re-login)
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('GoogleSignIn signOut ignored: $e');
      }

      // 2. Open Google Account Chooser
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User closed the account selection dialog
      if (googleUser == null) {
        return SocialAuthResult.canceled(provider: 'Google');
      }

      // 3. Obtain authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 4. Authenticate with Firebase Auth
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential? userCredential;
      try {
        final auth = await _getAuth();
        userCredential = await auth.signInWithCredential(credential);
      } catch (firebaseErr) {
        debugPrint('Firebase signInWithCredential error: $firebaseErr');
        // Fallback: Proceed with googleUser info even if Firebase project rule has an issue
      }

      final email = userCredential?.user?.email ?? googleUser.email;
      final displayName = userCredential?.user?.displayName ?? googleUser.displayName ?? 'Google User';
      final photoUrl = userCredential?.user?.photoURL ?? googleUser.photoUrl;
      final uid = userCredential?.user?.uid ?? googleUser.id;

      if (email.isEmpty) {
        return SocialAuthResult.error('No email address provided by Google account.', provider: 'Google');
      }

      return SocialAuthResult.success(
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        uid: uid,
        provider: 'Google',
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during Google sign in: ${e.code} - ${e.message}');
      if (e.code == 'network-request-failed') {
        return SocialAuthResult.error('Network connection issue. Please check your internet connection.', provider: 'Google');
      }
      return SocialAuthResult.error(e.message ?? 'Authentication failed. Please try again.', provider: 'Google');
    } catch (e) {
      debugPrint('Unexpected error during Google sign in: $e');
      final errStr = e.toString();
      if (errStr.contains('sign_in_canceled') || errStr.contains('12501')) {
        return SocialAuthResult.canceled(provider: 'Google');
      }
      if (errStr.contains('network') || errStr.contains('SocketException')) {
        return SocialAuthResult.error('Network error. Please check your internet connection.', provider: 'Google');
      }
      return SocialAuthResult.error('Could not complete Google Sign-In ($e). Please try again.', provider: 'Google');
    }
  }

  /// Sign in with Facebook.
  /// Enforces account chooser dialog by logging out before opening Facebook login.
  static Future<SocialAuthResult> signInWithFacebook() async {
    try {
      // 1. Force account selection by logging out previous session
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {
        debugPrint('FacebookAuth logOut ignored: $e');
      }

      // 2. Open Facebook Login Dialog
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) {
        return SocialAuthResult.canceled(provider: 'Facebook');
      }

      if (result.status == LoginStatus.failed) {
        debugPrint('Facebook login failed: ${result.message}');
        return SocialAuthResult.error(
          result.message ?? 'Facebook sign-in failed. Please try again or use Google.',
          provider: 'Facebook',
        );
      }

      if (result.status == LoginStatus.success && result.accessToken != null) {
        // Fetch user profile from Facebook SDK
        Map<String, dynamic>? userData;
        try {
          userData = await FacebookAuth.instance.getUserData();
        } catch (_) {}

        // Authenticate with Firebase if token is available
        UserCredential? userCredential;
        try {
          final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
          final auth = await _getAuth();
          userCredential = await auth.signInWithCredential(credential);
        } catch (firebaseErr) {
          debugPrint('Firebase Facebook auth error: $firebaseErr');
        }

        final token = result.accessToken;
        final fbUserId = token is ClassicToken
            ? token.userId
            : (token is LimitedToken ? token.userId : (userData?['id']?.toString() ?? 'fb_${DateTime.now().millisecondsSinceEpoch}'));

        final email = userCredential?.user?.email ?? userData?['email'] as String? ?? 'fb_$fbUserId@kuwaitsouq.com';
        final displayName = userCredential?.user?.displayName ?? userData?['name'] as String? ?? 'Facebook User';
        final photoUrl = userCredential?.user?.photoURL ?? userData?['picture']?['data']?['url'] as String?;
        final uid = userCredential?.user?.uid ?? fbUserId;

        return SocialAuthResult.success(
          email: email,
          displayName: displayName,
          photoUrl: photoUrl,
          uid: uid,
          provider: 'Facebook',
        );
      }

      return SocialAuthResult.error('Unable to complete Facebook sign-in.', provider: 'Facebook');
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during Facebook sign in: ${e.code} - ${e.message}');
      return SocialAuthResult.error(e.message ?? 'Authentication failed.', provider: 'Facebook');
    } catch (e) {
      debugPrint('Unexpected error during Facebook sign in: $e');
      final errStr = e.toString();
      if (errStr.contains('cancelled') || errStr.contains('CANCELED')) {
        return SocialAuthResult.canceled(provider: 'Facebook');
      }
      return SocialAuthResult.error(
        'Facebook Sign-In is currently in test mode. You can sign in smoothly with Google or Mobile OTP.',
        provider: 'Facebook',
      );
    }
  }

  /// Complete logout from all social providers
  static Future<void> signOut() async {
    try {
      final auth = await _getAuth();
      await auth.signOut();
    } catch (_) {}
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

  /// Permanently delete Firebase user and disconnect social accounts
  static Future<void> deleteFirebaseUser() async {
    try {
      final auth = await _getAuth();
      final user = auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      debugPrint('ℹ️ [SocialAuthService] Firebase user deletion info: $e');
    }

    try {
      await _googleSignIn.disconnect();
    } catch (_) {}

    await signOut();
  }
}
