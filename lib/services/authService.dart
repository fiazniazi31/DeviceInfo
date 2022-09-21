// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Register user function
  Future<User?> register(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print(e);
    }
  }

  //Login funcrion
  Future<User?> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print(e);
    }
  }

//SignOut Function
  Future signOut() async {
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<User?> signInWithGoogle() async {
    try {
      //trigger the auth dialog
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        //obtain auth detail from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        //create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        //once signed in returen the user data from firebase
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print(e);
    }
  }
}
