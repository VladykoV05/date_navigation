import 'dart:async';

import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/meeting_point.dart';
import '../../domain/entities/place.dart';
import '../../domain/usecases/find_meeting_point.dart';
import '../../domain/usecases/save_meeting_snapshot.dart';

class MeetingExecutionService {
  const MeetingExecutionService({
    required FindMeetingPoint findMeetingPoint,
    required SaveMeetingSnapshot saveMeetingSnapshot,
    required AnalyticsService analytics,
  }) : _findMeetingPoint = findMeetingPoint,
       _saveMeetingSnapshot = saveMeetingSnapshot,
       _analytics = analytics;

  final FindMeetingPoint _findMeetingPoint;
  final SaveMeetingSnapshot _saveMeetingSnapshot;
  final AnalyticsService _analytics;

  Future<Result<MeetingPoint>> calculateMeeting({
    required latlong.LatLng point1,
    required latlong.LatLng point2,
    required int searchRadius,
    required MeetingFormat format,
    required bool trackAnalytics,
  }) async {
    final result = await _findMeetingPoint(
      userLocation: point1,
      partnerLocation: point2,
      searchRadius: searchRadius,
      format: format,
    );
    switch (result) {
      case Err(:final failure):
        if (trackAnalytics) {
          unawaited(
            _analytics.operationFailed(
              operation: 'calculate_meeting',
              failureType: failure.runtimeType.toString(),
            ),
          );
        }
        return Err(failure);
      case Ok(value: final meeting):
        if (trackAnalytics) {
          unawaited(
            _analytics.meetingCalculated(
              placesCount: meeting.nearbyPlaces.length,
            ),
          );
        }
        return Ok(meeting);
    }
  }

  Future<void> saveSnapshot({
    required String roomId,
    required latlong.LatLng centerPoint,
    required List<latlong.LatLng> routePoints,
    required List<Place> places,
    required int searchRadius,
    required MeetingFormat meetingFormat,
  }) async {
    final payload = places
        .map(
          (p) => <String, dynamic>{
            'name': p.name,
            'lat': p.lat,
            'lon': p.lon,
            'address': p.address,
            'type': p.type,
          },
        )
        .toList(growable: false);
    unawaited(
      _saveMeetingSnapshot(
        roomId: roomId,
        centerPoint: centerPoint,
        routePoints: routePoints,
        places: payload,
        searchRadius: searchRadius,
        meetingFormat: meetingFormat,
      ),
    );
  }
}
