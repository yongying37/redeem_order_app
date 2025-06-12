import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';

class UpdateProfileLayout extends StatefulWidget {
  final String username;
  final String phone;
  final String email;
  final String password;

  const UpdateProfileLayout({
    super.key,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  State<UpdateProfileLayout> createState() => _UpdateProfileLayoutState();
}

class _UpdateProfileLayoutState extends State<UpdateProfileLayout> {
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _phoneController = TextEditingController(text: widget.phone);
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSave() {
    print("Dispatching Profile Update...");
    context.read<ProfileBloc>().add(
      UpdateProfile(
        _usernameController.text,
        _passwordController.text,
        _emailController.text,
        _phoneController.text,
      ),
    );

    print("Navigating back to Profile Page...");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildField("Username", _usernameController),
          _buildField("Phone", _phoneController),
          _buildField("Email", _emailController),
          _buildField("Password", _passwordController, obscure: true),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onSave,
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
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
