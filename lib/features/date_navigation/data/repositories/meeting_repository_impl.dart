import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_codes.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/meeting_point.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/route_info.dart';
import '../../domain/repositories/meeting_repository.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../datasources/remote/osrm_remote_data_source.dart';
import '../datasources/remote/places_remote_data_source.dart';
import '../mappers/geo_coordinate_mapper.dart';

class MeetingRepositoryImpl implements MeetingRepository {
  final OsrmRemoteDataSource _osrm;
  final PlacesRemoteDataSource _places;
  MeetingRepositoryImpl(this._osrm, this._places);

  @override
  Future<Result<MeetingPoint>> findMeetingPoint({
    required GeoCoordinate userLocation,
    required GeoCoordinate partnerLocation,
    required int searchRadius,
    required MeetingFormat format,
  }) {
    return _findMeetingPoint(
      userLocation: userLocation,
      partnerLocation: partnerLocation,
      searchRadius: searchRadius,
      format: format,
    );
  }

  Future<Result<MeetingPoint>> _findMeetingPoint({
    required GeoCoordinate userLocation,
    required GeoCoordinate partnerLocation,
    required int searchRadius,
    required MeetingFormat format,
  }) async {
    try {
      final osrmResult = await _osrm.getMeetingData(
        from: GeoCoordinateMapper.toLatLng(userLocation),
        to: GeoCoordinateMapper.toLatLng(partnerLocation),
        fraction: 0.5,
      );
      switch (osrmResult) {
        case Err():
          AppLogger.w('OSRM unavailable — using geometric midpoint (degraded)');
          return await _buildMeetingAround(
            meetingLocation: GeoCoordinate(
              latitude: (userLocation.latitude + partnerLocation.latitude) / 2,
              longitude:
                  (userLocation.longitude + partnerLocation.longitude) / 2,
            ),
            routeGeometry: const [],
            searchRadius: searchRadius,
            format: format,
            isRoutingDegraded: true,
          );
        case Ok(:final value):
          return await _buildMeetingAround(
            meetingLocation: GeoCoordinateMapper.fromLatLng(value.meetingPoint),
            routeGeometry: GeoCoordinateMapper.fromLatLngList(
              value.fullPolyline,
            ),
            searchRadius: searchRadius,
            format: format,
            isRoutingDegraded: false,
          );
      }
    } catch (e, stack) {
      AppLogger.e('MeetingRepositoryImpl failed', e, stack);
      return const Err(UnknownFailure(FailureCodes.meetingPointCalcFailed));
    }
  }

  Future<Result<MeetingPoint>> _buildMeetingAround({
    required GeoCoordinate meetingLocation,
    required List<GeoCoordinate> routeGeometry,
    required int searchRadius,
    required MeetingFormat format,
    required bool isRoutingDegraded,
  }) async {
    List<Place> places = [];
    try {
      places = await _places.findPlacesNearby(
        lat: meetingLocation.latitude,
        lon: meetingLocation.longitude,
        radius: searchRadius,
        format: format,
      );
    } catch (e) {
      AppLogger.e('⚠️ Ошибка PlacesRemoteDataSource: $e');
    }

    return Ok(
      MeetingPoint(
        location: meetingLocation,
        userRoute: const RouteInfo(duration: Duration.zero, distance: 0),
        partnerRoute: const RouteInfo(duration: Duration.zero, distance: 0),
        nearbyPlaces: places,
        fullRouteGeometry: routeGeometry,
        isRoutingDegraded: isRoutingDegraded,
      ),
    );
  }
}
