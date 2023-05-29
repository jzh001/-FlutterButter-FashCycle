import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailKey = GlobalKey();
  final _passwordKey = GlobalKey();
  bool _passwordVisible = false;
  bool _isForgetPassword = false;
  bool _confirmPasswordVisible = false;
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.7,
        //height: MediaQuery.of(context).size.height * 0.5,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "FashCycle",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                key: _emailKey,
                decoration: const InputDecoration(
                  label: Text("Email"),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter valid email address.';
                  }
                  return null;
                },
                onSaved: (val) {
                  _email = val!;
                },
              ),
              if (!_isLogin)
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Username"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _username = val!;
                  },
                ),
              if (!_isForgetPassword)
                TextFormField(
                  key: _passwordKey,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    label: const Text("Password"),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    _password = val;
                  },
                ),
              if (!_isLogin)
                TextFormField(
                  key: const ValueKey('repeatPassword'),
                  decoration: InputDecoration(
                    label: const Text('Confirm Password'),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: !_confirmPasswordVisible,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    } else if (value != _password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              if (_isLogin)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isForgetPassword = !_isForgetPassword;
                      });
                    },
                    child: Text(
                      _isForgetPassword ? "Back to Login" : "Forgot Password?",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              const SizedBox(
                height: 25.0,
              ),
              SizedBox(
                height: 45,
                width: 200,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitAuthForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    _isLoading
                        ? "Logging in..."
                        : _isLogin
                            ? _isForgetPassword
                                ? "Reset"
                                : "Login"
                            : "Sign Up",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_isLogin ? "New to FlutterButter?" : "Already a user?"),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin ? "Sign Up" : "Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitAuthForm() async {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus(); //close the soft keyboard
    if (_isForgetPassword && !_isLogin) {
      _resetPassword();
      return;
    }
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    _email = _email.trim();

    UserCredential authResult;
    final auth = FirebaseAuth.instance;
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } else {
        if ((await FirebaseFirestore.instance
                .collection('Users')
                .where('Username', isEqualTo: _username)
                .get())
            .docs
            .isNotEmpty) {
          throw const HttpException('Username already taken');
        }

        authResult = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(authResult.user!.uid)
            .set({
          //'name': name,
          'Username': _username,
          'Email': _email,
          'Current Savings': 0,
          'Total Spending': 0,
          'Carbon Savings': 0,
          'Total Fabric': 0,
          //'status': "pending",
        });
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/');
      //no need set _isLoading since we are navigating away
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials';

      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      Navigator.of(context).pushReplacementNamed('/');
    } on HttpException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (error) {
      var errorMessage = 'Sorry, an error occurred. Please try again';
      if (error.toString().startsWith('[firebase_auth/user-not-found]')) {
        errorMessage = 'Username or password is incorrect.';
      } else if (error
          .toString()
          .startsWith('[firebase_auth/wrong-password]')) {
        errorMessage = 'Wrong password. Please try again.';
      } else if (error
          .toString()
          .startsWith('[firebase_auth/email-already-in-use]')) {
        errorMessage = 'Email address already in use. Please log in.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      log(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    _formKey.currentState!.save();
    if (_email.isEmpty || _email.contains('@')) {
      final auth = FirebaseAuth.instance;
      await auth
          .sendPasswordResetEmail(email: _email)
          .then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password Successfully Reset: Check your email"),
              ),
            ),
          )
          .onError((error, stackTrace) {
        log(_email);
        log(error.toString());
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Error: Check your email"),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      });
    }
  }
}
