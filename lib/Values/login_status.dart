import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:woxsen/Values/subjects_list.dart';
import 'package:http/http.dart' as http;

class UserPreferences {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _role = 'role';
  static const _course = 'course';
  bool faculty = false;
  static const _emailKey = 'email';
  static const String woxUrl = "http://10.7.0.23:8080";
  // static const String woxUrl = "http://52.20.1.249:5000";
  static const String jobsUrl = "http://10.106.16.71:8000";
  ListStore store = ListStore();

  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> saveRole(String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_role, role);
  }

  static Future<String> getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_role) ?? '';
  }

  static Future<void> saveCourse(String course) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_course, course);
  }

  static Future<String> getCourse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_course) ?? '';
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> getFaculty() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    faculty = prefs.getString(_role) == 'faculty';
  }

  Future<void> setEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  static Future<void> saveEmail(String email) async {
    // Add this method
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }

  Future<Map<String, dynamic>> getProfile(String email) async {
    print('FETCH PROFILE API URL ' + '${store.woxUrl}/api/fetch_profile');
    print('EMAIL RECEIVED ' + email);

    try {
      String apiUrl = '${store.woxUrl}/api/fetch_profile';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'required': 'profile_details',
          'email': email,
        }),
      );

      print('PROFILE DETAILS' + jsonEncode(jsonDecode(response.body)));
      print('PROFILE DETAILS' +
          jsonEncode(jsonDecode(response.statusCode.toString())));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return {
        'ERROR': 'Something Went Wrong',
      };
    } catch (e) {
      print('ERROR IN FETCHING PROFILE :$e');
      throw Exception('Failed to fetch profile');
    }
  }
}
