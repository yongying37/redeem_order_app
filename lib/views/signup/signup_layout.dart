import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/signup_model.dart';
import 'package:redeem_order_app/services/auth_service.dart';
import 'package:redeem_order_app/views/login/login_page.dart';
import 'package:redeem_order_app/views/signup/success_signup_page.dart';

class SignUpLayout extends StatefulWidget {
  const SignUpLayout({super.key});

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cfmPasswordController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? _selectedGender;

  final AuthService _authService = AuthService();

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

          _buildInputField(Icons.person, 'Username', _usernameController),
          const SizedBox(height: 15),

          _buildInputField(Icons.email, 'Email', _emailController),
          const SizedBox(height: 15),

          _buildInputField(Icons.lock, 'Password', _passwordController, obscure: true),
          const SizedBox(height: 15),

          _buildInputField(Icons.lock_outline, 'Confirm Password', _cfmPasswordController, obscure: true),
          const SizedBox(height: 15),

          _buildInputField(Icons.phone, 'Contact Number', _contactController),
          const SizedBox(height: 15),

          _buildDropdownField(),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSignUp,
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

  void _handleSignUp() async {
    print('Register button clicked');
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _cfmPasswordController.text;
    final contact = _contactController.text.trim();
    final gender = _selectedGender;
    print('Fields gathered: $username, $email, $gender');

    if (username.isEmpty || email.isEmpty || password.isEmpty ||
        confirmPassword.isEmpty || contact.isEmpty || gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
            'Password must be at least 8 characters long, include a capital letter, number, and special character')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final contactRegex = RegExp(r'^[89]\d{7}$');
    if (!contactRegex.hasMatch(contact)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
            'Contact number must start with 8 or 9 and be 8 digits long')),
      );
    }

    final request = SignupRequest(
      name: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      contactNumber: contact,
      gender: gender,
    );

    try {
      final success = await _authService.signup(request);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessSignupPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed. Please try again.')),
        );
      }
    } catch (e) {
      final error = e.toString().toLowerCase();
      if (error.contains('username already in use')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username already in use.')),
        );
      } else if (error.contains('email already in use')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already in use.')),
        );
      } else if (error.contains('contact number already in use')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact number already in use.')),
        );
      }
    }
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
