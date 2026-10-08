import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_language_code';

  Locale _locale = const Locale('ar'); // Default to Arabic for Gulf / Kuwait

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';
  bool get isBengali => false;

  LocalizationProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final langCode = prefs.getString(_prefKey);
      if (langCode != null && (langCode == 'ar' || langCode == 'en')) {
        _locale = Locale(langCode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (newLocale.languageCode != 'ar' && newLocale.languageCode != 'en') return;
    if (_locale.languageCode == newLocale.languageCode) return;

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, newLocale.languageCode);
    } catch (e) {
      debugPrint('Error persisting locale: $e');
    }
  }

  void toggleLanguage() {
    if (isArabic) {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('ar'));
    }
  }
}
