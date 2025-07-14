import 'package:flutter/material.dart';
import 'forget_password_layout.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ForgetPasswordLayout(),
      ),
    );
  }
}
