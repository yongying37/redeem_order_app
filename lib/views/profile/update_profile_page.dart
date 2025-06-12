import 'package:flutter/material.dart';
import 'update_profile_layout.dart';

class UpdateProfilePage extends StatelessWidget {
  final String username;
  final String phone;
  final String email;
  final String password;

  const UpdateProfilePage({
    super.key,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Profile")),
      body: UpdateProfileLayout(
        username: username,
        phone: phone,
        email: email,
        password: password,
      ),
    );
  }
}
