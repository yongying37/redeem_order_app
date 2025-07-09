import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:redeem_order_app/models/volunteer_organization_model.dart';

class VolunteerOrganizationService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static Future<List<VolunteerOrganization>> fetchVolunteerOrganizations() async {
    final url = Uri.parse('$baseUrl/common/social-ewallet/charities');

    try {
      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData == null || jsonData is! List) {
          print('Warning: API did not return a list as expected.');
          return [];
        }

        return jsonData
            .map<VolunteerOrganization>((org) => VolunteerOrganization.fromJson(org))
            .toList();
      } else {
        print('Failed to load volunteer organizations. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception occurred while fetching volunteer organizations: $e');
      return [];
    }
  }
}
