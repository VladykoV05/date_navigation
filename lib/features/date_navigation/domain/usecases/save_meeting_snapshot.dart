import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../repositories/meeting_snapshot_repository.dart';

class SaveMeetingSnapshot {
  final MeetingSnapshotRepository _repo;
  const SaveMeetingSnapshot(this._repo);

  Future<Result<void>> call({
    required String roomId,
    required latlong.LatLng centerPoint,
    required List<latlong.LatLng> routePoints,
    required List<Map<String, dynamic>> places,
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
