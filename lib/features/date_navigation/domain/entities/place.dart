import 'dart:math' show pi, sin, cos, sqrt, asin;

class Place {
  final String name;
  final double lat;
  final double lon;
  final String? address;
  final String? type;
  final double? rating;
  final Set<String> types;

  Place({
    required this.name,
    required this.lat,
    required this.lon,
    this.address,
    this.type,
    this.rating,
    Set<String>? types,
  }) : types = Set.unmodifiable(_buildTypes(type: type, types: types));

  factory Place.fromOverpassJson(Map<String, dynamic> json) {
    final tags = (json['tags'] is Map)
        ? Map<String, dynamic>.from(json['tags'])
        : <String, dynamic>{};

    final amenity = tags['amenity']?.toString().trim().toLowerCase();
    final leisure = tags['leisure']?.toString().trim().toLowerCase();
    final tourism = tags['tourism']?.toString().trim().toLowerCase();
    final sportRaw = tags['sport']?.toString().trim().toLowerCase();
    final sportTypes = sportRaw == null || sportRaw.isEmpty
        ? const <String>[]
        : sportRaw
              .split(RegExp(r'[;,]'))
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .map(_normalizeRawType)
              .whereType<String>()
              .toList(growable: false);
    final inferredTypes = _inferTypes(
      amenity: amenity,
      leisure: leisure,
      tourism: tourism,
      sportTypes: sportTypes,
    );
    final inferredType = inferredTypes.firstOrNull;
    String typeLabel = switch (inferredType) {
      'bar' => 'Бар',
      'restaurant' => 'Ресторан',
      'fast_food' => 'Фастфуд',
      'park' => 'Парк',
      'garden' => 'Сад',
      'viewpoint' => 'Видовая точка',
      'beach' => 'Пляж',
      'fitness_centre' => 'Фитнес',
      'sports_centre' => 'Спорт',
      'swimming_pool' => 'Бассейн',
      'ice_rink' => 'Каток',
      'active_racket' => 'Ракетный спорт',
      'active_climb' => 'Скалолазание',
      'active_dance' => 'Танцы',
      'active_team' => 'Командный спорт',
      'active_mind_body' => 'Йога/пилатес',
      'active_sport' => 'Спорт',
      _ => 'Кафе',
    };

    final String? addrFull = tags['addr:full']?.toString();
    final String? street =
        (tags['addr:street'] ?? tags['contact:street'] ?? tags['addr:place'])
            ?.toString();
    final String? house = tags['addr:housenumber']?.toString();
    final String? city = (tags['addr:city'] ?? tags['addr:place'])?.toString();

    final String? nameRu = tags['name:ru']?.toString();
    final String? name = tags['name']?.toString();
    final String? brand = tags['brand']?.toString();
    final String? operatorName = tags['operator']?.toString();

    String placeName =
        (nameRu?.trim().isNotEmpty == true ? nameRu : null) ??
        (name?.trim().isNotEmpty == true ? name : null) ??
        (brand?.trim().isNotEmpty == true ? brand : null) ??
        (operatorName?.trim().isNotEmpty == true ? operatorName : null) ??
        (street != null && street.trim().isNotEmpty
            ? '$typeLabel на $street'
            : typeLabel);

    final String? address = _buildAddress(
      addrFull: addrFull,
      street: street,
      house: house,
      city: city,
    );
    final rating = _parseRating(tags['rating']);

    return Place(
      name: placeName,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      address: address,
      type: inferredType,
      rating: rating,
      types: inferredTypes.toSet(),
    );
  }

  static double? _parseRating(dynamic raw) {
    if (raw == null) return null;
    final value = double.tryParse(raw.toString().trim().replaceAll(',', '.'));
    if (value == null) return null;
    if (value <= 0) return null;
    return value;
  }

  static List<String> _inferTypes({
    required String? amenity,
    required String? leisure,
    required String? tourism,
    required List<String> sportTypes,
  }) {
    final inferred = <String>[];
    final normalizedAmenity = _normalizeRawType(amenity);
    final normalizedLeisure = _normalizeRawType(leisure);
    final normalizedTourism = _normalizeRawType(tourism);
    if (normalizedAmenity != null) inferred.add(normalizedAmenity);
    if (normalizedLeisure != null) inferred.add(normalizedLeisure);
    if (normalizedTourism != null) inferred.add(normalizedTourism);
    inferred.addAll(sportTypes);
    if (inferred.isEmpty) {
      return const [];
    }
    const priority = [
      'restaurant',
      'cafe',
      'bar',
      'fast_food',
      'cinema',
      'museum',
      'gallery',
      'theatre',
      'swimming_pool',
      'fitness_centre',
      'sports_centre',
      'ice_rink',
      'active_racket',
      'active_climb',
      'active_dance',
      'active_team',
      'active_mind_body',
      'active_sport',
      'park',
      'garden',
      'viewpoint',
    ];
    final set = inferred.toSet();
    final sorted = <String>[
      ...priority.where(set.contains),
      ...set.where((value) => !priority.contains(value)),
    ];
    return sorted;
  }

  static String? _normalizeRawType(String? rawType) {
    if (rawType == null || rawType.isEmpty) return null;
    return switch (rawType) {
      'tennis' ||
      'badminton' ||
      'squash' ||
      'table_tennis' ||
      'padel' => 'active_racket',
      'climbing' || 'bouldering' => 'active_climb',
      'dance' => 'active_dance',
      'football' ||
      'basketball' ||
      'volleyball' ||
      'futsal' ||
      'handball' => 'active_team',
      'yoga' || 'pilates' => 'active_mind_body',
      'swimming' => 'swimming_pool',
      'sports_hall' || 'sport' => 'sports_centre',
      _ => rawType,
    };
  }

  static Set<String> _buildTypes({
    required String? type,
    required Set<String>? types,
  }) {
    final result = <String>{};
    if (types != null) {
      result.addAll(
        types
            .map((value) => value.trim().toLowerCase())
            .where((value) => value.isNotEmpty),
      );
    }
    final normalizedType = type?.trim().toLowerCase();
    if (normalizedType != null && normalizedType.isNotEmpty) {
      result.add(normalizedType);
    }
    if (result.contains('swimming_pool')) result.add('sports_centre');
    return result;
  }

  bool matchesType(String? wantedType) {
    if (wantedType == null || wantedType.isEmpty) return true;
    final wanted = wantedType.trim().toLowerCase();
    if (types.contains(wanted)) return true;
    // Backward-compatible filter behavior: sports centres can appear in pool flows.
    if (wanted == 'swimming_pool' && types.contains('sports_centre')) {
      return true;
    }
    return false;
  }

  static String? _buildAddress({
    required String? addrFull,
    required String? street,
    required String? house,
    required String? city,
  }) {
    final full = addrFull?.trim();
    if (full != null && full.isNotEmpty) return full;

    final st = street?.trim();
    final hn = house?.trim();
    final ct = city?.trim();

    final parts = <String>[];
    if (st != null && st.isNotEmpty) {
      parts.add(hn != null && hn.isNotEmpty ? '$st $hn' : st);
    }
    if (ct != null && ct.isNotEmpty && (parts.isEmpty || parts.first != ct)) {
      parts.add(ct);
    }
    return parts.isEmpty ? null : parts.join(', ');
  }

  double distanceTo(double targetLat, double targetLon) {
    const double earthRadius = 6371000;
    final dLat = _toRadians(targetLat - lat);
    final dLon = _toRadians(targetLon - lon);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat)) *
            cos(_toRadians(targetLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  @override
  String toString() => 'Place(name: $name, lat: $lat, lon: $lon)';
}
