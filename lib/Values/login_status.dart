import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _role = 'role';
  static const _course = 'course';
  bool faculty = false;
  static const String woxUrl = "http://52.20.1.249:5000";
  static const String jobsUrl = "http://10.106.16.71:8000";

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

  Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }
}
