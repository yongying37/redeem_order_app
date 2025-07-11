import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/models/volunteer_activity_model.dart';

class VolunteerActivityService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static Future<List<VolunteerActivity>> fetchActivities(String orgId) async {
    final uri = Uri.parse('$baseUrl/common/social-ewallet/charities/$orgId/activities');

    try {
      final response = await http.get(uri);

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData == null || jsonData is! List) {
          print('Warning: API did not return a list as expected.');
          return [];
        }

        return jsonData
            .map<VolunteerActivity>((activity) => VolunteerActivity.fromJson(activity))
            .toList();
      } else {
        print('Failed to load activities from DB. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception occurred while fetching volunteer activities: $e');
      return [];
    }
  }

  static Future<bool> registerForActivity(int userId, int activityId) async {
    final uri = Uri.parse('$baseUrl/common/social-ewallet/activities/register');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'account_user_id': userId,
          'volunteer_activity_id': activityId,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to register: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception while registering: $e');
      throw Exception('Failed to register for activity');
    }
  }

  static Future<List<VolunteerActivity>> fetchRegisteredActivities(int userId) async {
    final uri = Uri.parse('$baseUrl/common/social-ewallet/volunteers/$userId/activities');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data.map<VolunteerActivity>((json) => VolunteerActivity.fromJson(json)).toList();
      } else {
        print('Failed to load registered activities: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching registered activities: $e');
      return [];
    }
  }

}
