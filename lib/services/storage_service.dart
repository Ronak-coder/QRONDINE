import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save string
  static Future<bool> saveString(String key, String value) async {
    return await _preferences?.setString(key, value) ?? false;
  }

  // Get string
  static String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Save int
  static Future<bool> saveInt(String key, int value) async {
    return await _preferences?.setInt(key, value) ?? false;
  }

  // Get int
  static int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  // Save bool
  static Future<bool> saveBool(String key, bool value) async {
    return await _preferences?.setBool(key, value) ?? false;
  }

  // Get bool
  static bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // Save JSON object
  static Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    return await saveString(key, jsonString);
  }

  // Get JSON object
  static Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Save list of JSON objects
  static Future<bool> saveJsonList(String key, List<Map<String, dynamic>> value) async {
    final jsonString = json.encode(value);
    return await saveString(key, jsonString);
  }

  // Get list of JSON objects
  static List<Map<String, dynamic>>? getJsonList(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    
    try {
      final decoded = json.decode(jsonString) as List;
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      return null;
    }
  }

  // Remove key
  static Future<bool> remove(String key) async {
    return await _preferences?.remove(key) ?? false;
  }

  // Clear all
  static Future<bool> clear() async {
    return await _preferences?.clear() ?? false;
  }

  // Check if key exists
  static bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }
}
