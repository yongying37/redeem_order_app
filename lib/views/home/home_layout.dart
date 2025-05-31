import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeLayout> {

  Widget homeTitle() {
    return const Text('Welcome to Home Page');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              homeTitle()
            ],
          )
      )
    );
  }
}