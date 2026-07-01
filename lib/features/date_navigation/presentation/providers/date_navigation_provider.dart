import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/analytics_di.dart';
import '../../../../core/di/auth_di.dart';
import '../../../user_profile/user_profile.dart';
import '../../di/date_navigation_di.dart';
import '../state/date_navigation_state.dart';
import '../view_data/room_control_panel_data.dart';
import '../services/address_submission_service.dart';
import '../services/date_assistant_service.dart';
import '../controllers/date_navigation_controller.dart';
import '../services/meeting_execution_service.dart';
import '../services/room_interaction_service.dart';
import '../services/room_lifecycle_service.dart';

final addressSubmissionServiceProvider = Provider<AddressSubmissionService>(
  (ref) => AddressSubmissionService(
    geocodeAddress: ref.watch(geocodeAddressProvider),
    updateLocation: ref.watch(updateLocationProvider),
    rememberAddress: ref.watch(profileRememberUserAddressProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final roomLifecycleServiceProvider = Provider<RoomLifecycleService>(
  (ref) => RoomLifecycleService(
    createRoom: ref.watch(createRoomProvider),
    completeSession: ref.watch(completeSessionProvider),
    joinRoom: ref.watch(joinRoomProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final roomInteractionServiceProvider = Provider<RoomInteractionService>(
  (ref) => RoomInteractionService(
    voteForPlace: ref.watch(voteForPlaceProvider),
    proposePlace: ref.watch(proposePlaceProvider),
    respondToProposal: ref.watch(respondToProposalProvider),
    recordMeetingHistory: ref.watch(profileRecordMeetingHistoryProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final meetingExecutionServiceProvider = Provider<MeetingExecutionService>(
  (ref) => MeetingExecutionService(
    findMeetingPoint: ref.watch(findMeetingPointProvider),
    saveMeetingSnapshot: ref.watch(saveMeetingSnapshotProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final dateAssistantServiceProvider = Provider<DateAssistantService>(
  (ref) => DateAssistantService(
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
        addressSubmission: ref.watch(addressSubmissionServiceProvider),
        dateAssistant: ref.watch(dateAssistantServiceProvider),
        meetingExecution: ref.watch(meetingExecutionServiceProvider),
        roomInteraction: ref.watch(roomInteractionServiceProvider),
        roomLifecycle: ref.watch(roomLifecycleServiceProvider),
        watchRoom: ref.watch(watchRoomProvider),
        watchFrequentAddresses: ref.watch(
          profileWatchRememberedAddressesProvider,
        ),
        removeRememberedAddress: ref.watch(
          profileRemoveRememberedUserAddressProvider,
        ),
        saveSearchRadius: ref.watch(saveSearchRadiusProvider),
        authSession: ref.watch(authSessionProvider),
        analytics: ref.watch(analyticsServiceProvider),
      ),
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
        filteredPlaces: s.meeting.filteredPlaces,
        isLoading: s.ui.isLoading,
        isGeocoding: s.ui.isGeocoding,
        isCalculatingMeeting: s.ui.isCalculatingMeeting,
        isLoadingRoomAction: s.ui.isLoadingRoomAction,
        searchRadius: s.meeting.searchRadius,
        routePoints: s.meeting.routePoints,
        sessionStatus: s.room.sessionStatus,
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
