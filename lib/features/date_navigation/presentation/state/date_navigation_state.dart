import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/failure.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/room_status.dart';

part 'date_navigation_state.freezed.dart';

class RoomSessionSection {
  const RoomSessionSection({
    required this.roomId,
    required this.inviteCode,
    required this.isCreator,
    required this.point1,
    required this.point2,
    required this.sessionStatus,
  });

  final String? roomId;
  final String? inviteCode;
  final bool isCreator;
  final latlong.LatLng? point1;
  final latlong.LatLng? point2;
  final SessionStatus sessionStatus;

  bool get isCompleted => sessionStatus.isCompleted;
  bool get isExpired => sessionStatus.isExpired;
  bool get isClosed => sessionStatus.isClosed;
}

class MeetingSection {
  const MeetingSection({
    required this.finalChoiceName,
    required this.finalChoicePlace,
    required this.foundPlaces,
    required this.filteredPlaces,
    required this.centerPoint,
    required this.routePoints,
    required this.selectedType,
    required this.searchRadius,
    required this.creatorChangedRadiusTo,
    required this.peerSuggestedRadius,
    required this.peerSuggestedMeetingFormat,
    required this.selectedScenario,
    required this.creatorMeetingFormats,
    required this.partnerMeetingFormats,
    required this.commonMeetingFormats,
    required this.creatorSelectedMeetingFormat,
    required this.partnerSelectedMeetingFormat,
    required this.selectedMeetingFormat,
    required this.lastAgreedMeetingFormat,
    required this.dateScenarios,
    required this.meetingRevoteRequestByRole,
    required this.meetingRevoteRequestStatus,
  });

  final String? finalChoiceName;
  final Place? finalChoicePlace;
  final List<Place> foundPlaces;
  final List<Place> filteredPlaces;
  final latlong.LatLng? centerPoint;
  final List<latlong.LatLng> routePoints;
  final String? selectedType;
  final double searchRadius;
  final int? creatorChangedRadiusTo;
  final int? peerSuggestedRadius;
  final MeetingFormat? peerSuggestedMeetingFormat;
  final DateScenario? selectedScenario;
  final List<MeetingFormat> creatorMeetingFormats;
  final List<MeetingFormat> partnerMeetingFormats;
  final List<MeetingFormat> commonMeetingFormats;
  final MeetingFormat? creatorSelectedMeetingFormat;
  final MeetingFormat? partnerSelectedMeetingFormat;
  final MeetingFormat? selectedMeetingFormat;
  final MeetingFormat? lastAgreedMeetingFormat;
  final List<DateScenario> dateScenarios;
  final String? meetingRevoteRequestByRole;
  final RevoteRequestStatus? meetingRevoteRequestStatus;

  MeetingFormat? get creatorMeetingFormat => creatorMeetingFormats.firstOrNull;
  MeetingFormat? get partnerMeetingFormat => partnerMeetingFormats.firstOrNull;
}

class VotingSection {
  const VotingSection({
    required this.votesByUser,
    required this.voteCounts,
    required this.proposalPlaceName,
    required this.proposalPlaceAddress,
    required this.proposalPlaceType,
    required this.proposalByRole,
    required this.proposalStatus,
  });

  final Map<String, String> votesByUser;
  final Map<String, int> voteCounts;
  final String? proposalPlaceName;
  final String? proposalPlaceAddress;
  final String? proposalPlaceType;
  final String? proposalByRole;
  final ProposalStatus? proposalStatus;
}

class LoadingSection {
  const LoadingSection({
    required this.isLoadingRoomAction,
    required this.isGeocoding,
    required this.isCalculatingMeeting,
  });

  final bool isLoadingRoomAction;
  final bool isGeocoding;
  final bool isCalculatingMeeting;

  bool get isLoading =>
      isLoadingRoomAction || isGeocoding || isCalculatingMeeting;
}

class FailureSection {
  const FailureSection({
    required this.lastFailure,
    required this.failureOperation,
  });

  final Failure? lastFailure;
  final String? failureOperation;
}

@freezed
abstract class DateNavigationState with _$DateNavigationState {
  const DateNavigationState._();

  const factory DateNavigationState({
    String? roomId,
    String? inviteCode,
    @Default(false) bool isCreator,
    @Default(false) bool isLoadingRoomAction,
    @Default(false) bool isGeocoding,
    @Default(false) bool isCalculatingMeeting,
    String? finalChoiceName,
    Place? finalChoicePlace,
    @Default([]) List<Place> foundPlaces,
    @Default([]) List<Place> filteredPlaces,
    latlong.LatLng? centerPoint,
    latlong.LatLng? point1,
    latlong.LatLng? point2,
    @Default([]) List<latlong.LatLng> routePoints,
    String? selectedType,
    @Default(500.0) double searchRadius,
    @Default({}) Map<String, String> votesByUser,
    @Default({}) Map<String, int> voteCounts,
    String? proposalPlaceName,
    String? proposalPlaceAddress,
    String? proposalPlaceType,
    String? proposalByRole,
    ProposalStatus? proposalStatus,
    int? creatorChangedRadiusTo,
    int? peerSuggestedRadius,
    MeetingFormat? peerSuggestedMeetingFormat,
    @Default([]) List<String> recentAddresses,
    Failure? lastFailure,
    String? failureOperation,
    @Default(SessionStatus.active) SessionStatus sessionStatus,
    DateScenario? selectedScenario,
    @Default([]) List<MeetingFormat> creatorMeetingFormats,
    @Default([]) List<MeetingFormat> partnerMeetingFormats,
    MeetingFormat? creatorSelectedMeetingFormat,
    MeetingFormat? partnerSelectedMeetingFormat,
    MeetingFormat? selectedMeetingFormat,
    MeetingFormat? lastAgreedMeetingFormat,
    @Default([]) List<DateScenario> dateScenarios,
    String? meetingRevoteRequestByRole,
    RevoteRequestStatus? meetingRevoteRequestStatus,
  }) = _DateNavigationState;

  bool get isLoading =>
      isLoadingRoomAction || isGeocoding || isCalculatingMeeting;
  String? get errorMessage => lastFailure?.message;
  List<MeetingFormat> get commonMeetingFormats {
    if (creatorMeetingFormats.isEmpty || partnerMeetingFormats.isEmpty) {
      return const [];
    }
    final partnerSet = partnerMeetingFormats.toSet();
    return creatorMeetingFormats
        .where(partnerSet.contains)
        .toList(growable: false);
  }

  MeetingFormat? get creatorMeetingFormat => creatorMeetingFormats.firstOrNull;
  MeetingFormat? get partnerMeetingFormat => partnerMeetingFormats.firstOrNull;
  MeetingFormat? mySelectedMeetingFormat(bool isCreatorRole) => isCreatorRole
      ? creatorSelectedMeetingFormat
      : partnerSelectedMeetingFormat;

  RoomSessionSection get roomSession => RoomSessionSection(
    roomId: roomId,
    inviteCode: inviteCode,
    isCreator: isCreator,
    point1: point1,
    point2: point2,
    sessionStatus: sessionStatus,
  );
  MeetingSection get meeting => MeetingSection(
    finalChoiceName: finalChoiceName,
    finalChoicePlace: finalChoicePlace,
    foundPlaces: foundPlaces,
    filteredPlaces: filteredPlaces,
    centerPoint: centerPoint,
    routePoints: routePoints,
    selectedType: selectedType,
    searchRadius: searchRadius,
    creatorChangedRadiusTo: creatorChangedRadiusTo,
    peerSuggestedRadius: peerSuggestedRadius,
    peerSuggestedMeetingFormat: peerSuggestedMeetingFormat,
    selectedScenario: selectedScenario,
    creatorMeetingFormats: creatorMeetingFormats,
    partnerMeetingFormats: partnerMeetingFormats,
    commonMeetingFormats: commonMeetingFormats,
    creatorSelectedMeetingFormat: creatorSelectedMeetingFormat,
    partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
    selectedMeetingFormat: selectedMeetingFormat,
    lastAgreedMeetingFormat: lastAgreedMeetingFormat,
    dateScenarios: dateScenarios,
    meetingRevoteRequestByRole: meetingRevoteRequestByRole,
    meetingRevoteRequestStatus: meetingRevoteRequestStatus,
  );
  VotingSection get voting => VotingSection(
    votesByUser: votesByUser,
    voteCounts: voteCounts,
    proposalPlaceName: proposalPlaceName,
    proposalPlaceAddress: proposalPlaceAddress,
    proposalPlaceType: proposalPlaceType,
    proposalByRole: proposalByRole,
    proposalStatus: proposalStatus,
  );
  LoadingSection get loading => LoadingSection(
    isLoadingRoomAction: isLoadingRoomAction,
    isGeocoding: isGeocoding,
    isCalculatingMeeting: isCalculatingMeeting,
  );
  FailureSection get failure => FailureSection(
    lastFailure: lastFailure,
    failureOperation: failureOperation,
  );

  latlong.LatLng? myPoint(bool isCreatorRole) =>
      isCreatorRole ? point1 : point2;
  latlong.LatLng? partnerPoint(bool isCreatorRole) =>
      isCreatorRole ? point2 : point1;
}
