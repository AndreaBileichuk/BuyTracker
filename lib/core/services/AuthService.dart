import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<UserCredential> createAccount({
    required String username,
    required String email,
    required String password
  }) async {
    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );

    User? user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(username);

      await user.reload();
    }

    return userCredential;
  }

  Future<void> passwordForget(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}