import 'package:flutter/material.dart';
import 'home_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: HomeLayout()),
    );
  }
}