import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Send OTP
  Future<void> sendOTP(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store verificationId for later use
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify OTP
  Future<UserModel> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Get or create user document
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(
          userDoc.data()!,
          userCredential.user!.uid,
        );
      } else {
        // Create new user
        final newUser = UserModel(
          id: userCredential.user!.uid,
          phone: userCredential.user!.phoneNumber ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toFirestore());

        return newUser;
      }
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;

    return UserModel.fromFirestore(userDoc.data()!, user.uid);
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(user.uid).update(updates);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    // This should be implemented with google_sign_in package
    // For now, returning a placeholder
    throw UnimplementedError('Google sign in to be implemented');
  }
}
