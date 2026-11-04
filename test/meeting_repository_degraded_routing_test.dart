import 'package:date_navigation/core/error/failure.dart';
import 'package:date_navigation/core/error/failure_codes.dart';
import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/local/cache_service.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/remote/osrm_remote_data_source.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/remote/places_remote_data_source.dart';
import 'package:date_navigation/features/date_navigation/data/repositories/meeting_repository_impl.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/place.dart';
import 'package:date_navigation/features/date_navigation/domain/value_objects/geo_coordinate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class _FailingOsrm extends OsrmRemoteDataSource {
  _FailingOsrm() : super(client: http.Client(), cache: CacheService());

  @override
  Future<Result<OsrmMeetingData>> getMeetingData({
    required LatLng from,
    required LatLng to,
    double fraction = 0.5,
  }) async {
    return const Err(NetworkFailure(FailureCodes.routingFailed));
  }
}

class _EmptyPlaces extends PlacesRemoteDataSource {
  _EmptyPlaces()
    : super(
        client: http.Client(),
        cache: CacheService(),
        acceptLanguage: () => 'en',
      );

  @override
  Future<List<Place>> findPlacesNearby({
    required double lat,
    required double lon,
    required MeetingFormat format,
    int radius = 800,
    int maxRetries = 0,
    int radiusExpansionDepth = 0,
  }) async {
    return const [];
  }
}

void main() {
  test('OSRM failure yields degraded geometric midpoint success', () async {
    final repo = MeetingRepositoryImpl(_FailingOsrm(), _EmptyPlaces());
    final result = await repo.findMeetingPoint(
      userLocation: const GeoCoordinate(latitude: 53.9, longitude: 27.5),
      partnerLocation: const GeoCoordinate(latitude: 53.95, longitude: 27.6),
      searchRadius: 500,
      format: MeetingFormat.food,
    );

    expect(result, isA<Ok<dynamic>>());
    final meeting = (result as Ok).value;
    expect(meeting.isRoutingDegraded, isTrue);
    expect(meeting.location.latitude, closeTo(53.925, 0.0001));
    expect(meeting.location.longitude, closeTo(27.55, 0.0001));
    expect(meeting.fullRouteGeometry, isEmpty);
  });
}
