import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/ad_model.dart';

class AdsProvider extends ChangeNotifier {
  final _api = ApiClient();
  List<AdModel> _ads = [];
  List<AdModel> _favorites = [];
  List<AdModel> _myAds = [];
  final Set<int> _favoriteIds = {};
  AdModel? _currentAd;
  bool _loading = false;
  String? _error;

  List<AdModel> get ads => _ads;
  List<AdModel> get favorites => _favorites;
  List<AdModel> get myAds => _myAds;
  AdModel? get currentAd => _currentAd;
  bool get loading => _loading;
  String? get error => _error;

  bool isFavorite(int adId) => _favoriteIds.contains(adId);

  Future<void> fetchAds({
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
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      debugPrint('📡 [AdsProvider.fetchAds] Fetching ads (cat=$categoryId, loc=$locationId, country=$countryCode, q=$search, attrs=$filterAttributes)');
      final data = await _api.getAds(
        search: search,
        categoryId: categoryId,
        locationId: locationId,
        countryId: countryId,
        countryCode: countryCode,
        minPrice: minPrice,
        maxPrice: maxPrice,
        condition: condition,
        sortBy: sortBy,
        filterAttributes: filterAttributes,
        extraParams: extraParams,
      );
      _ads = data.map((j) {
        try {
          return AdModel.fromJson(Map<String, dynamic>.from(j as Map));
        } catch (parseErr) {
          debugPrint('⚠️ [AdsProvider] Error parsing ad item: $parseErr | item: $j');
          rethrow;
        }
      }).toList();
      debugPrint('✅ [AdsProvider.fetchAds] Loaded ${_ads.length} ads successfully');
    } catch (e) {
      debugPrint('❌ [AdsProvider.fetchAds] Error: $e');
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAd(int id) async {
    final existing = _ads.where((a) => a.id == id).firstOrNull;
    if (existing != null) {
      _currentAd = existing;
    }
    // Only show full loading spinner if we don't already have an ad in memory
    _loading = _currentAd == null;
    _error = null;
    notifyListeners();
    try {
      final data = await _api.getAd(id);
      final fetched = AdModel.fromJson(Map<String, dynamic>.from(data));
      if ((fetched.media == null || fetched.media!.isEmpty) &&
          (existing?.media != null && existing.media!.isNotEmpty)) {
        _currentAd = fetched.copyWith(media: existing.media);
      } else {
        _currentAd = fetched;
      }
    } catch (e) {
      debugPrint('❌ [AdsProvider.fetchAd] Error: $e');
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> postAd(
    Map<String, dynamic> data, {
    String? imagePath,
    List<String>? imagePaths,
    String? videoPath,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      debugPrint('📤 [AdsProvider.postAd] Submitting ad: $data');
      final created = await _api.createAd(data);
      final rawId = created['id'];
      final adId = int.tryParse(rawId?.toString() ?? '') ?? (rawId is int ? rawId : null);
      debugPrint('✅ [AdsProvider.postAd] Ad created: id=$adId');

      if (adId != null) {
        // Collect all images to upload (up to 4)
        final imagesToUpload = <String>[];
        if (imagePaths != null && imagePaths.isNotEmpty) {
          imagesToUpload.addAll(imagePaths);
        } else if (imagePath != null && imagePath.isNotEmpty) {
          imagesToUpload.add(imagePath);
        }

        // Upload images
        for (final img in imagesToUpload.take(4)) {
          debugPrint('📸 [AdsProvider.postAd] Uploading image: $img');
          await _api.uploadAdMedia(adId, img, type: 'image');
        }

        // Upload video (if provided, 1 video)
        if (videoPath != null && videoPath.isNotEmpty) {
          debugPrint('🎥 [AdsProvider.postAd] Uploading video: $videoPath');
          await _api.uploadAdMedia(adId, videoPath, type: 'video');
        }
        debugPrint('✅ [AdsProvider.postAd] All media uploaded successfully!');
      }
      await fetchAds();
      return true;
    } catch (e) {
      debugPrint('❌ [AdsProvider.postAd] Error: $e');
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAd(int id) async {
    try {
      await _api.deleteAd(id);
      _ads.removeWhere((a) => a.id == id);
      _myAds.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Favorites
  Future<void> fetchFavorites() async {
    try {
      final data = await _api.getFavorites();
      _favorites = data.map((j) => AdModel.fromJson(Map<String, dynamic>.from(j as Map))).toList();
      _favoriteIds.clear();
      for (final f in _favorites) {
        if (f.id != null) _favoriteIds.add(f.id!);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    }
  }

  Future<bool> toggleFavorite(int adId) async {
    final willFavorite = !_favoriteIds.contains(adId);
    if (willFavorite) {
      _favoriteIds.add(adId);
      final adMatch = _ads.where((a) => a.id == adId).firstOrNull;
      if (adMatch != null && !_favorites.any((f) => f.id == adId)) {
        _favorites.insert(0, adMatch);
      }
    } else {
      _favoriteIds.remove(adId);
      _favorites.removeWhere((f) => f.id == adId);
    }
    notifyListeners();

    try {
      final res = await _api.toggleFavorite(adId);
      return res['is_favorited'] == true;
    } catch (e) {
      debugPrint('Error toggling favorite on backend: $e');
      return willFavorite;
    }
  }

  // User Ads
  Future<void> fetchMyAds() async {
    try {
      final data = await _api.getUserAds();
      _myAds = data.map((j) => AdModel.fromJson(Map<String, dynamic>.from(j as Map))).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user ads: $e');
    }
  }

  // Boost Ad
  Future<bool> boostAd(int adId) async {
    try {
      await _api.boostAd(adId);
      final idx = _ads.indexWhere((a) => a.id == adId);
      if (idx != -1) {
        _ads[idx] = _ads[idx].copyWith(isBoosted: true);
      }
      final myIdx = _myAds.indexWhere((a) => a.id == adId);
      if (myIdx != -1) {
        _myAds[myIdx] = _myAds[myIdx].copyWith(isBoosted: true);
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error boosting ad: $e');
      return false;
    }
  }

  // CarFax & Kayishha
  Future<Map<String, dynamic>> requestCarFax(String vin, {String? phone, int? adId}) async {
    return await _api.requestCarFax(vin, phone: phone, adId: adId);
  }

  Future<Map<String, dynamic>> requestKayishha(Map<String, dynamic> data) async {
    return await _api.requestKayishha(data);
  }
}
