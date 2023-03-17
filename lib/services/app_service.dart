// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //FIREBASE AUTH INSTANCE
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//USER SIGN UP METHOD
  Future<User?> signUpOperation(
      {required String email,
      required String password,
      required BuildContext context}) async {
    User? user;
    try {
      final UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(credential.toString());
      user = firebaseAuth.currentUser;
      await user!.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        debugPrint(
          'The password provided is too weak',
        );
      } else if (error.code == 'email-already-in-use') {
        debugPrint(
          'The account already exists for that email.',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint('not sign up');

    return user;
  }

  //USER LOGIN METHOD
  Future<User?> logInOperation(
      {required String email,
      required String password,
      required BuildContext context}) async {
    User? user;
    try {
      final UserCredential credential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        debugPrint(
          'No user found for that email.',
        );
      } else if (error.code == 'wrong-password') {
        debugPrint(
          'Wrong password provided for that user.',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint(user.toString());
    return user;
  }

  //USER SIGN OUT OPERATION
  void signOut() async {
    await firebaseAuth.signOut();
    firebaseAuth.currentUser?.delete();
  }
}
