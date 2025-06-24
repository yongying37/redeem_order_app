import 'package:flutter/material.dart';

class SuccessSignupLayout extends StatelessWidget {
  final VoidCallback onContinue;
  const SuccessSignupLayout({Key? key, required this.onContinue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text (
                'Registration Successful!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Image.asset('assets/images/greenTick.png', fit: BoxFit.cover, width: 180),
              const SizedBox(height: 20),
              const Text(
                'You have successfully signed up for an account! You can now log in and start using the app.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    'Go to Login',
                    style: TextStyle(fontSize: 16),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}