import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/repositories/meeting_snapshot_repository.dart';
import '../datasources/remote/room_remote_data_source.dart';

class MeetingSnapshotRepositoryImpl implements MeetingSnapshotRepository {
  final RoomRemoteDataSource _remote;
  MeetingSnapshotRepositoryImpl(this._remote);

  @override
  Future<Result<void>> saveMeetingSnapshot({
    required String roomId,
    required latlong.LatLng centerPoint,
    required List<latlong.LatLng> routePoints,
    required List<Map<String, dynamic>> places,
    required int searchRadius,
    required MeetingFormat meetingFormat,
  }) {
    return _remote.saveMeetingSnapshot(
      roomId: roomId,
      centerPoint: centerPoint,
      routePoints: routePoints,
      places: places,
      searchRadius: searchRadius,
      meetingFormat: meetingFormat.wireValue,
    );
  }
}
