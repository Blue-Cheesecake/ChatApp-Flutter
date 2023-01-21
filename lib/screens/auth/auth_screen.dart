import 'dart:io';

import 'package:chatapp/screens/auth/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _isLoading = false;

  void _submitForm(
    String email,
    String username,
    String password,
    bool loginMode,
    File imageFile,
    BuildContext context,
  ) async {
    // print("From callback");
    // print(email);
    // print(username);
    // print(password);

    // Do Sign in
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      if (loginMode) {
        // print(email);
        // print(password);
        await auth.signInWithEmailAndPassword(
          email: username,
          password: password,
        );
        print("Successfully login");
        print("Navigating to Chat screen");
      }
      // Create new user
      else {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child(userCredential.user?.uid ?? "error_file");
        storageRef.putFile(imageFile);

        // Register username and email to Firestore
        db.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (error) {
      var message = "An error occurred. Please check you credentials!";
      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      print("Unknown Error");
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: AuthForm(_isLoading, callback: _submitForm),
      ),
    );
  }
}
