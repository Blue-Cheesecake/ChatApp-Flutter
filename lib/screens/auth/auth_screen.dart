import 'package:chatapp/screens/auth/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void _submitForm(
    String email,
    String username,
    String password,
    bool loginMode,
    BuildContext context,
  ) async {
    // print("From callback");
    // print(email);
    // print(username);
    // print(password);

    // Do Sign in
    try {
      if (loginMode) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Successfully login");
        print("Navigating to Chat screen");
      }
      // Create new user
      else {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (error) {
      var message = "An error occurred. Please check you credentials!";
      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      print("Unknown Error");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: AuthForm(callback: _submitForm),
      ),
    );
  }
}
