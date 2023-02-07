import 'dart:io';

import 'package:chatapp/models/user_dto.dart';
import 'package:chatapp/models/user_register.dart';
import 'package:chatapp/screens/auth/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.isLoading, {Key? key, required this.callback})
      : super(key: key);

  final bool isLoading;

  final Function(
    bool loginMode,
    BuildContext context, {
    UserRegister? requestRegister,
    UserDto? requestDto,
  }) callback;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _userDto = UserDto();
  final _userRegister = UserRegister();

  var _loginMode = false;

  // TextController
  final _userCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  void _trySubmit() {
    bool isValid = _formKey.currentState!.validate();
    // Remove the displaying keyboard
    FocusScope.of(context).unfocus();

    if (!_loginMode && _userRegister.imageFile == null) {
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
      if (_loginMode) {
        widget.callback(
          _loginMode,
          context,
          requestDto: _userDto,
        );
      } else {
        widget.callback(
          _loginMode,
          context,
          requestRegister: _userRegister,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 0,
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
                            _userRegister.imageFile = File(imageXFile.path),
                      )
                    : const SizedBox.shrink(),

                /// Email
                ///
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return "Please enter a valid email address.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                  ),
                  onSaved: (newValue) {
                    // _userEmail = newValue ?? "";
                    _userRegister.email = newValue?.trim() ?? "";
                    _userDto.email = newValue?.trim() ?? "";
                  },
                ),

                // Username
                if (!_loginMode)
                  TextFormField(
                    controller: _userCtr,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username can't be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                    onSaved: (newValue) {
                      _userRegister.username = newValue?.trim() ?? "";
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
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  onSaved: (newValue) {
                    _userRegister.password = newValue?.trim() ?? "";
                    _userDto.password = newValue?.trim() ?? "";
                  },
                ),

                const SizedBox(height: 12),

                widget.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _trySubmit,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith(
                            (_) => const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          overlayColor: MaterialStateProperty.resolveWith(
                              (_) => const Color.fromRGBO(240, 240, 240, 1)),
                        ),
                        child: Text(_loginMode ? "Login" : "Signup"),
                      ),

                // Switch
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith(
                        (_) => const Color.fromRGBO(240, 240, 240, 1)),
                    padding: MaterialStateProperty.resolveWith(
                      (_) => const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _loginMode = !_loginMode;
                      _formKey.currentState!.reset();

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
