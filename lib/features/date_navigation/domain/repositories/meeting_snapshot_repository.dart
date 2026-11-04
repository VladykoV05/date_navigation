import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../entities/place.dart';
import '../value_objects/geo_coordinate.dart';

abstract interface class MeetingSnapshotRepository {
  Future<Result<void>> saveMeetingSnapshot({
    required String roomId,
    required GeoCoordinate centerPoint,
    required List<GeoCoordinate> routePoints,
    required List<Place> places,
    required int searchRadius,
    required MeetingFormat meetingFormat,
  });
}
