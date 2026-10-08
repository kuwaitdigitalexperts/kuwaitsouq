import '../api/api_client.dart';

class AdModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String condition;
  final bool isFeatured;
  final bool isUrgent;
  final int? categoryId;
  final int? locationId;
  final int? userId;
  final Map<String, dynamic>? category;
  final Map<String, dynamic>? location;
  final Map<String, dynamic>? user;
  final List<dynamic>? media;
  final String? createdAt;

  const AdModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.condition,
    required this.isFeatured,
    required this.isUrgent,
    this.categoryId,
    this.locationId,
    this.userId,
    this.category,
    this.location,
    this.user,
    this.media,
    this.createdAt,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      currency: json['currency'] as String? ?? 'KD',
      condition: json['condition'] as String? ?? 'used',
      isFeatured: json['is_featured'] == true ||
          json['is_featured'] == 1 ||
          json['is_boosted'] == 1 ||
          json['is_featured'] == '1',
      isUrgent: json['is_urgent'] == true ||
          json['is_urgent'] == 1 ||
          json['is_urgent'] == '1',
      categoryId: int.tryParse(json['category_id']?.toString() ?? ''),
      locationId: int.tryParse(json['location_id']?.toString() ?? json['city_id']?.toString() ?? ''),
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      category: json['category'] is Map
          ? Map<String, dynamic>.from(json['category'] as Map)
          : null,
      location: json['location'] is Map
          ? Map<String, dynamic>.from(json['location'] as Map)
          : (json['city'] is Map ? Map<String, dynamic>.from(json['city'] as Map) : null),
      user: json['user'] is Map
          ? Map<String, dynamic>.from(json['user'] as Map)
          : null,
      media: json['media'] as List<dynamic>?,
      createdAt: json['created_at'] as String?,
    );
  }

  AdModel copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? currency,
    String? condition,
    bool? isFeatured,
    bool? isUrgent,
    int? categoryId,
    int? locationId,
    int? userId,
    Map<String, dynamic>? category,
    Map<String, dynamic>? location,
    Map<String, dynamic>? user,
    List<dynamic>? media,
    String? createdAt,
  }) {
    return AdModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      condition: condition ?? this.condition,
      isFeatured: isFeatured ?? this.isFeatured,
      isUrgent: isUrgent ?? this.isUrgent,
      categoryId: categoryId ?? this.categoryId,
      locationId: locationId ?? this.locationId,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      location: location ?? this.location,
      user: user ?? this.user,
      media: media ?? this.media,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get locationName {
    if (location != null) {
      final name = location!['name'] ?? location!['name_en'] ?? location!['name_ar'] ?? location!['city'];
      final country = location!['country']?['name'] ?? location!['country']?['name_ar'] ?? location!['state'];
      if (name != null && country != null) {
        return '$name, $country';
      }
      return name?.toString() ?? '';
    }
    return 'Kuwait';
  }

  String get categoryName => category?['name'] as String? ?? '';
  String get sellerName => user?['name'] as String? ?? 'Unknown';

  List<String> get images {
    if (media != null && media!.isNotEmpty) {
      final list = <String>[];
      for (final m in media!) {
        String? path;
        String? type;
        if (m is Map) {
          path = m['path'] as String? ?? m['url'] as String? ?? m['file_path'] as String?;
          type = m['type'] as String?;
        } else if (m is String) {
          path = m;
        }
        // Exclude video files from the image list
        if (type == 'video') continue;

        if (path != null && path.isNotEmpty) {
          if (path.startsWith('http')) {
            list.add(path);
          } else {
            var cleanPath = path.startsWith('/') ? path.substring(1) : path;
            if (cleanPath.startsWith('storage/')) {
              cleanPath = cleanPath.substring(8);
            }
            list.add('${ApiClient.baseStorageUrl}/$cleanPath');
          }
        }
      }
      return list;
    }
    return [];
  }

  String? get videoUrl {
    if (media != null && media!.isNotEmpty) {
      for (final m in media!) {
        if (m is Map && m['type'] == 'video') {
          final path = m['path'] as String? ?? m['url'] as String? ?? m['file_path'] as String?;
          if (path != null && path.isNotEmpty) {
            if (path.startsWith('http')) {
              return path;
            } else {
              var cleanPath = path.startsWith('/') ? path.substring(1) : path;
              if (cleanPath.startsWith('storage/')) {
                cleanPath = cleanPath.substring(8);
              }
              return '${ApiClient.baseStorageUrl}/$cleanPath';
            }
          }
        }
      }
    }
    return null;
  }

  bool get hasVideo => videoUrl != null;

  String? get primaryImageUrl {
    if (images.isNotEmpty) {
      return images.first;
    }
    return null;
  }
}

