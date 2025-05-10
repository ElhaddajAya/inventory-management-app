import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyUserId = 'user_id';
  static const _keyFullName = 'full_name';
  static const _keyRole = 'role';

  static Future<void> setUserData({
    required String userId,
    required String fullName,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyRole, role);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFullName);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyFullName);
    await prefs.remove(_keyRole);
  }
}