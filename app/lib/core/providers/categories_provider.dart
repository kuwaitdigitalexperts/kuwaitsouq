import 'package:flutter/material.dart';
import '../api/api_client.dart';

class CategoriesProvider extends ChangeNotifier {
  final _api = ApiClient();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _locations = [];
  bool _loading = false;

  CategoriesProvider() {
    fetchCategories();
    fetchLocations();
  }

  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get locations => _locations;
  bool get loading => _loading;

  List<Map<String, dynamic>> get topLevel {
    final list = _categories.where((c) {
      final pid = c['parent_id'];
      return pid == null || pid == 0 || pid == '0' || pid == 'null';
    }).toList();

    list.sort((a, b) {
      final int posA = int.tryParse(a['pos']?.toString() ?? '100') ?? 100;
      final int posB = int.tryParse(b['pos']?.toString() ?? '100') ?? 100;
      if (posA != posB) return posA.compareTo(posB);
      final int idA = int.tryParse(a['id']?.toString() ?? '0') ?? 0;
      final int idB = int.tryParse(b['id']?.toString() ?? '0') ?? 0;
      return idA.compareTo(idB);
    });

    return list;
  }

  List<Map<String, dynamic>> childrenOf(dynamic parentId) {
    if (parentId == null) return [];
    final targetIdStr = parentId.toString();

    // 1. Direct children from flat list
    final direct = _categories.where((c) {
      final pid = c['parent_id'];
      return pid != null &&
          pid != 0 &&
          pid != '0' &&
          pid != 'null' &&
          pid.toString() == targetIdStr;
    }).toList();

    if (direct.isNotEmpty) {
      return direct;
    }

    // 2. Nested children array inside parent map
    final parent = _categories.firstWhere(
      (c) => c['id'] != null && c['id'].toString() == targetIdStr,
      orElse: () => {},
    );

    if (parent.containsKey('children') && parent['children'] is List) {
      return (parent['children'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }

    return [];
  }

  Future<void> refresh() async {
    await Future.wait([
      fetchCategories(),
      fetchLocations(),
    ]);
  }

  Future<void> fetchCategories() async {
    _loading = true;
    notifyListeners();
    try {
      final data = await _api.getCategories();
      _categories = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      debugPrint('✅ [CategoriesProvider] Loaded ${_categories.length} categories from DB.');
    } catch (e) {
      debugPrint('🚨 [CategoriesProvider] fetchCategories error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLocations() async {
    try {
      final data = await _api.getLocations();
      _locations = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      debugPrint('✅ [CategoriesProvider] Loaded ${_locations.length} locations from DB.');
    } catch (e) {
      debugPrint('🚨 [CategoriesProvider] fetchLocations error: $e');
    } finally {
      notifyListeners();
    }
  }
}
