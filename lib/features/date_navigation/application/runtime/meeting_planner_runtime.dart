import 'dart:async';

import '../../config/format_chip_config.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/value_objects/geo_coordinate.dart';

class MeetingPlannerRuntime {
  String? _lastMeetingKey;
  Future<void>? _meetingInFlight;
  Future<void>? _partnerFallbackInFlight;
  int _meetingRequestSeq = 0;
  int _lastFetchedPlacesRadius = 0;
  String? _lastFilterCacheKey;
  List<Place> _lastFilterCacheValue = const [];
  bool _meetingRecalculatePending = false;

  int nextMeetingRequest() => ++_meetingRequestSeq;

  bool isStaleRequest(int requestId) => requestId != _meetingRequestSeq;

  bool get isMeetingInFlight => _meetingInFlight != null;

  bool get isPartnerFallbackInFlight => _partnerFallbackInFlight != null;

  bool canReuseMeetingResult({
    required String meetingKey,
    required bool hasCenterPoint,
  }) {
    return _lastMeetingKey == meetingKey && hasCenterPoint;
  }

  bool shouldSkipRadiusFetch(double searchRadius) {
    return _lastFetchedPlacesRadius > 0 &&
        searchRadius <= _lastFetchedPlacesRadius;
  }

  void markMeetingCalculated({
    required String meetingKey,
    required int fetchedRadius,
  }) {
    _lastMeetingKey = meetingKey;
    _lastFetchedPlacesRadius = fetchedRadius;
  }

  void markFetchedRadius(int fetchedRadius) {
    _lastFetchedPlacesRadius = fetchedRadius;
  }

  void syncFetchedRadiusFromSnapshot(int? snapshotRadius) {
    if (snapshotRadius != null && snapshotRadius > 0) {
      _lastFetchedPlacesRadius = snapshotRadius;
    }
  }

  void resetOnPointsChanged() {
    _lastMeetingKey = null;
    _lastFetchedPlacesRadius = 0;
    _lastFilterCacheKey = null;
    _lastFilterCacheValue = const [];
  }

  void resetAll() {
    _meetingInFlight = null;
    _partnerFallbackInFlight = null;
    _meetingRecalculatePending = false;
    resetOnPointsChanged();
  }

  void requestMeetingRecalculate() {
    _meetingRecalculatePending = true;
  }

  bool consumeMeetingRecalculateRequest() {
    if (!_meetingRecalculatePending) return false;
    _meetingRecalculatePending = false;
    return true;
  }

  Future<void> runMeetingTask(Future<void> Function() task) async {
    if (_meetingInFlight != null) return;
    _meetingInFlight = () async {
      try {
        await task();
      } finally {
        _meetingInFlight = null;
      }
    }();
    await _meetingInFlight;
  }

  Future<void> runPartnerFallbackTask(Future<void> Function() task) async {
    if (_partnerFallbackInFlight != null) return;
    _partnerFallbackInFlight = () async {
      try {
        await task();
      } finally {
        _partnerFallbackInFlight = null;
      }
    }();
    await _partnerFallbackInFlight;
  }

  String buildMeetingKey({
    required GeoCoordinate point1,
    required GeoCoordinate point2,
    required int searchRadius,
    required MeetingFormat format,
  }) {
    return '${point1.latitude.toStringAsFixed(6)},${point1.longitude.toStringAsFixed(6)}|'
        '${point2.latitude.toStringAsFixed(6)},${point2.longitude.toStringAsFixed(6)}|'
        '$searchRadius|${format.wireValue}';
  }

  List<Place> computeFilteredPlaces({
    required List<Place> places,
    required GeoCoordinate? point1,
    required GeoCoordinate? point2,
    required String? selectedType,
    required GeoCoordinate? centerPoint,
    required double searchRadius,
    MeetingFormat? meetingFormat,
  }) {
    final placesSig = _placesSignature(places);
    final key =
        '$placesSig|'
        '${point1?.latitude.toStringAsFixed(5)}:${point1?.longitude.toStringAsFixed(5)}|'
        '${point2?.latitude.toStringAsFixed(5)}:${point2?.longitude.toStringAsFixed(5)}|'
        '${centerPoint?.latitude.toStringAsFixed(5)}:${centerPoint?.longitude.toStringAsFixed(5)}|'
        '${searchRadius.toStringAsFixed(0)}|$selectedType|${meetingFormat?.wireValue}';
    if (key == _lastFilterCacheKey) {
      return _lastFilterCacheValue;
    }

    final byRadius = centerPoint == null
        ? List<Place>.from(places)
        : places
              .where(
                (p) =>
                    p.distanceTo(centerPoint.latitude, centerPoint.longitude) <=
                    searchRadius,
              )
              .toList();
    var filtered = selectedType == null
        ? byRadius
        : byRadius.where((p) => p.matchesType(selectedType)).toList();
    filtered.sort(
      (a, b) =>
          scorePlace(
            b,
            point1: point1,
            point2: point2,
            meetingFormat: meetingFormat,
          ).compareTo(
            scorePlace(
              a,
              point1: point1,
              point2: point2,
              meetingFormat: meetingFormat,
            ),
          ),
    );
    _lastFilterCacheKey = key;
    _lastFilterCacheValue = filtered;
    return filtered;
  }

  double scorePlace(
    Place place, {
    required GeoCoordinate? point1,
    required GeoCoordinate? point2,
    MeetingFormat? meetingFormat,
  }) {
    if (point1 == null || point2 == null) return 0.0;
    final d1 = place.distanceTo(point1.latitude, point1.longitude);
    final d2 = place.distanceTo(point2.latitude, point2.longitude);
    final avg = (d1 + d2) / 2.0;
    final balance = 1 - ((d1 - d2).abs() / (d1 + d2 + 1));
    final proximity = 1 - (avg / 3000).clamp(0, 1);
    final typeBonus = switch (place.type) {
      'restaurant' => 0.05,
      'cafe' => 0.03,
      _ => 0.0,
    };
    final formatBonus = _formatBonus(place, meetingFormat);
    return (balance * 0.7 + proximity * 0.3 + typeBonus + formatBonus).clamp(
      0.0,
      1.0,
    );
  }

  double _formatBonus(Place place, MeetingFormat? meetingFormat) {
    if (meetingFormat == null || place.types.isEmpty) return 0.0;
    var maxBonus = 0.0;
    for (final type in place.types) {
      final bonus = FormatChipConfig.bonusForType(meetingFormat, type);
      if (bonus > maxBonus) {
        maxBonus = bonus;
      }
    }
    return maxBonus;
  }

  String _placesSignature(List<Place> places) {
    if (places.isEmpty) return '0';
    final first = places.first;
    final last = places.last;
    return '${places.length}|'
        '${first.name}:${first.lat.toStringAsFixed(5)}:${first.lon.toStringAsFixed(5)}|'
        '${last.name}:${last.lat.toStringAsFixed(5)}:${last.lon.toStringAsFixed(5)}';
  }
}
