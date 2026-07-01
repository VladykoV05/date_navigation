import '../../../../core/error/result.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/repositories/meeting_snapshot_repository.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../datasources/remote/room_remote_data_source.dart';
import '../mappers/geo_coordinate_mapper.dart';

class MeetingSnapshotRepositoryImpl implements MeetingSnapshotRepository {
  final RoomRemoteDataSource _remote;
  MeetingSnapshotRepositoryImpl(this._remote);

  @override
  Future<Result<void>> saveMeetingSnapshot({
    required String roomId,
    required GeoCoordinate centerPoint,
    required List<GeoCoordinate> routePoints,
    required List<Map<String, dynamic>> places,
    required int searchRadius,
    required MeetingFormat meetingFormat,
  }) {
    return _remote.saveMeetingSnapshot(
      roomId: roomId,
      centerPoint: GeoCoordinateMapper.toLatLng(centerPoint),
      routePoints: GeoCoordinateMapper.toLatLngList(routePoints),
      places: places,
      searchRadius: searchRadius,
      meetingFormat: meetingFormat.wireValue,
    );
  }
}
