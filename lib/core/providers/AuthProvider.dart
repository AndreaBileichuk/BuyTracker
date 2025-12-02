import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../services/AuthService.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? get currentUser => _authService.currentUser;
  bool get isLoggedIn => _authService.currentUser != null;

  AppAuthProvider() {
    _authService.authStateChanges.listen((user) {
      notifyListeners();
    });
  }

  Future<void> signUp(String name, String email, String password) async {
    await _authService.createAccount(
      username: name,
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(
      email: email,
      password: password,
    );
  }

  Future<void> passwordForget() async {
    await _authService.passwordForget("Sddsdsd");
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _authService.firebaseAuth.sendPasswordResetEmail(email: email);
  }
}