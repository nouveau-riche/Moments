import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:who_gets_this/core/store.dart';

import '../widgets/taost.dart';
import './firebase_methods.dart';
import '../screens/home_screen.dart';

final _auth = FirebaseAuth.instance;

class Authentication {
  static Future<void> loginUserFromFirebase(
      {BuildContext context, String email, String password}) async {
    try {
      ToggleLoading();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = userCredential.user;

      if (user != null) {

        ToggleLoading();

        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (ctx) => HomeScreen(),
          ),
        );
      }
    } catch (error) {
      print(error);

      var errorMessage = 'Failed! Try again Later';
      if (error.toString().contains('password is invalid')) {
        errorMessage = 'Opps! Wrong Password';
      } else if (error.toString().contains('ERROR_TOO_MANY_REQUESTS')) {
        errorMessage = 'Too many requests. Try again Later!';
      } else if (error.toString().contains('no user record corresponding')) {
        errorMessage = 'User not Registered';
      } else if (error.toString().contains('A network error')) {
        errorMessage = 'Network error';
      }
      ToggleLoading();

      toast(errorMessage, true);
    }
  }

  static Future<void> signUpUserFromFirebase(
      {BuildContext context,
      String name,
      String email,
      String password}) async {
    try {
      ToggleLoading();

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      if (user != null) {
        FirebaseMethods.saveUserToFirebase(
            uid: user.uid, email: email, name: name);

        ToggleLoading();

        toast('Registered Successfully!', false);

        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (ctx) => HomeScreen(),
          ),
        );
      }
    } catch (error) {
      print(error);

      var errorMessage = 'Failed! Try again Later';
      if (error.toString().contains('ERROR_TOO_MANY_REQUESTS')) {
        errorMessage = 'Too many requests. Try again Later!';
      } else if (error.toString().contains('email address is already in use')) {
        errorMessage = 'User Already Registered';
      } else if (error
          .toString()
          .contains('Password should be at least 6 characters')) {
        errorMessage = 'Password too short';
      } else if (error.toString().contains('A network error')) {
        errorMessage = 'Network error';
      }

      ToggleLoading();
      toast(errorMessage, true);
    }
  }

  static Future<void> signOut() async {
    return await _auth.signOut();
  }

  static Future resetPasswordWithEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
