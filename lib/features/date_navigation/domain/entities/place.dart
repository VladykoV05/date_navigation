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
