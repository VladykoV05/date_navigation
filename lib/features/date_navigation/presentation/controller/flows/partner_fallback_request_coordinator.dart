import 'package:latlong2/latlong.dart' as latlong;

import '../../../domain/entities/date_vibe.dart';
import '../../state/date_navigation_state.dart';

class PartnerFallbackRequest {
  const PartnerFallbackRequest({
    required this.searchRadius,
    required this.point1,
    required this.point2,
    required this.format,
  });

  final int searchRadius;
  final latlong.LatLng point1;
  final latlong.LatLng point2;
  final MeetingFormat format;
}

class PartnerFallbackRequestCoordinator {
  const PartnerFallbackRequestCoordinator();

  PartnerFallbackRequest? build({
    required DateNavigationState state,
    required latlong.LatLng point1,
    required latlong.LatLng point2,
  }) {
    final format = state.selectedMeetingFormat;
    if (format == null) return null;
    return PartnerFallbackRequest(
      searchRadius: state.meeting.searchRadius.round(),
      point1: point1,
      point2: point2,
      format: format,
    );
  }
}
