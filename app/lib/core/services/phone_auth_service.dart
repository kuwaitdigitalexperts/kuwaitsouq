import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';

class PhoneAuthVerificationResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;

  PhoneAuthVerificationResult({
    required this.isSuccess,
    this.user,
    this.errorMessage,
  });
}

class PhoneAuthService {
  static Future<FirebaseAuth> _getAuth() async {
    if (Firebase.apps.isEmpty) {
      debugPrint('PhoneAuth: Firebase not initialized. Initializing now...');
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        debugPrint('PhoneAuth fallback initializeApp error: $e');
        await Firebase.initializeApp();
      }
    }
    return FirebaseAuth.instance;
  }

  /// Sends OTP to the provided full phone number with country code (e.g. +96598765432)
  static Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(UserCredential credential) onAutoVerified,
    required void Function(String errorMessage) onFailed,
    int? forceResendingToken,
  }) async {
    try {
      final auth = await _getAuth();
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: forceResendingToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint('PhoneAuth: Auto-verification completed');
          try {
            final userCredential = await auth.signInWithCredential(credential);
            onAutoVerified(userCredential);
          } catch (e) {
            debugPrint('Auto-verification sign in error: $e');
            onFailed('Auto-verification failed: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('PhoneAuth: verificationFailed code=${e.code} message=${e.message}');
          final message = _parseFirebasePhoneError(e);
          onFailed(message);
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('PhoneAuth: Code sent successfully. verificationId=$verificationId');
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('PhoneAuth: Auto retrieval timeout for $verificationId');
        },
      );
    } catch (e) {
      debugPrint('Unexpected error calling verifyPhoneNumber: $e');
      onFailed('Failed to send verification SMS: $e');
    }
  }

  /// Verifies the entered SMS code with the verification ID
  static Future<PhoneAuthVerificationResult> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final cleanCode = smsCode.trim();

    try {
      final auth = await _getAuth();
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: cleanCode,
      );

      final userCredential = await auth.signInWithCredential(credential);
      return PhoneAuthVerificationResult(
        isSuccess: true,
        user: userCredential.user,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('PhoneAuth verifySmsCode error: ${e.code} - ${e.message}');
      if (e.code == 'invalid-verification-code') {
        return PhoneAuthVerificationResult(
          isSuccess: false,
          errorMessage: 'Incorrect 6-digit OTP. Please check the code received via SMS.',
        );
      }
      if (e.code == 'session-expired') {
        return PhoneAuthVerificationResult(
          isSuccess: false,
          errorMessage: 'Verification code has expired. Please request a new OTP.',
        );
      }
      return PhoneAuthVerificationResult(
        isSuccess: false,
        errorMessage: e.message ?? 'Invalid verification code. Please try again.',
      );
    } catch (e) {
      debugPrint('Unexpected error in verifySmsCode: $e');
      return PhoneAuthVerificationResult(
        isSuccess: false,
        errorMessage: 'Verification error ($e). Please try again.',
      );
    }
  }

  static String _parseFirebasePhoneError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The phone number entered is invalid. Please check the 10-digit number.';
      case 'quota-exceeded':
        return 'SMS quota exceeded for today. You can still test with configured test numbers or Google Sign-In.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment before trying again.';
      case 'app-not-authorized':
        return 'App not authorized. If running in debug, ensure test numbers are added in Firebase Console.';
      case 'operation-not-allowed':
        if (e.message?.contains('region') == true) {
          return 'SMS to this region/country is not enabled in Firebase Console. Please enable SMS for this region under Firebase Auth Settings, or add this number as a Test Number in Firebase Console.';
        }
        return 'Phone authentication is disabled in Firebase Console. Please enable Phone provider under Firebase Auth > Sign-in method.';
      case 'network-request-failed':
        return 'Network connection issue or Firebase blocked the request. If using an emulator, check internet or use a test phone number configured in Firebase Console.';
      default:
        return e.message ?? 'Unable to send SMS verification. Please try again.';
    }
  }
}
