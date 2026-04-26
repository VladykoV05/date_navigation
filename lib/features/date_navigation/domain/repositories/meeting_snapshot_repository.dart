import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';

abstract interface class MeetingSnapshotRepository {
  Future<Result<void>> saveMeetingSnapshot({
    required String roomId,
    required latlong.LatLng centerPoint,
    required List<latlong.LatLng> routePoints,
    required List<Map<String, dynamic>> places,
    required int searchRadius,
    required MeetingFormat meetingFormat,
  });
}
