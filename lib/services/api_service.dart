import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://www.websonic.org/APPS/TSF/api.php';

  static Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'action': 'signin',
          'email': email,
          'password': password,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> signUp(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'action': 'signup',
          'full_name': fullName,
          'email': email,
          'password': password,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getLocations(String country, String city) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'action': 'getLocations',
          'country': country,
          'city': city,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
} 