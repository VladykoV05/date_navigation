import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../entities/meeting_point.dart';
import '../repositories/meeting_repository.dart';

class FindMeetingPoint {
  final MeetingRepository _repo;
  const FindMeetingPoint(this._repo);

  Future<Result<MeetingPoint>> call({
    required latlong.LatLng userLocation,
    required latlong.LatLng partnerLocation,
    required int searchRadius,
    required MeetingFormat format,
  }) {
    return _repo.findMeetingPoint(
      userLocation: userLocation,
      partnerLocation: partnerLocation,
      searchRadius: searchRadius,
      format: format,
    );
  }
}
