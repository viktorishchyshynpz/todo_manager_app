import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  // Конструктор з опціональним параметром для тестування
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  // Потік змін стану авторизації
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

  // Оновлення користувача (важливо для перевірки emailVerified)
  Future<User?> reloadUser() async {
    final user = _firebaseAuth.currentUser;
    await user?.reload();
    return _firebaseAuth.currentUser;
  }

  Future<void> deleteUnverifiedAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // Оновлюємо дані перед видаленням
      await user.reload();
      if (!user.emailVerified) {
        try {
          await user.delete();
        } on FirebaseAuthException catch (e) {
          throw _handleAuthException(e);
        } catch (_) {
          throw 'account-deletion-error';
        }
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String _handleAuthException(FirebaseAuthException e) {
    return e.code;
  }
}