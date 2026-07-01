import '../../domain/entities/date_vibe.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../state/date_navigation_state.dart';

class PartnerFallbackRequest {
  const PartnerFallbackRequest({
    required this.searchRadius,
    required this.point1,
    required this.point2,
    required this.format,
  });

  final int searchRadius;
  final GeoCoordinate point1;
  final GeoCoordinate point2;
  final MeetingFormat format;
}

class PartnerFallbackRequestBuilder {
  const PartnerFallbackRequestBuilder();

  PartnerFallbackRequest? build({
    required DateNavigationState state,
    required GeoCoordinate point1,
    required GeoCoordinate point2,
  }) {
    final format = state.meeting.selectedMeetingFormat;
    if (format == null) return null;
    return PartnerFallbackRequest(
      searchRadius: state.meeting.searchRadius.round(),
      point1: point1,
      point2: point2,
      format: format,
    );
  }
}
