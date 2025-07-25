import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redeem_order_app/models/signup_model.dart';
import 'package:redeem_order_app/models/profile_model.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1';

  Future<bool> signup(SignupRequest request) async {
    final url = Uri.parse('$baseUrl/accounts/users');

    print('Sending POST to $url');
    print('Body: ${jsonEncode(request.toJson())}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('Response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if(response.statusCode == 201) {
        return true;
      } else {
        final Map<String, dynamic> error = jsonDecode(response.body);
        final errorMessage = error['message'] ?? 'Signup failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Signup error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/accounts/users/login');

    print('Sending login request to $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login status: ${response.statusCode}');
      print('Login body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<UserProfile?> getProfile(int userId) async {
    final url = Uri.parse('$baseUrl/accounts/users/$userId');

    print('Fetching profile from $url');

    try {
      final response = await http.get(url);

      print('Profile status: ${response.statusCode}');
      print('Profile body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return UserProfile.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      print('Profile fetch error: $e');
      return null;
    }
  }

  Future<bool> updateProfile({
    required int userId,
    required String username,
    required String phoneNumber,
    required String email,
    String? password,
  }) async {
    final url = Uri.parse('$baseUrl/accounts/users/$userId');

    final data = {
      'account_user_name': username,
      'account_user_contact_number': phoneNumber,
      'account_user_email': email,
    };

    if (password != null && password.isNotEmpty && password != '********') {
      data['account_user_password'] = password;
      data['account_user_confirm_password'] = password;
    }

    print('Sending PUT to $url');
    print('Payload: ${jsonEncode(data)}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Update status: ${response.statusCode}');
      print('Update body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final url = Uri.parse('$baseUrl/accounts/users/reset-password');

    final body = jsonEncode({
      'email': email,
      'new_password': newPassword,
    });

    print('Sending POST to $url');
    print('Payload: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Reset status: ${response.statusCode}');
      print('Reset body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    final url = Uri.parse('$baseUrl/accounts/users/request-reset');

    final body = jsonEncode({'email': email});

    print('Requesting password reset via email to $url');
    print('Payload: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Email reset status: ${response.statusCode}');
      print('Email reset body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending reset email: $e');
      return false;
    }
  }

}
