import 'dart:io';

import 'package:chatapp/screens/auth/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.isLoading, {Key? key, required this.callback})
      : super(key: key);

  final bool isLoading;

  final Function(
    String email,
    String username,
    String password,
    bool loginMode,
    File imageFile,
    BuildContext context,
  ) callback;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = "";
  var _userUsername = "";
  var _userPassword = "";

  var _loginMode = false;
  XFile? _imageFile;

  // TextController
  final _userCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  void _trySubmit() {
    bool isValid = _formKey.currentState!.validate();
    // Remove the displaying keyboard
    FocusScope.of(context).unfocus();

    if (!_loginMode && _imageFile == null) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please provide the image"),
            backgroundColor: Colors.red),
      );
    }

    if (isValid) {
      // Save method will trigger in FormField in onsaved attribute
      _formKey.currentState?.save();

      // print("Auth form ${_userEmail} ${_userPassword.trim()}");

      widget.callback(
        _userEmail.trim(),
        _userUsername.trim(),
        _userPassword.trim(),
        _loginMode,
        File(_imageFile?.path ?? ""),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                !_loginMode
                    ? UserImagePicker(
                        assignImageFileFunc: (imageXFile) =>
                            _imageFile = imageXFile,
                      )
                    : const SizedBox.shrink(),

                /// Email
                ///
                if (!_loginMode)
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return "Please enter a valid email address.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                    onSaved: (newValue) {
                      _userEmail = newValue ?? "";
                    },
                  ),

                // Username
                TextFormField(
                  controller: _userCtr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username can't be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Username",
                  ),
                  onSaved: (newValue) {
                    _userUsername = newValue ?? "";
                  },
                ),

                // Password
                TextFormField(
                  controller: _passwordCtr,
                  validator: (value) {
                    if (value!.isEmpty && value.length < 7) {
                      return "Password must be at least 7 character.";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  onSaved: (newValue) {
                    _userPassword = newValue ?? "";
                  },
                ),

                const SizedBox(height: 12),

                widget.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_loginMode ? "Login" : "Signup"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _loginMode = !_loginMode;

                      FocusScope.of(context).unfocus();
                      _userCtr.text = "";
                      _passwordCtr.text = "";
                    });
                  },
                  child: Text(_loginMode
                      ? "Create new account"
                      : "I alreay have an account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
