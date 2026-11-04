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

  static String _normalizeName(String name) => name
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9а-яё]+', caseSensitive: false), '_');

  String get _normalizedName => _normalizeName(placeName);

  String get docId {
    final normalized = _normalizedName;
    final base = normalized.isEmpty ? 'favorite_place' : normalized;
    final latPart = lat?.toStringAsFixed(5) ?? 'na';
    final lonPart = lon?.toStringAsFixed(5) ?? 'na';
    return '${base}_${latPart}_$lonPart';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FavoritePlaceKey &&
            other._normalizedName == _normalizedName &&
            other.lat?.toStringAsFixed(5) == lat?.toStringAsFixed(5) &&
            other.lon?.toStringAsFixed(5) == lon?.toStringAsFixed(5);
  }

  @override
  int get hashCode => Object.hash(
    _normalizedName,
    lat?.toStringAsFixed(5),
    lon?.toStringAsFixed(5),
  );
}
