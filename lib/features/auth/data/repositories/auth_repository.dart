import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Викидаємо сам код помилки або оброблений код
      throw _handleAuthException(e);
    } catch (_) {
      throw 'unknown-error';
    }
  }

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (_) {
      throw 'unknown-error';
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> deleteUnverifiedAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        throw _handleAuthException(e);
      } catch (_) {
        throw 'account-deletion-error';
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Повертаємо КОДИ, а не текст. Текст підставить UI.
  String _handleAuthException(FirebaseAuthException e) {
    // Повертаємо код помилки, щоб UI міг його перекласти
    return e.code;
  }
}