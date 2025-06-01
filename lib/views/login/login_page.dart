import 'package:flutter/material.dart';
import 'login_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: LoginLayout(),
      ),
    );
  }
}
