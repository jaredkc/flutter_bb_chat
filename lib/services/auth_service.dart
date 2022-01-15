import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // This could be used in main.dart to check if the user is logged in
  // final Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();

  bool isSignedIn() {
    return auth.currentUser != null;
  }

  String? userId() {
    return auth.currentUser?.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }

  String? photoURL() {
    return auth.currentUser?.photoURL;
  }

  void signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void signInEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print('The password is invalid or the user does not have a password.');
      } else if (e.code == 'user-not-found') {
        print('There is no user record corresponding to this identifier.');
      } else if (e.code == 'user-disabled') {
        print('The user account has been disabled by an administrator.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signOut() async {
    await auth.signOut();
    notifyListeners();
  }
}
