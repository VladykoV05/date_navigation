import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../entities/meeting_point.dart';

abstract interface class MeetingRepository {
  Future<Result<MeetingPoint>> findMeetingPoint({
    required latlong.LatLng userLocation,
    required latlong.LatLng partnerLocation,
    required int searchRadius,
    required MeetingFormat format,
  });
}
