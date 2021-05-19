import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmailSignInProvider extends ChangeNotifier {
  bool? _isLoading;
  String? _userEmail;
  String? _userPassword;
  String? _newUserEmail;
  String? _newUserPassword;
  String? _userName;

  EmailSignInProvider() {
    _isLoading = false;
    _userEmail = '';
    _userPassword = '';
    _newUserEmail = '';
    _newUserPassword = '';
    _userName = '';
  }

  bool? get isLoading => _isLoading;

  set isLoading(bool? value) {
    _isLoading = value;
    notifyListeners();
  }


  set isLogin(bool value) {
    notifyListeners();
  }

  String? get userEmail => _userEmail;

  set userEmail(String? value) {
    _userEmail = value;
    notifyListeners();
  }

  String? get userPassword => _userPassword;

  set userPassword(String? value) {
    _userPassword = value;
    notifyListeners();
  }

  String? get newUserEmail => _newUserEmail;

  set newUserEmail(String? value) {
    _newUserEmail = value;
    notifyListeners();
  }

  String? get newUserPassword => _newUserPassword;

  set newUserPassword(String? value) {
    _newUserPassword = value;
    notifyListeners();
  }

  String? get userName => _userName;

  set userName(String? value) {
    _userName = value;
    notifyListeners();
  }


  Future<bool> login() async {
    try {
      isLoading = true;

      print(userEmail);
      print(userPassword);


        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail!,
          password: userPassword!,
        );


      isLoading = false;
      return true;
    } catch (err) {
      print(err);
      isLoading = false;
      return false;
    }
  }

  Future<bool> signup() async {
    try {
      isLoading = true;

      print(newUserEmail);
      print(newUserPassword);


        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: newUserEmail!,
          password: newUserPassword!,
        );


      isLoading = false;
      return true;
    } catch (err) {
      print(err);
      isLoading = false;
      return false;
    }
  }

}
