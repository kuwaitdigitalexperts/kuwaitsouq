import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../constants/country_codes.dart';

class CountryProvider extends ChangeNotifier {
  static const String _prefCountryCodeKey = 'kuwaitsouq_selected_country_code';
  static const String _prefCityKey = 'kuwaitsouq_selected_city';
  static const String _prefIsSavedKey = 'kuwaitsouq_country_is_saved';

  Map<String, dynamic> _currentCountry = AppConstants.gccCountries.first;
  String? _currentCity;
  bool _isCountrySaved = false;
  bool _isInitialized = false;

  Map<String, dynamic> get currentCountry => _currentCountry;
  String? get currentCity => _currentCity;
  bool get isCountrySaved => _isCountrySaved;
  bool get isInitialized => _isInitialized;

  CountryCode get currentCountryCode {
    final code = _currentCountry['code'] as String? ?? 'KW';
    return CountryCodes.all.firstWhere(
      (c) => c.code == code,
      orElse: () => CountryCodes.defaultCountry,
    );
  }

  String get currencySymbol => _currentCountry['currency_symbol'] as String? ?? 'د.ك';
  String get countryNameAr => _currentCountry['name_ar'] as String? ?? 'الكويت';
  String get countryNameEn => _currentCountry['name'] as String? ?? 'Kuwait';
  String get flag => _currentCountry['flag'] as String? ?? '🇰🇼';
  String get dialCode => _currentCountry['dial_code'] as String? ?? '+965';

  CountryProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isCountrySaved = prefs.getBool(_prefIsSavedKey) ?? false;
      final savedCode = prefs.getString(_prefCountryCodeKey);
      _currentCity = prefs.getString(_prefCityKey);

      if (savedCode != null) {
        final match = AppConstants.gccCountries.firstWhere(
          (c) => c['code'] == savedCode,
          orElse: () => AppConstants.gccCountries.first,
        );
        _currentCountry = match;
      }
    } catch (e) {
      debugPrint('Error loading saved country from SharedPreferences: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> selectCountry(
    Map<String, dynamic> country, {
    String? city,
  }) async {
    _currentCountry = country;
    _currentCity = city;
    _isCountrySaved = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefCountryCodeKey, country['code'] as String? ?? 'KW');
      await prefs.setBool(_prefIsSavedKey, true);
      if (city != null && city.isNotEmpty) {
        await prefs.setString(_prefCityKey, city);
      } else {
        await prefs.remove(_prefCityKey);
      }
    } catch (e) {
      debugPrint('Error saving country to SharedPreferences: $e');
    }
  }

  Future<void> selectCity(String? city) async {
    _currentCity = city;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      if (city != null && city.isNotEmpty) {
        await prefs.setString(_prefCityKey, city);
      } else {
        await prefs.remove(_prefCityKey);
      }
    } catch (e) {
      debugPrint('Error saving city to SharedPreferences: $e');
    }
  }
}
