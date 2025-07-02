import 'package:flutter/material.dart';
import 'home_layout.dart';

class HomePage extends StatelessWidget {
  final String? userId;
  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: HomeLayout(userId: userId)),
    );
  }
}
