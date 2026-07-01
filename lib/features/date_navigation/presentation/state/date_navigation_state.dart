import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/failure.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/room_status.dart';

part 'date_navigation_state.freezed.dart';

@freezed
abstract class RoomSessionState with _$RoomSessionState {
  const RoomSessionState._();

  const factory RoomSessionState({
    String? roomId,
    String? inviteCode,
    @Default(false) bool isCreator,
    latlong.LatLng? point1,
    latlong.LatLng? point2,
    @Default(SessionStatus.active) SessionStatus sessionStatus,
  }) = _RoomSessionState;

  bool get isCompleted => sessionStatus.isCompleted;
  bool get isExpired => sessionStatus.isExpired;
  bool get isClosed => sessionStatus.isClosed;

  latlong.LatLng? myPoint() => isCreator ? point1 : point2;
  latlong.LatLng? partnerPoint() => isCreator ? point2 : point1;
}

@freezed
abstract class MeetingPlanningState with _$MeetingPlanningState {
  const MeetingPlanningState._();

  const factory MeetingPlanningState({
    String? finalChoiceName,
    Place? finalChoicePlace,
    @Default([]) List<Place> foundPlaces,
    @Default([]) List<Place> filteredPlaces,
    latlong.LatLng? centerPoint,
    @Default([]) List<latlong.LatLng> routePoints,
    String? selectedType,
    @Default(500.0) double searchRadius,
    int? creatorChangedRadiusTo,
    int? peerSuggestedRadius,
    MeetingFormat? peerSuggestedMeetingFormat,
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
  }) = _MeetingPlanningState;

  MeetingFormat? get creatorMeetingFormat => creatorMeetingFormats.firstOrNull;
  MeetingFormat? get partnerMeetingFormat => partnerMeetingFormats.firstOrNull;

  List<MeetingFormat> get commonMeetingFormats {
    if (creatorMeetingFormats.isEmpty || partnerMeetingFormats.isEmpty) {
      return const [];
    }
    final partnerSet = partnerMeetingFormats.toSet();
    return creatorMeetingFormats
        .where(partnerSet.contains)
        .toList(growable: false);
  }

  MeetingFormat? mySelectedMeetingFormat(bool isCreatorRole) => isCreatorRole
      ? creatorSelectedMeetingFormat
      : partnerSelectedMeetingFormat;
}

@freezed
abstract class VotingState with _$VotingState {
  const factory VotingState({
    @Default({}) Map<String, String> votesByUser,
    @Default({}) Map<String, int> voteCounts,
    String? proposalPlaceName,
    String? proposalPlaceAddress,
    String? proposalPlaceType,
    String? proposalByRole,
    ProposalStatus? proposalStatus,
  }) = _VotingState;
}

@freezed
abstract class AddressMemoryState with _$AddressMemoryState {
  const factory AddressMemoryState({
    @Default([]) List<String> recentAddresses,
  }) = _AddressMemoryState;
}

@freezed
abstract class DateNavigationUiState with _$DateNavigationUiState {
  const DateNavigationUiState._();

  const factory DateNavigationUiState({
    @Default(false) bool isLoadingRoomAction,
    @Default(false) bool isGeocoding,
    @Default(false) bool isCalculatingMeeting,
    Failure? lastFailure,
    String? failureOperation,
  }) = _DateNavigationUiState;

  bool get isLoading =>
      isLoadingRoomAction || isGeocoding || isCalculatingMeeting;
  String? get errorMessage => lastFailure?.message;
}

@freezed
abstract class DateNavigationState with _$DateNavigationState {
  const DateNavigationState._();

  const factory DateNavigationState({
    @Default(RoomSessionState()) RoomSessionState room,
    @Default(MeetingPlanningState()) MeetingPlanningState meeting,
    @Default(VotingState()) VotingState voting,
    @Default(AddressMemoryState()) AddressMemoryState addressMemory,
    @Default(DateNavigationUiState()) DateNavigationUiState ui,
  }) = _DateNavigationState;

  latlong.LatLng? myPoint(bool isCreatorRole) =>
      isCreatorRole ? room.point1 : room.point2;
  latlong.LatLng? partnerPoint(bool isCreatorRole) =>
      isCreatorRole ? room.point2 : room.point1;
}
