import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/meeting_point.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/route_info.dart';
import '../../domain/repositories/meeting_repository.dart';
import '../datasources/remote/osrm_remote_data_source.dart';
import '../datasources/remote/places_remote_data_source.dart';

class MeetingRepositoryImpl implements MeetingRepository {
  final OsrmRemoteDataSource _osrm;
  final PlacesRemoteDataSource _places;
  MeetingRepositoryImpl(this._osrm, this._places);

  @override
  Future<Result<MeetingPoint>> findMeetingPoint({
    required latlong.LatLng userLocation,
    required latlong.LatLng partnerLocation,
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
    required latlong.LatLng userLocation,
    required latlong.LatLng partnerLocation,
    required int searchRadius,
    required MeetingFormat format,
  }) async {
    try {
      final osrmResult = await _osrm.getMeetingData(
        from: userLocation,
        to: partnerLocation,
        fraction: 0.5,
      );
      final routeGeometry = osrmResult.fullPolyline;
      final meetingLocation = osrmResult.meetingPoint;

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
        ),
      );
    } catch (e, stack) {
      AppLogger.e('MeetingRepositoryImpl failed', e, stack);
      return const Err(UnknownFailure('Не удалось рассчитать точку встречи'));
    }
  }

}
