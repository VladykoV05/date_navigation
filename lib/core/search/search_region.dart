import 'dart:convert';

class SearchRegion {
  const SearchRegion({
    required this.id,
    required this.label,
    this.countryCode,
    this.city,
    this.latitude,
    this.longitude,
    this.radiusKm,
  });

  final String id;
  final String label;
  final String? countryCode;
  final String? city;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;

  bool get isGlobal => id == global.id;
  bool get hasCenter => latitude != null && longitude != null;

  String get cacheKey => [
    id,
    countryCode ?? '',
    latitude?.toStringAsFixed(3) ?? '',
    longitude?.toStringAsFixed(3) ?? '',
  ].join('_');

  static const global = SearchRegion(id: 'global', label: 'Весь мир');

  static const minsk = SearchRegion(
    id: 'minsk',
    label: 'Минск',
    countryCode: 'by',
    city: 'Minsk',
    latitude: 53.9045,
    longitude: 27.5615,
    radiusKm: 45,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    if (countryCode != null) 'countryCode': countryCode,
    if (city != null) 'city': city,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    if (radiusKm != null) 'radiusKm': radiusKm,
  };

  static SearchRegion fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? global.id;
    if (id == global.id) return global;
    if (id == minsk.id) return minsk;
    return SearchRegion(
      id: id,
      label: json['label'] as String? ?? id,
      countryCode: json['countryCode'] as String?,
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      radiusKm: (json['radiusKm'] as num?)?.toDouble(),
    );
  }

  static SearchRegion fromStorage(String? raw) {
    if (raw == null || raw.isEmpty) return global;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return fromJson(decoded);
    } catch (_) {
      return global;
    }
    return global;
  }
}
