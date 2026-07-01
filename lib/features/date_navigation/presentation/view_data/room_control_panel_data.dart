import '../../domain/value_objects/geo_coordinate.dart';
import 'place_view_data.dart';

class RoomControlPanelData {
  const RoomControlPanelData({
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
  final List<PlaceViewData> places;
  final String? selectedType;
  final GeoCoordinate? myLocation;
  final bool hasPartner;
  final double searchRadius;
  final List<String> recentAddresses;
  final bool isCreator;
  final List<MeetingFormatView> creatorMeetingFormats;
  final List<MeetingFormatView> partnerMeetingFormats;
  final List<MeetingFormatView> commonMeetingFormats;
  final MeetingFormatView? mySelectedMeetingFormat;
  final MeetingFormatView? partnerSelectedMeetingFormat;
  final MeetingFormatView? selectedMeetingFormat;
  final MeetingFormatView? lastAgreedMeetingFormat;
  final String? meetingRevoteRequestByRole;
  final RevoteRequestStatusView? meetingRevoteRequestStatus;
  final Map<String, int> voteCounts;
  final String? myVotePlaceName;
  final bool isSessionClosed;
  final SessionStatusView sessionStatus;
}
