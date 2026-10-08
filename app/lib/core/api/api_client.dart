import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String liveBaseUrl = 'https://kuwaitsouq.online/api/v1';
  static const String localAndroidUrl = 'http://10.0.2.2:8000/api/v1';
  static const String localIosUrl = 'http://127.0.0.1:8000/api/v1';
  static const String localLanUrl = 'http://192.168.18.141:8000/api/v1';

  static String? overrideBaseUrl;

  static String get baseUrl {
    if (overrideBaseUrl != null && overrideBaseUrl!.isNotEmpty) {
      return overrideBaseUrl!;
    }

    const customUrl = String.fromEnvironment('API_URL');
    if (customUrl.isNotEmpty) {
      return customUrl;
    }

    const useLocal = bool.fromEnvironment('USE_LOCAL', defaultValue: !kReleaseMode);
    if (useLocal) {
      return defaultTargetPlatform == TargetPlatform.android
          ? localAndroidUrl
          : localIosUrl;
    }

    return liveBaseUrl;
  }

  static String get baseStorageUrl {
    return '${baseUrl.replaceAll('/api/v1', '')}/storage';
  }

  static const _storage = FlutterSecureStorage();
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 12),
      headers: {'Accept': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        debugPrint('🌐 [ApiClient REQUEST] ${options.method} ${options.uri}');
        if (options.data != null) {
          if (options.data is Map) {
            final sanitized = Map<String, dynamic>.from(options.data as Map);
            if (sanitized.containsKey('password')) sanitized['password'] = '******';
            if (sanitized.containsKey('password_confirmation')) sanitized['password_confirmation'] = '******';
            debugPrint('   Payload: $sanitized');
          } else {
            debugPrint('   Payload: ${options.data}');
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('✅ [ApiClient RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        debugPrint('🚨 [ApiClient ERROR] Status: ${error.response?.statusCode} | URL: ${error.requestOptions.uri}');
        debugPrint('   Error message: ${error.message}');

        // Auto-fallback: if local dev server is unreachable, seamlessly fall back to live backend
        if ((error.type == DioExceptionType.connectionError ||
             error.type == DioExceptionType.connectionTimeout) &&
            !_dio.options.baseUrl.contains('kuwaitsouq.com')) {
          debugPrint('🔄 [ApiClient] Local dev backend unreachable. Falling back to liveBaseUrl ($liveBaseUrl)...');
          _dio.options.baseUrl = liveBaseUrl;

          try {
            final opts = error.requestOptions;
            final retryResponse = await _dio.request(
              opts.path,
              data: opts.data,
              queryParameters: opts.queryParameters,
              options: Options(
                method: opts.method,
                headers: opts.headers,
              ),
            );
            return handler.resolve(retryResponse);
          } catch (retryError) {
            return handler.next(error);
          }
        }

        return handler.next(error);
      },
    ));
  }

  // Auth
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final res = await _dio.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });
    return res.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post('/login', data: {'email': email, 'password': password});
    return res.data;
  }

  Future<Map<String, dynamic>> logout() async {
    final res = await _dio.post('/logout');
    return res.data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await _dio.get('/me');
    return res.data;
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    final res = await _dio.delete('/account');
    return res.data is Map<String, dynamic> ? Map<String, dynamic>.from(res.data) : {'message': 'Account deleted'};
  }

  // Ads
  Future<List<dynamic>> getAds({
    String? search,
    int? categoryId,
    int? locationId,
    int? countryId,
    String? countryCode,
    double? minPrice,
    double? maxPrice,
    String? condition,
    String? sortBy,
    Map<String, dynamic>? filterAttributes,
    Map<String, dynamic>? extraParams,
  }) async {
    String path;
    Map<String, dynamic> query = {};
    if (search != null && search.isNotEmpty) {
      path = '/ads/search';
      query['q'] = search;
    } else {
      path = '/ads';
    }
    if (categoryId != null) query['category_id'] = categoryId;
    if (locationId != null) query['location_id'] = locationId;
    if (countryId != null) query['country_id'] = countryId;
    if (countryCode != null && countryCode.isNotEmpty) query['country_code'] = countryCode;
    if (minPrice != null) query['min_price'] = minPrice;
    if (maxPrice != null) query['max_price'] = maxPrice;
    if (condition != null && condition.isNotEmpty && condition != 'all') query['condition'] = condition;
    if (sortBy != null && sortBy.isNotEmpty) query['sort_by'] = sortBy;
    if (filterAttributes != null) {
      filterAttributes.forEach((k, v) {
        if (v != null && v.toString().isNotEmpty) {
          query[k] = v;
        }
      });
    }
    if (extraParams != null) {
      query.addAll(extraParams);
    }

    final res = await _dio.get(path, queryParameters: query);
    if (res.data is List) return res.data;
    if (res.data is Map && res.data['data'] != null) {
      final d = res.data['data'];
      if (d is List) return d;
      if (d is Map && d['data'] is List) return d['data'];
    }
    return [];
  }

  // Category Filters & Badges
  Future<Map<String, dynamic>> getCategoryFilters(int categoryId) async {
    final res = await _dio.get('/categories/$categoryId/filters');
    return res.data is Map<String, dynamic> ? Map<String, dynamic>.from(res.data) : {};
  }

  Future<Map<String, dynamic>> getAd(int id) async {
    final res = await _dio.get('/ads/$id');
    if (res.data is Map) {
      if (res.data['data'] is Map && res.data['data']['ad'] != null) {
        return Map<String, dynamic>.from(res.data['data']['ad']);
      } else if (res.data['data'] is Map) {
        return Map<String, dynamic>.from(res.data['data']);
      }
      return Map<String, dynamic>.from(res.data);
    }
    return {};
  }

  Future<Map<String, dynamic>> createAd(Map<String, dynamic> data) async {
    final res = await _dio.post('/ads', data: data);
    return res.data;
  }

  Future<Map<String, dynamic>> updateAd(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/ads/$id', data: data);
    return res.data;
  }

  Future<void> deleteAd(int id) async {
    await _dio.delete('/ads/$id');
  }

  Future<void> uploadAdMedia(int adId, String filePath, {String type = 'image'}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      'type': type,
    });
    await _dio.post('/ads/$adId/media', data: formData);
  }

  // Categories
  Future<List<dynamic>> getCategories({dynamic parentId}) async {
    final Map<String, dynamic> query = {};
    if (parentId != null) query['parent_id'] = parentId;
    final res = await _dio.get('/categories', queryParameters: query);
    if (res.data is List) return res.data;
    if (res.data is Map && res.data['data'] != null) {
      final inner = res.data['data'];
      return inner is List ? inner : (inner['data'] is List ? inner['data'] : []);
    }
    return [];
  }

  // Countries & Locations
  Future<List<dynamic>> getCountries() async {
    final res = await _dio.get('/countries');
    if (res.data is List) return res.data;
    if (res.data is Map && res.data['data'] != null) {
      final inner = res.data['data'];
      return inner is List ? inner : [];
    }
    return [];
  }

  Future<List<dynamic>> getCities(int countryId) async {
    final res = await _dio.get('/countries/$countryId/cities');
    if (res.data is List) return res.data;
    if (res.data is Map && res.data['data'] != null) {
      final inner = res.data['data'];
      return inner is List ? inner : [];
    }
    return [];
  }

  // Locations (backward compatible)
  Future<List<dynamic>> getLocations() async {
    return await getCountries();
  }

  // Messages
  Future<List<dynamic>> getMessages({int? adId}) async {
    final query = adId != null ? '?ad_id=$adId' : '';
    final res = await _dio.get('/messages$query');
    return res.data is List ? res.data : [];
  }

  Future<Map<String, dynamic>> sendMessage(int receiverId, String content, {int? adId}) async {
    final res = await _dio.post('/messages', data: {
      'receiver_id': receiverId,
      'content': content,
      if (adId != null) 'ad_id': adId,
    });
    return res.data;
  }

  // Phone Authentication
  Future<Map<String, dynamic>> phoneAuth(String phone, {String? phoneCode, String? name}) async {
    final res = await _dio.post('/auth/phone', data: {
      'phone': phone,
      if (phoneCode != null) 'phone_code': phoneCode,
      if (name != null) 'name': name,
    });
    return res.data is Map<String, dynamic> ? Map<String, dynamic>.from(res.data) : {};
  }

  // Profile update
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final res = await _dio.put('/me', data: data);
    return res.data is Map<String, dynamic> ? Map<String, dynamic>.from(res.data) : {};
  }

  // Favorites / Saved Ads
  Future<List<dynamic>> getFavorites() async {
    final res = await _dio.get('/favorites');
    if (res.data is List) return res.data;
    if (res.data is Map && res.data['data'] != null) {
      final inner = res.data['data'];
      return inner is List ? inner : [];
    }
    return [];
  }

  Future<Map<String, dynamic>> toggleFavorite(int adId) async {
    final res = await _dio.post('/ads/$adId/favorite');
    return res.data is Map<String, dynamic> ? Map<String, dynamic>.from(res.data) : {};
  }

  // User Ads
  Future<List<dynamic>> getUserAds() async {
    final res = await _dio.get('/user/ads');
    if (res.data is List) return res.data;
    if (res.data is Map && res.data['data'] != null) {
      final inner = res.data['data'];
      return inner is List ? inner : [];
    }
    return [];
  }

  // Boost Ad
  Future<Map<String, dynamic>> boostAd(int adId) async {
    final res = await _dio.post('/ads/$adId/boost');
    return res.data is Map<String, dynamic> ? Map<String, dynamic>.from(res.data) : {};
  }

  // CarFax & Kayishha
  Future<Map<String, dynamic>> requestCarFax(String vin, {String? phone, int? adId}) async {
    final res = await _dio.post('/reports/carfax', data: {
      'vin': vin,
      if (phone != null) 'phone': phone,
      if (adId != null) 'ad_id': adId,
    });
    return res.data is Map<String, dynamic> ? Map<String, dynamic>.from(res.data) : {};
  }

  Future<Map<String, dynamic>> requestKayishha(Map<String, dynamic> data) async {
    final res = await _dio.post('/services/kayishha', data: data);
    return res.data is Map<String, dynamic> ? Map<String, dynamic>.from(res.data) : {};
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: 'auth_user', value: jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final str = await _storage.read(key: 'auth_user');
    if (str != null && str.isNotEmpty) {
      try {
        return jsonDecode(str) as Map<String, dynamic>;
      } catch (_) {}
    }
    return null;
  }

  static Future<void> clearAuth() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'auth_user');
  }

  static Future<void> clearToken() async {
    await clearAuth();
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
