import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../application/state/date_navigation_state.dart';
import '../mappers/place_view_mapper.dart';
import '../view_data/open_participant_view_data.dart';
import '../view_data/open_plan_view_data.dart';
import '../view_data/room_control_panel_data.dart';
import '../view_data/room_event_view_data.dart';
import '../controllers/date_navigation_controller.dart';

export 'date_navigation_service_providers.dart';

/// Keeps room session alive across Account navigation and MaterialApp locale rebuilds.
final dateNavigationControllerProvider =
    NotifierProvider<DateNavigationController, DateNavigationState>(
      DateNavigationController.new,
    );

final dateNavigationMapViewProvider = Provider.autoDispose(
  (ref) => ref.watch(
    dateNavigationControllerProvider.select(
      (s) => (
        isCreator: s.room.isCreator,
        venueLocked: (s.meeting.finalChoiceName?.isNotEmpty ?? false),
        finalChoicePlace: s.meeting.finalChoicePlace,
        centerPoint: s.meeting.centerPoint,
        point1: s.room.point1,
        point2: s.room.point2,
        isOpen: s.room.isOpen,
        openOwnPoint: s.room.openOwnPoint,
        openSelfUid: s.room.selfUid,
        openParticipantPoints: s.room.openParticipantPoints,
        filteredPlaces: s.meeting.filteredPlaces,
        isLoading: s.ui.isLoading,
        isGeocoding: s.ui.isGeocoding,
        isCalculatingMeeting: s.ui.isCalculatingMeeting,
        isLoadingRoomAction: s.ui.isLoadingRoomAction,
        searchRadius: s.meeting.searchRadius,
        routePoints: s.meeting.routePoints,
        sessionStatus: s.room.sessionStatus,
        event: s.room.event == null
            ? null
            : RoomEventViewData.fromSnapshot(s.room.event!),
      ),
    ),
  ),
);

final dateNavigationRoomBodyViewProvider = Provider.autoDispose(
  (ref) => ref.watch(
    dateNavigationControllerProvider.select(
      (s) => (
        roomId: s.room.roomId,
        inviteCode: s.room.inviteCode,
        venueLocked: (s.meeting.finalChoiceName?.isNotEmpty ?? false),
        finalChoiceName: s.meeting.finalChoiceName,
        finalChoicePlace: s.meeting.finalChoicePlace,
        isCreator: s.room.isCreator,
        isSessionClosed: s.room.isClosed,
        sessionStatus: s.room.sessionStatus,
        point1: s.room.point1,
        point2: s.room.point2,
        isLoading: s.ui.isLoading,
        isGeocoding: s.ui.isGeocoding,
        isCalculatingMeeting: s.ui.isCalculatingMeeting,
        isLoadingRoomAction: s.ui.isLoadingRoomAction,
        filteredPlaces: s.meeting.filteredPlaces,
        recentAddresses: s.addressMemory.recentAddresses,
        selectedType: s.meeting.selectedType,
        creatorMeetingFormats: s.meeting.creatorMeetingFormats,
        partnerMeetingFormats: s.meeting.partnerMeetingFormats,
        commonMeetingFormats: s.meeting.commonMeetingFormats,
        creatorSelectedMeetingFormat: s.meeting.creatorSelectedMeetingFormat,
        partnerSelectedMeetingFormat: s.meeting.partnerSelectedMeetingFormat,
        selectedMeetingFormat: s.meeting.selectedMeetingFormat,
        lastAgreedMeetingFormat: s.meeting.lastAgreedMeetingFormat,
        meetingRevoteRequestByRole: s.meeting.meetingRevoteRequestByRole,
        meetingRevoteRequestStatus: s.meeting.meetingRevoteRequestStatus,
        dateScenarios: s.meeting.dateScenarios,
        selectedScenario: s.meeting.selectedScenario,
        searchRadius: s.meeting.searchRadius,
        voteCounts: s.voting.voteCounts,
        votesByUser: s.voting.votesByUser,
        isOpen: s.room.isOpen,
        selfUid: s.room.selfUid,
        nextStep: s.room.nextStep == null
            ? null
            : NextStepViewData(
                name: s.room.nextStep!.name,
                address: s.room.nextStep!.address,
              ),
        planRadiusMeters: s.room.planRadiusMeters,
        openParticipants: s.room.openParticipants
            .map(OpenParticipantViewData.fromParticipant)
            .toList(growable: false),
        openOwnPoint: s.room.openOwnPoint,
        event: s.room.event == null
            ? null
            : RoomEventViewData.fromSnapshot(s.room.event!),
      ),
    ),
  ),
);

final dateNavigationMapOverlayViewProvider = Provider.autoDispose(
  (ref) => ref.watch(
    dateNavigationControllerProvider.select(
      (s) => (
        isCreator: s.room.isCreator,
        point1: s.room.point1,
        point2: s.room.point2,
        centerPoint: s.meeting.centerPoint,
        routePoints: s.meeting.routePoints,
        filteredPlaces: s.meeting.filteredPlaces,
        finalChoicePlace: s.meeting.finalChoicePlace,
        venueLocked: (s.meeting.finalChoiceName?.isNotEmpty ?? false),
      ),
    ),
  ),
);

final roomControlPanelViewProvider = Provider.autoDispose((ref) {
  final stateSlice = ref.watch(
    dateNavigationControllerProvider.select(
      (s) => (
        roomId: s.room.roomId,
        inviteCode: s.room.inviteCode,
        isCreator: s.room.isCreator,
        isSessionClosed: s.room.isClosed,
        sessionStatus: s.room.sessionStatus,
        point1: s.room.point1,
        point2: s.room.point2,
        isLoading: s.ui.isLoading,
        isGeocoding: s.ui.isGeocoding,
        isCalculatingMeeting: s.ui.isCalculatingMeeting,
        isLoadingRoomAction: s.ui.isLoadingRoomAction,
        filteredPlaces: s.meeting.filteredPlaces,
        recentAddresses: s.addressMemory.recentAddresses,
        selectedType: s.meeting.selectedType,
        creatorMeetingFormats: s.meeting.creatorMeetingFormats,
        partnerMeetingFormats: s.meeting.partnerMeetingFormats,
        commonMeetingFormats: s.meeting.commonMeetingFormats,
        creatorSelectedMeetingFormat: s.meeting.creatorSelectedMeetingFormat,
        partnerSelectedMeetingFormat: s.meeting.partnerSelectedMeetingFormat,
        selectedMeetingFormat: s.meeting.selectedMeetingFormat,
        lastAgreedMeetingFormat: s.meeting.lastAgreedMeetingFormat,
        meetingRevoteRequestByRole: s.meeting.meetingRevoteRequestByRole,
        meetingRevoteRequestStatus: s.meeting.meetingRevoteRequestStatus,
        searchRadius: s.meeting.searchRadius,
        voteCounts: s.voting.voteCounts,
        votesByUser: s.voting.votesByUser,
        event: s.room.event,
      ),
    ),
  );
  final currentUserId = ref.watch(
    authSessionProvider.select((auth) => auth.currentUserId ?? ''),
  );
  final roomId = stateSlice.inviteCode ?? stateSlice.roomId ?? '';
  final myLocation = stateSlice.isCreator
      ? stateSlice.point1
      : stateSlice.point2;
  final partnerPoint = stateSlice.isCreator
      ? stateSlice.point2
      : stateSlice.point1;
  final mySelectedMeetingFormat = stateSlice.isCreator
      ? stateSlice.creatorSelectedMeetingFormat
      : stateSlice.partnerSelectedMeetingFormat;
  final partnerSelectedMeetingFormat = stateSlice.isCreator
      ? stateSlice.partnerSelectedMeetingFormat
      : stateSlice.creatorSelectedMeetingFormat;
  return RoomControlPanelData(
    roomId: roomId,
    isLoading: stateSlice.isLoading,
    isGeocoding: stateSlice.isGeocoding,
    isCalculatingMeeting: stateSlice.isCalculatingMeeting,
    isLoadingRoomAction: stateSlice.isLoadingRoomAction,
    places: PlaceViewMapper.fromPlaces(stateSlice.filteredPlaces),
    selectedType: stateSlice.selectedType,
    myLocation: myLocation,
    hasPartner: partnerPoint != null,
    searchRadius: stateSlice.searchRadius,
    recentAddresses: stateSlice.recentAddresses,
    isCreator: stateSlice.isCreator,
    creatorMeetingFormats: PlaceViewMapper.fromMeetingFormats(
      stateSlice.creatorMeetingFormats,
    ),
    partnerMeetingFormats: PlaceViewMapper.fromMeetingFormats(
      stateSlice.partnerMeetingFormats,
    ),
    commonMeetingFormats: PlaceViewMapper.fromMeetingFormats(
      stateSlice.commonMeetingFormats,
    ),
    mySelectedMeetingFormat: mySelectedMeetingFormat == null
        ? null
        : PlaceViewMapper.fromMeetingFormat(mySelectedMeetingFormat),
    partnerSelectedMeetingFormat: partnerSelectedMeetingFormat == null
        ? null
        : PlaceViewMapper.fromMeetingFormat(partnerSelectedMeetingFormat),
    selectedMeetingFormat: stateSlice.selectedMeetingFormat == null
        ? null
        : PlaceViewMapper.fromMeetingFormat(stateSlice.selectedMeetingFormat!),
    lastAgreedMeetingFormat: stateSlice.lastAgreedMeetingFormat == null
        ? null
        : PlaceViewMapper.fromMeetingFormat(
            stateSlice.lastAgreedMeetingFormat!,
          ),
    meetingRevoteRequestByRole: stateSlice.meetingRevoteRequestByRole,
    meetingRevoteRequestStatus: PlaceViewMapper.fromRevoteRequestStatus(
      stateSlice.meetingRevoteRequestStatus,
    ),
    voteCounts: stateSlice.voteCounts,
    myVotePlaceName: stateSlice.votesByUser[currentUserId],
    isSessionClosed: stateSlice.isSessionClosed,
    sessionStatus: PlaceViewMapper.fromSessionStatus(stateSlice.sessionStatus),
    event: stateSlice.event == null
        ? null
        : RoomEventViewData.fromSnapshot(stateSlice.event!),
  );
});
