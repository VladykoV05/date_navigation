import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../entities/meeting_point.dart';
import '../value_objects/geo_coordinate.dart';

abstract interface class MeetingRepository {
  Future<Result<MeetingPoint>> findMeetingPoint({
    required GeoCoordinate userLocation,
    required GeoCoordinate partnerLocation,
    required int searchRadius,
    required MeetingFormat format,
  });
}
