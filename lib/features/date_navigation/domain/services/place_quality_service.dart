import '../entities/place.dart';
import '../entities/place_type.dart';
import '../policies/place_quality_policy.dart';

class PlaceQualityService {
  const PlaceQualityService();

  bool isUsablePlace(Place place) {
    final name = place.name.trim();
    if (name.isEmpty || name.length < 2) return false;
    final primaryType = place.primaryType;
    final isNatureWalkPlace =
        primaryType != null && primaryType.isNatureWalk ||
        place.types.any(
          (wireType) => PlaceType.tryParse(wireType)?.isNatureWalk ?? false,
        );
    final hasAddressOrRating =
        (place.address?.trim().isNotEmpty ?? false) ||
        (place.rating != null && place.rating! > 0);
    // Parks/viewpoints often have neither address nor rating in OSM.
    if (!hasAddressOrRating && !isNatureWalkPlace) return false;
    final lower = name.toLowerCase();
    final type = (place.type ?? '').toLowerCase();
    final blocked = {
      'заведение',
      'кафе',
      'ресторан',
      'бар',
      PlaceType.fastFood.wireValue,
    };
    if (blocked.contains(lower)) return false;
    const blockedTypes = PlaceQualityPolicy.blockedPlaceTypes;
    if (blockedTypes.contains(type)) return false;
    const blockedNameParts = PlaceQualityPolicy.blockedPlaceNameParts;
    if (blockedNameParts.any(lower.contains)) return false;
    if (_isGenericGreenArea(type: type, normalizedName: lower)) return false;
    return true;
  }

  bool _isGenericGreenArea({
    required String type,
    required String normalizedName,
  }) {
    final placeType = PlaceType.tryParse(type);
    if (placeType == null || !placeType.isGreenArea) return false;
    // OSM/Nominatim sometimes returns generic polygons named only "Парк"/"Park".
    const genericNames = {
      'park',
      'парк',
      'городской парк',
      'городской сад',
      'garden',
      'сад',
    };
    return genericNames.contains(normalizedName);
  }

  void rankPlacesByRelevance(
    List<Place> places, {
    required double centerLat,
    required double centerLon,
  }) {
    places.sort((a, b) {
      final sa = _relevanceScore(a, centerLat: centerLat, centerLon: centerLon);
      final sb = _relevanceScore(b, centerLat: centerLat, centerLon: centerLon);
      final byScore = sb.compareTo(sa);
      if (byScore != 0) return byScore;
      final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (byName != 0) return byName;
      final byLat = a.lat.compareTo(b.lat);
      if (byLat != 0) return byLat;
      return a.lon.compareTo(b.lon);
    });
  }

  List<Place> dedupePlaces(List<Place> places) {
    final result = <Place>[];
    for (final place in places) {
      final duplicateIndex = result.indexWhere((existing) {
        final sameType =
            (existing.type ?? '').toLowerCase() ==
            (place.type ?? '').toLowerCase();
        final sameName =
            _normalizeText(existing.name) == _normalizeText(place.name);
        final sameAddress =
            _normalizeText(existing.address ?? '') ==
            _normalizeText(place.address ?? '');
        final isNearby =
            existing.distanceTo(place.lat, place.lon) <=
            PlaceQualityPolicy.dedupeRadiusMeters;
        if (!sameType) return false;
        if (sameName && isNearby) return true;
        return sameAddress && isNearby;
      });
      if (duplicateIndex == -1) {
        result.add(place);
      } else {
        final preferred = _pickPreferred(result[duplicateIndex], place);
        result[duplicateIndex] = preferred;
      }
    }
    return result;
  }

  String _normalizeText(String raw) {
    final lower = raw.trim().toLowerCase();
    if (lower.isEmpty) return '';
    return lower.replaceAll(RegExp(r'\s+'), ' ');
  }

  Place _pickPreferred(Place current, Place candidate) {
    final currentHasAddress = current.address?.trim().isNotEmpty ?? false;
    final candidateHasAddress = candidate.address?.trim().isNotEmpty ?? false;
    if (!currentHasAddress && candidateHasAddress) return candidate;
    if (currentHasAddress && !candidateHasAddress) return current;
    return current.name.length >= candidate.name.length ? current : candidate;
  }

  void stableSortPlaces(List<Place> places) {
    places.sort((a, b) {
      final typeComparison = (a.type ?? '').compareTo(b.type ?? '');
      if (typeComparison != 0) return typeComparison;
      final nameComparison = a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      );
      if (nameComparison != 0) return nameComparison;
      final latitudeComparison = a.lat.compareTo(b.lat);
      if (latitudeComparison != 0) return latitudeComparison;
      return a.lon.compareTo(b.lon);
    });
  }

  double _relevanceScore(
    Place place, {
    required double centerLat,
    required double centerLon,
  }) {
    final d = place.distanceTo(centerLat, centerLon);
    final distanceScore = 1 - (d / 3000).clamp(0, 1);
    final hasAddress = (place.address?.trim().isNotEmpty ?? false) ? 0.2 : 0.0;
    final isGenericName = place.name.toLowerCase().contains(' на ') ? 0.0 : 0.1;
    final typeBonus = place.primaryType?.relevanceBonus ?? 0.0;
    return distanceScore + hasAddress + isGenericName + typeBonus;
  }
}
