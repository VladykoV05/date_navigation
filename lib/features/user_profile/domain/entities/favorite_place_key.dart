class FavoritePlaceKey {
  const FavoritePlaceKey({required this.placeName, this.lat, this.lon});

  factory FavoritePlaceKey.fromPlace({
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return FavoritePlaceKey(placeName: placeName.trim(), lat: lat, lon: lon);
  }

  final String placeName;
  final double? lat;
  final double? lon;

  String get docId {
    final normalized = placeName.trim().toLowerCase();
    final sanitized = normalized.replaceAll(
      RegExp(r'[^a-z0-9а-яё]+', caseSensitive: false),
      '_',
    );
    final latPart = lat?.toStringAsFixed(5) ?? 'na';
    final lonPart = lon?.toStringAsFixed(5) ?? 'na';
    final base = sanitized.isEmpty ? 'favorite_place' : sanitized;
    return '${base}_${latPart}_$lonPart';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FavoritePlaceKey &&
            other.placeName.trim().toLowerCase() ==
                placeName.trim().toLowerCase() &&
            other.lat?.toStringAsFixed(5) == lat?.toStringAsFixed(5) &&
            other.lon?.toStringAsFixed(5) == lon?.toStringAsFixed(5);
  }

  @override
  int get hashCode => Object.hash(
    placeName.trim().toLowerCase(),
    lat?.toStringAsFixed(5),
    lon?.toStringAsFixed(5),
  );
}
