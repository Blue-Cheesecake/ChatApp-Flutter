import 'package:chatapp/models/user_dto.dart';
import 'package:chatapp/models/user_register.dart';
import 'package:chatapp/screens/auth/utils/submit_form_utils.dart';
import 'package:chatapp/screens/auth/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    bool loginMode,
    BuildContext context, {
    UserRegister? requestRegister,
    UserDto? requestDto,
  }) async {
    // Do Sign in

    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      if (loginMode) {
        if (requestDto == null) {
          throw NullThrownError();
        }

        await SubmitFormUtils.loginUser(requestDto);
      }
      // Create new user
      else {
        if (requestRegister == null) {
          throw NullThrownError();
        }

        await SubmitFormUtils.registerUser(requestRegister);
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
