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
}
