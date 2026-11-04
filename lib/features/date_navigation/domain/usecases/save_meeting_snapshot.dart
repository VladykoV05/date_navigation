import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../entities/place.dart';
import '../repositories/meeting_snapshot_repository.dart';
import '../value_objects/geo_coordinate.dart';

class SaveMeetingSnapshot {
  final MeetingSnapshotRepository _repo;
  const SaveMeetingSnapshot(this._repo);

  Future<Result<void>> call({
    required String roomId,
    required GeoCoordinate centerPoint,
    required List<GeoCoordinate> routePoints,
    required List<Place> places,
    required int searchRadius,
    required MeetingFormat meetingFormat,
  }) {
    return _repo.saveMeetingSnapshot(
      roomId: roomId,
      centerPoint: centerPoint,
      routePoints: routePoints,
      places: places,
      searchRadius: searchRadius,
      meetingFormat: meetingFormat,
    );
  }
}
