import 'package:flutter/material.dart';
import 'package:redeem_order_app/services/auth_service.dart';

class UpdateProfileLayout extends StatefulWidget {
  final String userId;
  final String username;
  final String phone;
  final String email;
  final String password;
  final String cfmPassword;

  const UpdateProfileLayout({
    super.key,
    required this.userId,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.cfmPassword,
  });

  @override
  State<UpdateProfileLayout> createState() => _UpdateProfileLayoutState();
}

class _UpdateProfileLayoutState extends State<UpdateProfileLayout> {
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _cfmPasswordController;

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _phoneController = TextEditingController(text: widget.phone);
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
    _cfmPasswordController = TextEditingController(text: widget.cfmPassword);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cfmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_passwordController.text != _cfmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final success = await _authService.updateProfile(
      userId: widget.userId,
      username: _usernameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildField("Username", _usernameController),
            _buildField("Phone", _phoneController),
            _buildField("Email", _emailController),
            _buildField("Password", _passwordController, obscure: true),
            _buildField("Confirm Password", _cfmPasswordController, obscure: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSave,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
