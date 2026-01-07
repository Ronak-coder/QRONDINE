import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  // Load saved language preference
  Future<void> _loadLanguagePreference() async {
    final languageCode = StorageService.getString('language_code');
    if (languageCode != null && languageCode.isNotEmpty) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);
    await StorageService.saveString('language_code', languageCode);
    notifyListeners();
  }

  // Check if current language is English
  bool get isEnglish => _locale.languageCode == 'en';

  // Check if current language is Hindi
  bool get isHindi => _locale.languageCode == 'hi';

  // Get language display name
  String get languageName {
    switch (_locale.languageCode) {
      case 'hi':
        return 'हिंदी';
      case 'en':
      default:
        return 'English';
    }
  }
}
