import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send OTP
  Future<void> sendOtp({
    required String phone,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(FirebaseAuthException err) onFailed,
    required Function(PhoneAuthCredential credential) onAutoVerified,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          // auto-retrieval or instant validation: pass credential back to UI
          print('[AuthService] verificationCompleted (auto)');
          onAutoVerified(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('[AuthService] verificationFailed: ${e.code} ${e.message}');
          onFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          print(
              '[AuthService] codeSent verificationId=$verificationId for $phone');
          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(
              '[AuthService] codeAutoRetrievalTimeout verificationId=$verificationId');
        },
      );
    } catch (e) {
      print('[AuthService] sendOtp exception: $e');
      onFailed(FirebaseAuthException(code: 'unknown', message: e.toString()));
    }
  }

  // Verify OTP manually (for real OTP flow)
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    print('[AuthService] Manually verifying OTP...');
    return await _auth.signInWithCredential(credential);
  }

  // Sign in with credential (used in auto-verification)
  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  // Create user in Firestore
  Future<void> createUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
