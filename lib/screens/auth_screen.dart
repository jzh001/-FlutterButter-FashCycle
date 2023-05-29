import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutterbutter/auth/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: WaveClipperTwo(reverse: true),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const AuthForm(),
        ],
      ),
    );
  }
}
