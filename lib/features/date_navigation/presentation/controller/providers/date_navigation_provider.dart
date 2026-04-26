import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/di/analytics_di.dart';
import '../../../../../core/di/auth_di.dart';
import '../../../di/date_navigation_di.dart';
import '../../state/date_navigation_state.dart';
import '../../view_models/room_control_panel_view_data.dart';
import '../address_submission_coordinator.dart';
import '../date_assistant_coordinator.dart';
import '../date_navigation_controller.dart';
import '../meeting_execution_coordinator.dart';
import '../room_interaction_coordinator.dart';
import '../room_lifecycle_coordinator.dart';

final addressSubmissionCoordinatorProvider =
    Provider<AddressSubmissionCoordinator>(
      (ref) => AddressSubmissionCoordinator(
        geocodeAddress: ref.watch(geocodeAddressProvider),
        updateLocation: ref.watch(updateLocationProvider),
        rememberAddress: ref.watch(rememberAddressProvider),
        analytics: ref.watch(analyticsServiceProvider),
      ),
    );

final roomLifecycleCoordinatorProvider = Provider<RoomLifecycleCoordinator>(
  (ref) => RoomLifecycleCoordinator(
    createRoom: ref.watch(createRoomProvider),
    completeSession: ref.watch(completeSessionProvider),
    joinRoom: ref.watch(joinRoomProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final roomInteractionCoordinatorProvider = Provider<RoomInteractionCoordinator>(
  (ref) => RoomInteractionCoordinator(
    voteForPlace: ref.watch(voteForPlaceProvider),
    proposePlace: ref.watch(proposePlaceProvider),
    respondToProposal: ref.watch(respondToProposalProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final meetingExecutionCoordinatorProvider =
    Provider<MeetingExecutionCoordinator>(
      (ref) => MeetingExecutionCoordinator(
        findMeetingPoint: ref.watch(findMeetingPointProvider),
        saveMeetingSnapshot: ref.watch(saveMeetingSnapshotProvider),
        analytics: ref.watch(analyticsServiceProvider),
      ),
    );

final dateAssistantCoordinatorProvider = Provider<DateAssistantCoordinator>(
  (ref) => DateAssistantCoordinator(
    buildDateScenarios: ref.watch(buildDateScenariosProvider),
    saveMeetingFormat: ref.watch(saveMeetingFormatProvider),
    confirmMeetingFormat: ref.watch(confirmMeetingFormatProvider),
    requestMeetingRevote: ref.watch(requestMeetingRevoteProvider),
    respondMeetingRevote: ref.watch(respondMeetingRevoteProvider),
    saveSelectedScenario: ref.watch(saveSelectedScenarioProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final dateNavigationControllerProvider =
    StateNotifierProvider.autoDispose<
      DateNavigationController,
      DateNavigationState
    >(
      (ref) => DateNavigationController(
        addressSubmission: ref.watch(addressSubmissionCoordinatorProvider),
        dateAssistant: ref.watch(dateAssistantCoordinatorProvider),
        meetingExecution: ref.watch(meetingExecutionCoordinatorProvider),
        roomInteraction: ref.watch(roomInteractionCoordinatorProvider),
        roomLifecycle: ref.watch(roomLifecycleCoordinatorProvider),
        watchRoom: ref.watch(watchRoomProvider),
        watchFrequentAddresses: ref.watch(watchFrequentAddressesProvider),
        removeRememberedAddress: ref.watch(removeRememberedAddressProvider),
        saveSearchRadius: ref.watch(saveSearchRadiusProvider),
        authSession: ref.watch(authSessionProvider),
        analytics: ref.watch(analyticsServiceProvider),
      ),
    );

final dateNavigationMapViewProvider = Provider.autoDispose(
  (ref) => ref.watch(
    dateNavigationControllerProvider.select(
      (s) => (
        isCreator: s.roomSession.isCreator,
        venueLocked: (s.meeting.finalChoiceName?.isNotEmpty ?? false),
        finalChoicePlace: s.meeting.finalChoicePlace,
        centerPoint: s.meeting.centerPoint,
        point1: s.roomSession.point1,
        point2: s.roomSession.point2,
        filteredPlaces: s.meeting.filteredPlaces,
        isLoading: s.isLoading,
        isGeocoding: s.loading.isGeocoding,
        isCalculatingMeeting: s.loading.isCalculatingMeeting,
        isLoadingRoomAction: s.loading.isLoadingRoomAction,
        searchRadius: s.meeting.searchRadius,
        routePoints: s.meeting.routePoints,
        sessionStatus: s.roomSession.sessionStatus,
      ),
    ),
  ),
);

final dateNavigationRoomBodyViewProvider = Provider.autoDispose(
  (ref) => ref.watch(
    dateNavigationControllerProvider.select(
      (s) => (
        roomId: s.roomSession.roomId,
        venueLocked: (s.meeting.finalChoiceName?.isNotEmpty ?? false),
        finalChoiceName: s.meeting.finalChoiceName,
        finalChoicePlace: s.meeting.finalChoicePlace,
        isCreator: s.roomSession.isCreator,
        isSessionClosed: s.roomSession.isClosed,
        sessionStatus: s.roomSession.sessionStatus,
        point1: s.roomSession.point1,
        point2: s.roomSession.point2,
        isLoading: s.isLoading,
        isGeocoding: s.loading.isGeocoding,
        isCalculatingMeeting: s.loading.isCalculatingMeeting,
        isLoadingRoomAction: s.loading.isLoadingRoomAction,
        filteredPlaces: s.meeting.filteredPlaces,
        recentAddresses: s.recentAddresses,
        selectedType: s.meeting.selectedType,
        creatorMeetingFormats: s.meeting.creatorMeetingFormats,
        partnerMeetingFormats: s.meeting.partnerMeetingFormats,
        commonMeetingFormats: s.meeting.commonMeetingFormats,
        creatorSelectedMeetingFormat: s.creatorSelectedMeetingFormat,
        partnerSelectedMeetingFormat: s.partnerSelectedMeetingFormat,
        selectedMeetingFormat: s.meeting.selectedMeetingFormat,
        lastAgreedMeetingFormat: s.meeting.lastAgreedMeetingFormat,
        meetingRevoteRequestByRole: s.meeting.meetingRevoteRequestByRole,
        meetingRevoteRequestStatus: s.meeting.meetingRevoteRequestStatus,
        dateScenarios: s.meeting.dateScenarios,
        selectedScenario: s.meeting.selectedScenario,
        searchRadius: s.meeting.searchRadius,
        voteCounts: s.voting.voteCounts,
        votesByUser: s.voting.votesByUser,
      ),
    ),
  ),
);

final dateNavigationMapOverlayViewProvider = Provider.autoDispose(
  (ref) => ref.watch(
    dateNavigationControllerProvider.select(
      (s) => (
        isCreator: s.roomSession.isCreator,
        point1: s.roomSession.point1,
        point2: s.roomSession.point2,
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
        roomId: s.roomSession.roomId,
        isCreator: s.roomSession.isCreator,
        isSessionClosed: s.roomSession.isClosed,
        sessionStatus: s.roomSession.sessionStatus,
        point1: s.roomSession.point1,
        point2: s.roomSession.point2,
        isLoading: s.isLoading,
        isGeocoding: s.loading.isGeocoding,
        isCalculatingMeeting: s.loading.isCalculatingMeeting,
        isLoadingRoomAction: s.loading.isLoadingRoomAction,
        filteredPlaces: s.meeting.filteredPlaces,
        recentAddresses: s.recentAddresses,
        selectedType: s.meeting.selectedType,
        creatorMeetingFormats: s.meeting.creatorMeetingFormats,
        partnerMeetingFormats: s.meeting.partnerMeetingFormats,
        commonMeetingFormats: s.meeting.commonMeetingFormats,
        creatorSelectedMeetingFormat: s.creatorSelectedMeetingFormat,
        partnerSelectedMeetingFormat: s.partnerSelectedMeetingFormat,
        selectedMeetingFormat: s.meeting.selectedMeetingFormat,
        lastAgreedMeetingFormat: s.meeting.lastAgreedMeetingFormat,
        meetingRevoteRequestByRole: s.meeting.meetingRevoteRequestByRole,
        meetingRevoteRequestStatus: s.meeting.meetingRevoteRequestStatus,
        searchRadius: s.meeting.searchRadius,
        voteCounts: s.voting.voteCounts,
        votesByUser: s.voting.votesByUser,
      ),
    ),
  );
  final currentUserId = ref.watch(
    authSessionProvider.select((auth) => auth.currentUserId ?? ''),
  );
  final roomId = stateSlice.roomId ?? '';
  final myLocation = stateSlice.isCreator ? stateSlice.point1 : stateSlice.point2;
  final partnerPoint = stateSlice.isCreator ? stateSlice.point2 : stateSlice.point1;
  final mySelectedMeetingFormat = stateSlice.isCreator
      ? stateSlice.creatorSelectedMeetingFormat
      : stateSlice.partnerSelectedMeetingFormat;
  final partnerSelectedMeetingFormat = stateSlice.isCreator
      ? stateSlice.partnerSelectedMeetingFormat
      : stateSlice.creatorSelectedMeetingFormat;
  return RoomControlPanelViewData(
    roomId: roomId,
    isLoading: stateSlice.isLoading,
    isGeocoding: stateSlice.isGeocoding,
    isCalculatingMeeting: stateSlice.isCalculatingMeeting,
    isLoadingRoomAction: stateSlice.isLoadingRoomAction,
    places: stateSlice.filteredPlaces,
    selectedType: stateSlice.selectedType,
    myLocation: myLocation,
    hasPartner: partnerPoint != null,
    searchRadius: stateSlice.searchRadius,
    recentAddresses: stateSlice.recentAddresses,
    isCreator: stateSlice.isCreator,
    creatorMeetingFormats: stateSlice.creatorMeetingFormats,
    partnerMeetingFormats: stateSlice.partnerMeetingFormats,
    commonMeetingFormats: stateSlice.commonMeetingFormats,
    mySelectedMeetingFormat: mySelectedMeetingFormat,
    partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
    selectedMeetingFormat: stateSlice.selectedMeetingFormat,
    lastAgreedMeetingFormat: stateSlice.lastAgreedMeetingFormat,
    meetingRevoteRequestByRole: stateSlice.meetingRevoteRequestByRole,
    meetingRevoteRequestStatus: stateSlice.meetingRevoteRequestStatus,
    voteCounts: stateSlice.voteCounts,
    myVotePlaceName: stateSlice.votesByUser[currentUserId],
    isSessionClosed: stateSlice.isSessionClosed,
    sessionStatus: stateSlice.sessionStatus,
  );
});
