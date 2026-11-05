import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Prevents concurrent Google operations (signIn/signOut overlapping)
  bool _googleBusy = false;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ---------------------------------------------
  // Email + password registration
  // ---------------------------------------------
  Future<User?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  // ---------------------------------------------
  // Email + password login
  // ---------------------------------------------
  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  // ---------------------------------------------
  // Google Sign-In (SSO)
  // ---------------------------------------------
  Future<User?> signInWithGoogle() async {
    if (_googleBusy) {
      throw 'A Google sign-in is already in progress. Please wait.';
    }
    _googleBusy = true;

    try {
      // Force a fresh state before sign-in to avoid cached operations
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Ignore if nothing to sign out
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } catch (e) {
      throw 'Google Sign-In failed. Please try again.';
    } finally {
      _googleBusy = false;
    }
  }

  // ---------------------------------------------
  // Sign out (email + Google)
  // ---------------------------------------------
  Future<void> signOut() async {
    // Wait briefly if a Google operation is still running
    if (_googleBusy) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      // Ignore Google failure — Firebase sign-out must still run
      print('Google disconnect failed (likely no Play Services): $e');
    }

    await _auth.signOut();
  }

  // ---------------------------------------------
  // Error mapping
  // ---------------------------------------------
  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak (minimum 6 characters).';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}