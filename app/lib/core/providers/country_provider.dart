import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../constants/app_constants.dart';
import '../constants/country_codes.dart';

class CountryProvider extends ChangeNotifier {
  static const String _prefCityIdKey = 'kuwaitsouq_selected_city_id';
  static const String _prefCityKey = 'kuwaitsouq_selected_city';
  static const String _prefCityArKey = 'kuwaitsouq_selected_city_ar';

  // Strictly Kuwait
  final Map<String, dynamic> _currentCountry = AppConstants.kuwaitCountry;
  
  // Selected Area / City (null = All Kuwait)
  int? _selectedCityId;
  String? _currentCity;
  String? _currentCityAr;
  
  // Dynamic Locations from Live API / Database
  List<Map<String, dynamic>> _locations = [];
  bool _locationsLoading = false;

  bool _isCountrySaved = true;
  bool _isInitialized = false;

  Map<String, dynamic> get currentCountry => _currentCountry;
  int? get selectedCityId => _selectedCityId;
  String? get currentCity => _currentCity;
  String? get currentCityAr => _currentCityAr;
  List<Map<String, dynamic>> get locations => _locations;
  bool get locationsLoading => _locationsLoading;
  bool get isCountrySaved => _isCountrySaved;
  bool get isInitialized => _isInitialized;

  CountryCode get currentCountryCode => CountryCodes.defaultCountry;

  String get currencySymbol => _currentCountry['currency_symbol'] as String? ?? 'د.ك';
  String get countryNameAr => _currentCountry['name_ar'] as String? ?? 'الكويت';
  String get countryNameEn => _currentCountry['name'] as String? ?? 'Kuwait';
  String countryName(bool isArabic) => isArabic ? countryNameAr : countryNameEn;
  String currency(bool isArabic) => isArabic ? 'د.ك' : 'KD';
  String get flag => _currentCountry['flag'] as String? ?? '🇰🇼';
  String get dialCode => _currentCountry['dial_code'] as String? ?? '+965';

  /// Display text for active location filter
  String displayLocation(bool isArabic) {
    if (_selectedCityId == null || _currentCity == null || _currentCity!.isEmpty) {
      return isArabic ? 'كل الكويت' : 'All Kuwait';
    }
    return isArabic ? (_currentCityAr ?? _currentCity!) : _currentCity!;
  }

  CountryProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _selectedCityId = prefs.getInt(_prefCityIdKey);
      _currentCity = prefs.getString(_prefCityKey);
      _currentCityAr = prefs.getString(_prefCityArKey);
      _isCountrySaved = true;
    } catch (e) {
      debugPrint('Error loading saved location from SharedPreferences: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
      // Fetch dynamic Kuwait locations from API
      fetchLocations();
    }
  }

  /// Fetch dynamic Kuwait locations from live backend
  Future<void> fetchLocations() async {
    _locationsLoading = true;
    notifyListeners();

    try {
      final api = ApiClient();
      final data = await api.getLocations();
      _locations = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      debugPrint('✅ [CountryProvider] Loaded ${_locations.length} Kuwait locations from live API');
    } catch (e) {
      debugPrint('🚨 [CountryProvider] Error fetching locations: $e');
    } finally {
      _locationsLoading = false;
      notifyListeners();
    }
  }

  /// Select a Kuwait Area / City
  Future<void> selectArea({
    int? id,
    String? name,
    String? nameAr,
  }) async {
    _selectedCityId = id;
    _currentCity = name;
    _currentCityAr = nameAr;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      if (id != null) {
        await prefs.setInt(_prefCityIdKey, id);
      } else {
        await prefs.remove(_prefCityIdKey);
      }

      if (name != null && name.isNotEmpty) {
        await prefs.setString(_prefCityKey, name);
      } else {
        await prefs.remove(_prefCityKey);
      }

      if (nameAr != null && nameAr.isNotEmpty) {
        await prefs.setString(_prefCityArKey, nameAr);
      } else {
        await prefs.remove(_prefCityArKey);
      }
    } catch (e) {
      debugPrint('Error saving location to SharedPreferences: $e');
    }
  }

  /// Backward-compatible selector for country & city
  Future<void> selectCountry(
    Map<String, dynamic> country, {
    String? city,
  }) async {
    await selectCity(city);
  }

  /// Backward-compatible selector for city by string
  Future<void> selectCity(String? city) async {
    if (city == null || city.isEmpty || city.contains('All') || city.contains('كل')) {
      await selectArea(id: null, name: null, nameAr: null);
      return;
    }

    // Try finding matching location in loaded list
    final match = _locations.cast<Map<String, dynamic>?>().firstWhere(
      (l) => l != null && (l['name'] == city || l['name_ar'] == city),
      orElse: () => null,
    );

    if (match != null) {
      await selectArea(
        id: match['id'] as int?,
        name: match['name'] as String?,
        nameAr: match['name_ar'] as String?,
      );
    } else {
      await selectArea(id: null, name: city, nameAr: city);
    }
  }
}
