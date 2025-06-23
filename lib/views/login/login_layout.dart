import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';
import 'package:redeem_order_app/views/signup/signup_page.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout({super.key});

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _stayLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text(
            'Login',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),

          _buildInputField(Icons.email, 'Email', _emailController),
          const SizedBox(height: 15),

          _buildInputField(Icons.lock, 'Password', _passwordController, obscure: true),
          const SizedBox(height: 15),

          CheckboxListTile(
            title: const Text("Stay logged in"),
            value: _stayLoggedIn,
            onChanged: (bool? value) {
              setState(() {
                _stayLoggedIn = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final password = _passwordController.text;

                // validate empty fields
                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter both email and password')),
                  );
                  return;
                }

                // validate email format
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid email address')),
                  );
                  return;
                }
                // save `_stayLoggedIn` value to local storage if needed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeLayout()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5689FF),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 18)),
            ),
          ),

          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              );
            },
            child: const Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint, TextEditingController controller, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
