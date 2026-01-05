import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import '../config/constants.dart';

class UserProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Initialize
  Future<void> initialize() async {
    await loadThemeMode();
  }

  // Load theme mode from storage
  Future<void> loadThemeMode() async {
    try {
      final isDark = StorageService.getBool(AppConstants.themeKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load theme mode: $e');
    }
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await StorageService.saveBool(AppConstants.themeKey, _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await StorageService.saveBool(AppConstants.themeKey, mode == ThemeMode.dark);
    notifyListeners();
  }
}
