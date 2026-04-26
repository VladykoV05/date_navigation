import 'package:latlong2/latlong.dart' as latlong;

import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';

class RoomControlPanelViewData {
  const RoomControlPanelViewData({
    required this.roomId,
    required this.isLoading,
    required this.isGeocoding,
    required this.isCalculatingMeeting,
    required this.isLoadingRoomAction,
    required this.places,
    required this.selectedType,
    required this.myLocation,
    required this.hasPartner,
    required this.searchRadius,
    required this.recentAddresses,
    required this.isCreator,
    required this.creatorMeetingFormats,
    required this.partnerMeetingFormats,
    required this.commonMeetingFormats,
    required this.mySelectedMeetingFormat,
    required this.partnerSelectedMeetingFormat,
    required this.selectedMeetingFormat,
    required this.lastAgreedMeetingFormat,
    required this.meetingRevoteRequestByRole,
    required this.meetingRevoteRequestStatus,
    required this.voteCounts,
    required this.myVotePlaceName,
    required this.isSessionClosed,
    required this.sessionStatus,
  });

  final String roomId;
  final bool isLoading;
  final bool isGeocoding;
  final bool isCalculatingMeeting;
  final bool isLoadingRoomAction;
  final List<Place> places;
  final String? selectedType;
  final latlong.LatLng? myLocation;
  final bool hasPartner;
  final double searchRadius;
  final List<String> recentAddresses;
  final bool isCreator;
  final List<MeetingFormat> creatorMeetingFormats;
  final List<MeetingFormat> partnerMeetingFormats;
  final List<MeetingFormat> commonMeetingFormats;
  final MeetingFormat? mySelectedMeetingFormat;
  final MeetingFormat? partnerSelectedMeetingFormat;
  final MeetingFormat? selectedMeetingFormat;
  final MeetingFormat? lastAgreedMeetingFormat;
  final String? meetingRevoteRequestByRole;
  final String? meetingRevoteRequestStatus;
  final Map<String, int> voteCounts;
  final String? myVotePlaceName;
  final bool isSessionClosed;
  final String sessionStatus;
}
