import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String defaultBaseUrl = 'http://192.168.2.6:4000';
  static const String _tokenKey = 'auth_token';
  static const String _baseUrlKey = 'custom_base_url';

  static Future<String> get baseUrl async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseUrlKey) ?? defaultBaseUrl;
  }

  static Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, url);
  }

  static Future<void> clearBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_baseUrlKey);
  }

  static Future<String?> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
