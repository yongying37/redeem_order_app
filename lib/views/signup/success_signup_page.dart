import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/login/login_page.dart';
import 'success_signup_layout.dart';

class SuccessSignupPage extends StatelessWidget {
  const SuccessSignupPage({Key? key}) : super(key: key);

  void _handleContinue(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SuccessSignupLayout(onContinue: () => _handleContinue(context)))
    );
  }
}