import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.callback}) : super(key: key);

  final Function(
    String email,
    String username,
    String password,
    bool loginMode,
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

  // TextController
  final _userCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  void _trySubmit() {
    bool isValid = _formKey.currentState!.validate();

    // Remove the displaying keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      // Save method will trigger in FormField in onsaved attribute
      _formKey.currentState?.save();

      widget.callback(
        _userEmail,
        _userUsername,
        _userPassword,
        _loginMode,
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

                ElevatedButton(
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
