import 'package:flutter/material.dart';
import 'package:redeem_order_app/views/login/login_page.dart';
import 'package:redeem_order_app/views/home/home_layout.dart';


class SignUpLayout extends StatefulWidget {
  const SignUpLayout({super.key});

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Sign Up',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),

          // Username
          _buildInputField(Icons.person, 'Username', _usernameController),
          const SizedBox(height: 15),

          // Email
          _buildInputField(Icons.email, 'Email', _emailController),
          const SizedBox(height: 15),

          // Password
          _buildInputField(Icons.lock, 'Password', _passwordController, obscure: true),
          const SizedBox(height: 15),

          // Gender
          _buildDropdownField(),
          const SizedBox(height: 30),

          // Register Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
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
              child: const Text('Register', style: TextStyle(fontSize: 18)),
            ),
          ),

          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text.rich(
              TextSpan(
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    text: 'Log In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
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
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          icon: Icon(Icons.transgender),
          border: InputBorder.none,
          hintText: 'Gender',
        ),
        value: _selectedGender,
        items: ['Male', 'Female', 'Other'].map((gender) {
          return DropdownMenuItem(value: gender, child: Text(gender));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }
}
