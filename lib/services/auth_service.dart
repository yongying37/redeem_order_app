import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/signup_model.dart';

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

      return response.statusCode == 201;
    } catch (e) {
      print('Network error: $e');
      return false;
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
        return jsonDecode(response.body); // contains 'message' and 'user'
      } else {
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

}
