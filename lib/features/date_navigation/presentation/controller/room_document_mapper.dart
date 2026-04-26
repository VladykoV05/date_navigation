import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/place.dart';

class RoomDocumentMapper {
  const RoomDocumentMapper();

  latlong.LatLng? parseLatLng(dynamic raw) {
    if (raw == null) return null;
    return latlong.LatLng(raw['lat'], raw['lng']);
  }

  String? nonEmptyTrimmed(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  Place? placeFromFinalChoiceDoc(
    Map<String, dynamic> data,
    String name,
    List<Place> lookup,
  ) {
    final lat = (data['finalChoiceLat'] as num?)?.toDouble();
    final lon = (data['finalChoiceLon'] as num?)?.toDouble();
    if (lat != null && lon != null) {
      return Place(
        name: name,
        lat: lat,
        lon: lon,
        address: nonEmptyTrimmed(data['finalChoiceAddress']),
        type: nonEmptyTrimmed(data['finalChoiceType']),
      );
    }
    for (final place in lookup) {
      if (place.name == name) return place;
    }
    return null;
  }

  DateTime? parseUpdatedAt(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    return null;
  }

  List<latlong.LatLng> parseRoutePoints(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (point) => latlong.LatLng(
            (point['lat'] as num?)?.toDouble() ?? 0,
            (point['lng'] as num?)?.toDouble() ?? 0,
          ),
        )
        .where((p) => p.latitude != 0 || p.longitude != 0)
        .toList(growable: false);
  }

  List<Place> parsePlaces(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (item) => Place(
            name: (item['name'] ?? '').toString(),
            lat: (item['lat'] as num?)?.toDouble() ?? 0.0,
            lon: (item['lon'] as num?)?.toDouble() ?? 0.0,
            address: item['address']?.toString(),
            type: item['type']?.toString(),
          ),
        )
        .where((p) => p.name.isNotEmpty)
        .toList(growable: false);
  }

  Map<String, int> buildVoteCounts(Map<String, String> votes) {
    final counts = <String, int>{};
    for (final placeName in votes.values) {
      counts[placeName] = (counts[placeName] ?? 0) + 1;
    }
    return counts;
  }

  DateScenario? parseSelectedScenario(dynamic raw) {
    if (raw is! Map) return null;
    final parsed = DateScenario.fromMap(Map<String, dynamic>.from(raw));
    return parsed.id.isEmpty ? null : parsed;
  }
}
