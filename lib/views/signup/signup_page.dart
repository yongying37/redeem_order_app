import 'package:flutter/material.dart';
import 'signup_layout.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SignUpLayout(),
      ),
    );
  }
}
