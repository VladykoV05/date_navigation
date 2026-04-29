import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/failure.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';

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
  final String sessionStatus;

  bool get isCompleted => sessionStatus == 'completed';
  bool get isExpired => sessionStatus == 'expired';
  bool get isClosed => isCompleted || isExpired;
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
  final String? meetingRevoteRequestStatus;

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
  final String? proposalStatus;
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

class DateNavigationState {
  final String? roomId;
  final String? inviteCode;
  final bool isCreator;
  final bool isLoadingRoomAction;
  final bool isGeocoding;
  final bool isCalculatingMeeting;
  final String? finalChoiceName;
  final Place? finalChoicePlace;
  final List<Place> foundPlaces;
  final List<Place> filteredPlaces;
  final latlong.LatLng? centerPoint;
  final latlong.LatLng? point1;
  final latlong.LatLng? point2;
  final List<latlong.LatLng> routePoints;
  final String? selectedType;
  final double searchRadius;
  final Map<String, String> votesByUser;
  final Map<String, int> voteCounts;
  final String? proposalPlaceName;
  final String? proposalPlaceAddress;
  final String? proposalPlaceType;
  final String? proposalByRole;
  final String? proposalStatus;
  final int? creatorChangedRadiusTo;
  final int? peerSuggestedRadius;
  final MeetingFormat? peerSuggestedMeetingFormat;
  final List<String> recentAddresses;
  final Failure? lastFailure;
  final String? failureOperation;
  final String sessionStatus;
  final DateScenario? selectedScenario;
  final List<MeetingFormat> creatorMeetingFormats;
  final List<MeetingFormat> partnerMeetingFormats;
  final MeetingFormat? creatorSelectedMeetingFormat;
  final MeetingFormat? partnerSelectedMeetingFormat;
  final MeetingFormat? selectedMeetingFormat;
  final MeetingFormat? lastAgreedMeetingFormat;
  final List<DateScenario> dateScenarios;
  final String? meetingRevoteRequestByRole;
  final String? meetingRevoteRequestStatus;

  const DateNavigationState({
    this.roomId,
    this.inviteCode,
    this.isCreator = false,
    this.isLoadingRoomAction = false,
    this.isGeocoding = false,
    this.isCalculatingMeeting = false,
    this.finalChoiceName,
    this.finalChoicePlace,
    this.foundPlaces = const [],
    this.filteredPlaces = const [],
    this.centerPoint,
    this.point1,
    this.point2,
    this.routePoints = const [],
    this.selectedType,
    this.searchRadius = 500.0,
    this.votesByUser = const {},
    this.voteCounts = const {},
    this.proposalPlaceName,
    this.proposalPlaceAddress,
    this.proposalPlaceType,
    this.proposalByRole,
    this.proposalStatus,
    this.creatorChangedRadiusTo,
    this.peerSuggestedRadius,
    this.peerSuggestedMeetingFormat,
    this.recentAddresses = const [],
    this.lastFailure,
    this.failureOperation,
    this.sessionStatus = 'active',
    this.selectedScenario,
    this.creatorMeetingFormats = const [],
    this.partnerMeetingFormats = const [],
    this.creatorSelectedMeetingFormat,
    this.partnerSelectedMeetingFormat,
    this.selectedMeetingFormat,
    this.lastAgreedMeetingFormat,
    this.dateScenarios = const [],
    this.meetingRevoteRequestByRole,
    this.meetingRevoteRequestStatus,
  });

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
  MeetingFormat? mySelectedMeetingFormat(bool isCreatorRole) =>
      isCreatorRole ? creatorSelectedMeetingFormat : partnerSelectedMeetingFormat;

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

  DateNavigationState copyWith({
    String? roomId,
    Object? inviteCode = _unset,
    bool? isCreator,
    bool? isLoadingRoomAction,
    bool? isGeocoding,
    bool? isCalculatingMeeting,
    Object? finalChoiceName = _unset,
    Object? finalChoicePlace = _unset,
    List<Place>? foundPlaces,
    List<Place>? filteredPlaces,
    Object? centerPoint = _unset,
    Object? point1 = _unset,
    Object? point2 = _unset,
    List<latlong.LatLng>? routePoints,
    Object? selectedType = _unset,
    double? searchRadius,
    Map<String, String>? votesByUser,
    Map<String, int>? voteCounts,
    Object? proposalPlaceName = _unset,
    Object? proposalPlaceAddress = _unset,
    Object? proposalPlaceType = _unset,
    Object? proposalByRole = _unset,
    Object? proposalStatus = _unset,
    Object? creatorChangedRadiusTo = _unset,
    Object? peerSuggestedRadius = _unset,
    Object? peerSuggestedMeetingFormat = _unset,
    List<String>? recentAddresses,
    Object? errorMessage = _unset,
    Object? failureOperation = _unset,
    String? sessionStatus,
    Object? selectedScenario = _unset,
    List<MeetingFormat>? creatorMeetingFormats,
    List<MeetingFormat>? partnerMeetingFormats,
    Object? creatorSelectedMeetingFormat = _unset,
    Object? partnerSelectedMeetingFormat = _unset,
    Object? selectedMeetingFormat = _unset,
    Object? lastAgreedMeetingFormat = _unset,
    List<DateScenario>? dateScenarios,
    Object? meetingRevoteRequestByRole = _unset,
    Object? meetingRevoteRequestStatus = _unset,
  }) {
    return DateNavigationState(
      roomId: roomId ?? this.roomId,
      inviteCode: identical(inviteCode, _unset)
          ? this.inviteCode
          : inviteCode as String?,
      isCreator: isCreator ?? this.isCreator,
      isLoadingRoomAction: isLoadingRoomAction ?? this.isLoadingRoomAction,
      isGeocoding: isGeocoding ?? this.isGeocoding,
      isCalculatingMeeting: isCalculatingMeeting ?? this.isCalculatingMeeting,
      finalChoiceName: identical(finalChoiceName, _unset)
          ? this.finalChoiceName
          : finalChoiceName as String?,
      finalChoicePlace: identical(finalChoicePlace, _unset)
          ? this.finalChoicePlace
          : finalChoicePlace as Place?,
      foundPlaces: foundPlaces ?? this.foundPlaces,
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      centerPoint: identical(centerPoint, _unset)
          ? this.centerPoint
          : centerPoint as latlong.LatLng?,
      point1: identical(point1, _unset)
          ? this.point1
          : point1 as latlong.LatLng?,
      point2: identical(point2, _unset)
          ? this.point2
          : point2 as latlong.LatLng?,
      routePoints: routePoints ?? this.routePoints,
      selectedType: identical(selectedType, _unset)
          ? this.selectedType
          : selectedType as String?,
      searchRadius: searchRadius ?? this.searchRadius,
      votesByUser: votesByUser ?? this.votesByUser,
      voteCounts: voteCounts ?? this.voteCounts,
      proposalPlaceName: identical(proposalPlaceName, _unset)
          ? this.proposalPlaceName
          : proposalPlaceName as String?,
      proposalPlaceAddress: identical(proposalPlaceAddress, _unset)
          ? this.proposalPlaceAddress
          : proposalPlaceAddress as String?,
      proposalPlaceType: identical(proposalPlaceType, _unset)
          ? this.proposalPlaceType
          : proposalPlaceType as String?,
      proposalByRole: identical(proposalByRole, _unset)
          ? this.proposalByRole
          : proposalByRole as String?,
      proposalStatus: identical(proposalStatus, _unset)
          ? this.proposalStatus
          : proposalStatus as String?,
      creatorChangedRadiusTo: identical(creatorChangedRadiusTo, _unset)
          ? this.creatorChangedRadiusTo
          : creatorChangedRadiusTo as int?,
      peerSuggestedRadius: identical(peerSuggestedRadius, _unset)
          ? this.peerSuggestedRadius
          : peerSuggestedRadius as int?,
      peerSuggestedMeetingFormat: identical(peerSuggestedMeetingFormat, _unset)
          ? this.peerSuggestedMeetingFormat
          : peerSuggestedMeetingFormat as MeetingFormat?,
      recentAddresses: recentAddresses ?? this.recentAddresses,
      lastFailure: identical(errorMessage, _unset)
          ? lastFailure
          : errorMessage as Failure?,
      failureOperation: identical(failureOperation, _unset)
          ? this.failureOperation
          : failureOperation as String?,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      selectedScenario: identical(selectedScenario, _unset)
          ? this.selectedScenario
          : selectedScenario as DateScenario?,
      creatorMeetingFormats:
          creatorMeetingFormats ?? this.creatorMeetingFormats,
      partnerMeetingFormats:
          partnerMeetingFormats ?? this.partnerMeetingFormats,
      creatorSelectedMeetingFormat:
          identical(creatorSelectedMeetingFormat, _unset)
          ? this.creatorSelectedMeetingFormat
          : creatorSelectedMeetingFormat as MeetingFormat?,
      partnerSelectedMeetingFormat:
          identical(partnerSelectedMeetingFormat, _unset)
          ? this.partnerSelectedMeetingFormat
          : partnerSelectedMeetingFormat as MeetingFormat?,
      selectedMeetingFormat: identical(selectedMeetingFormat, _unset)
          ? this.selectedMeetingFormat
          : selectedMeetingFormat as MeetingFormat?,
      lastAgreedMeetingFormat: identical(lastAgreedMeetingFormat, _unset)
          ? this.lastAgreedMeetingFormat
          : lastAgreedMeetingFormat as MeetingFormat?,
      dateScenarios: dateScenarios ?? this.dateScenarios,
      meetingRevoteRequestByRole:
          identical(meetingRevoteRequestByRole, _unset)
          ? this.meetingRevoteRequestByRole
          : meetingRevoteRequestByRole as String?,
      meetingRevoteRequestStatus:
          identical(meetingRevoteRequestStatus, _unset)
          ? this.meetingRevoteRequestStatus
          : meetingRevoteRequestStatus as String?,
    );
  }
}

const _unset = Object();
