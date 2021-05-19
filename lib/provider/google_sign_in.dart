import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool? _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool? get isSigningIn => _isSigningIn;

  set isSigningIn(bool? isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;

    if (kIsWeb) {
      FirebaseAuth auth = FirebaseAuth.instance;
      GoogleAuthProvider authProvider = GoogleAuthProvider();


        await auth.signInWithPopup(authProvider);

      isSigningIn = false;

    } else {

    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      }

      isSigningIn = false;
    }
  }

  void logout() async {
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error signing out : $e");
    }

/*    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
    FirebaseAuth.instance.signOut();*/
  }
}
