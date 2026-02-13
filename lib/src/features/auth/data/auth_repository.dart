import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  AuthRepository(this._firebaseAuth, this._firebaseFirestore);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Метод для входа в аккаунт
  Future<User?> signIn(String email, String password) async {
    try {
      final login = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return login.user;
    } on FirebaseAuthException catch (e) {
      throw _firebaseErrors(e);
    }
  }

  // метод для регистрации
  Future<User?> signUp(String email, String password, String name) async {
    try {
      final createAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final user = createAccount.user;

      if(user != null) {
        await _firebaseFirestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'createdAccount': DateTime.now(),
        });
      }

      return user;

    } on FirebaseAuthException catch (e) {
      throw _firebaseErrors(e);
    }
  }

  // Выход из аккаунта
  Future<void> signOut() => _firebaseAuth.signOut();

  String _firebaseErrors(FirebaseAuthException e) {
    if (e.code == 'user-not-found') return 'Пользователь не найден';
    if (e.code == 'wrong-password') return 'Неверный пароль';
    if (e.code == 'invalid-email') return 'Неверный электронный адрес';
    if (e.code == 'email-already-in-use') return 'Email уже занят';
    return 'Ошибка: ${e.message}';
  }
}