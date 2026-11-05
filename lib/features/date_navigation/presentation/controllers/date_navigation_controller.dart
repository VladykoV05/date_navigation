import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/analytics_di.dart';
import '../../../../core/di/auth_di.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_codes.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/auth_session.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../user_profile/user_profile.dart';
import '../../di/application_providers.dart';
import '../../di/date_navigation_di.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../domain/usecases/save_search_radius.dart';
import '../../domain/usecases/watch_room.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/observability.dart';
import '../../application/policies/failure_retry_policy.dart';
import '../../application/policies/meeting_guard_policy.dart';
import '../../application/services/address_submission_service.dart';
import '../../application/services/date_assistant_service.dart';
import '../../application/services/location_submission_service.dart';
import '../../application/services/meeting_execution_service.dart';
import '../../application/services/room_interaction_service.dart';
import '../../application/services/room_lifecycle_service.dart';
import './address_memory_controller.dart';
import '../subscriptions/frequent_addresses_subscription.dart';
import '../../application/state_transitions/meeting_interaction_transitions.dart';
import './meeting_planning_controller.dart';
import '../../application/actions/proposal_actions.dart';
import '../../application/state_transitions/room_session_state_transitions.dart';
import './room_session_controller.dart';
import '../../application/flows/room_stream_application.dart';
import '../subscriptions/room_stream_subscription.dart';
import '../../application/actions/vote_scenario_actions.dart';
import './voting_controller.dart';
import '../../application/state/date_navigation_state.dart';
import '../providers/date_navigation_service_providers.dart';

class DateNavigationController extends Notifier<DateNavigationState> {
  static const Duration _snapshotFreshFor = Duration(seconds: 20);

  late AddressSubmissionService _addressSubmission;
  late DateAssistantService _dateAssistant;
  late MeetingExecutionService _meetingExecution;
  late RoomInteractionService _roomInteraction;
  late RoomLifecycleService _roomLifecycle;
  late WatchRoom _watchRoom;
  late WatchRememberedAddresses _watchFrequentAddresses;
  late RemoveRememberedUserAddress _removeRememberedAddress;
  late SaveSearchRadius _saveSearchRadius;
  late LocationSubmissionService _locationSubmission;
  late AuthSession _authSession;
  late AnalyticsService _analytics;
  late MeetingGuardPolicy _meetingGuard;
  late ProposalActions _proposalActions;
  late VoteScenarioActions _voteScenarioActions;
  late RoomSessionStateTransitions _roomActions;
  late MeetingInteractionTransitions _meetingInteraction;
  late MeetingPlanningController _meetingPlanningController;
  late RoomStreamSubscription _roomStreamSubscription;
  late FrequentAddressesSubscription _frequentAddressesSubscription;
  late RoomSessionController _roomSessionController;
  late AddressMemoryController _addressMemoryController;
  late VotingController _votingController;

  int _geocodeRequestSeq = 0;
  bool _disposed = false;
  String? _lastSubmittedAddress;
  static const _retryPolicy = FailureRetryPolicy();

  @override
  DateNavigationState build() {
    _disposed = false;
    // Use read (not watch): rebuilding this Notifier would wipe the room session.
    _addressSubmission = ref.read(addressSubmissionServiceProvider);
    _dateAssistant = ref.read(dateAssistantServiceProvider);
    _meetingExecution = ref.read(meetingExecutionServiceProvider);
    _roomInteraction = ref.read(roomInteractionServiceProvider);
    _roomLifecycle = ref.read(roomLifecycleServiceProvider);
    _watchRoom = ref.read(watchRoomProvider);
    _watchFrequentAddresses = ref.read(profileWatchRememberedAddressesProvider);
    _removeRememberedAddress = ref.read(
      profileRemoveRememberedUserAddressProvider,
    );
    _saveSearchRadius = ref.read(saveSearchRadiusProvider);
    _locationSubmission = ref.read(locationSubmissionServiceProvider);
    _authSession = ref.read(authSessionProvider);
    _analytics = ref.read(analyticsServiceProvider);
    _meetingGuard = ref.read(meetingGuardPolicyProvider);
    _proposalActions = ref.read(proposalActionsProvider);
    _voteScenarioActions = ref.read(voteScenarioActionsProvider);
    _roomActions = ref.read(roomSessionStateTransitionsProvider);
    _meetingInteraction = ref.read(meetingInteractionTransitionsProvider);

    _meetingPlanningController = MeetingPlanningController(
      dateAssistant: _dateAssistant,
      chatRepository: ref.read(chatRepositoryProvider),
      meetingExecution: _meetingExecution,
      saveSearchRadius: _saveSearchRadius,
      analytics: _analytics,
      readState: () => state,
      writeState: _writeState,
      ensureSessionActive: _ensureSessionActive,
      ensureMeetingFormatMatched: _ensureMeetingFormatMatched,
      requireUserId: _requireUserId,
      setFailure: _setFailure,
      clearFailure: _clearFailure,
      setRoomActionLoading: _setRoomActionLoading,
      setMeetingLoading: _setMeetingLoading,
    );
    _roomStreamSubscription = RoomStreamSubscription(watchRoom: _watchRoom);
    _frequentAddressesSubscription = FrequentAddressesSubscription(
      watchFrequentAddresses: _watchFrequentAddresses,
    );
    _roomSessionController = RoomSessionController(
      roomLifecycle: _roomLifecycle,
      chatRepository: ref.read(chatRepositoryProvider),
      roomActions: _roomActions,
      meetingPlanner: _meetingPlanningController.meetingPlanner,
      readState: () => state,
      writeState: _writeState,
      requireUserId: _requireUserId,
      setFailure: _setFailure,
      clearFailure: _clearFailure,
      setRoomActionLoading: _setRoomActionLoading,
      cancelRoomSubscription: _roomStreamSubscription.cancel,
      subscribeToRoom: _subscribeToRoom,
    );
    _addressMemoryController = AddressMemoryController(
      removeRememberedAddress: _removeRememberedAddress,
      requireUserId: _requireUserId,
      setFailure: _setFailure,
      clearFailure: _clearFailure,
    );
    _votingController = VotingController(
      roomInteraction: _roomInteraction,
      chatRepository: ref.read(chatRepositoryProvider),
      dateAssistant: _dateAssistant,
      proposalActions: _proposalActions,
      voteScenarioActions: _voteScenarioActions,
      meetingInteraction: _meetingInteraction,
      readState: () => state,
      writeState: _writeState,
      ensureSessionActive: _ensureSessionActive,
      ensureMeetingFormatMatched: _ensureMeetingFormatMatched,
      requireUserId: _requireUserId,
      setFailure: _setFailure,
      clearFailure: _clearFailure,
      setRoomActionLoading: _setRoomActionLoading,
    );

    ref.onDispose(() {
      _disposed = true;
      _meetingPlanningController.meetingPlanner.resetAll();
      unawaited(_roomStreamSubscription.cancel());
      unawaited(_frequentAddressesSubscription.dispose());
    });

    _subscribeToFrequentAddresses();
    return const DateNavigationState();
  }

  String get userId => _authSession.currentUserId ?? '';

  String? _requireUserId(String operation) {
    final uid = _authSession.currentUserId;
    if (uid != null && uid.isNotEmpty) return uid;
    _setFailure(
      const UnknownFailure(FailureCodes.userNotAuthenticated),
      operation,
    );
    return null;
  }

  void _writeState(DateNavigationState next) {
    if (_disposed) return;
    state = next;
  }

  void _clearFailure() {
    _writeState(
      state.copyWith(
        ui: state.ui.copyWith(lastFailure: null, failureOperation: null),
      ),
    );
  }

  void _setFailure(Failure failure, String operation) {
    AppLogger.w('Failure[$operation]: ${failure.message}');
    _writeState(
      state.copyWith(
        ui: state.ui.copyWith(
          lastFailure: failure,
          failureOperation: operation,
        ),
      ),
    );
  }

  void _setRoomActionLoading(bool value) {
    _writeState(
      state.copyWith(ui: state.ui.copyWith(isLoadingRoomAction: value)),
    );
  }

  void _setGeocodingLoading(bool value) {
    _writeState(state.copyWith(ui: state.ui.copyWith(isGeocoding: value)));
  }

  void _setMeetingLoading(bool value) {
    _writeState(
      state.copyWith(ui: state.ui.copyWith(isCalculatingMeeting: value)),
    );
  }

  bool _ensureSessionActive(String operation) {
    final failure = _meetingGuard.ensureSessionActive(
      isSessionClosed: state.room.isClosed,
    );
    if (failure == null) return true;
    _setFailure(failure, operation);
    return false;
  }

  bool _ensureMeetingFormatMatched(String operation) {
    final failure = _meetingGuard.ensureMeetingFormatMatched(
      selectedMeetingFormat: state.meeting.selectedMeetingFormat,
    );
    if (failure == null) return true;
    _setFailure(failure, operation);
    return false;
  }

  Future<void> createRoom() async {
    await _roomSessionController.createRoom();
  }

  Future<void> createOpenRoom({
    required int capacity,
    RoomEventSnapshot? event,
  }) => _roomSessionController.createOpenRoom(capacity: capacity, event: event);

  Future<void> joinOpenRoom(String roomId) =>
      _roomSessionController.joinOpenRoom(roomId);

  void joinRoom(String code) {
    _roomSessionController.joinRoom(code);
  }

  Future<bool> submitMyAddress(String address) async {
    final uid = _requireUserId('geocode');
    if (uid == null) return false;
    if (address.isEmpty || state.room.roomId == null) return false;
    if (!_ensureSessionActive('geocode')) return false;
    _lastSubmittedAddress = address;
    Observability.breadcrumb('geocode_start', data: {'len': address.length});
    final req = ++_geocodeRequestSeq;
    _setGeocodingLoading(true);
    _clearFailure();
    final res = await _addressSubmission.submitAddress(
      roomId: state.room.roomId!,
      userId: uid,
      address: address,
    );
    if (req != _geocodeRequestSeq) return false;
    switch (res) {
      case Err(:final failure):
        _setGeocodingLoading(false);
        _setFailure(failure, 'geocode');
        return false;
      case Ok():
        _setGeocodingLoading(false);
        _clearFailure();
        return true;
    }
  }

  Future<bool> submitMyLocation() async {
    final uid = _requireUserId('location');
    if (uid == null) return false;
    final roomId = state.room.roomId;
    if (roomId == null) return false;
    if (!_ensureSessionActive('location')) return false;

    _setGeocodingLoading(true);
    _clearFailure();
    try {
      final result = await _locationSubmission.submitCurrentLocation(
        roomId: roomId,
        userId: uid,
      );
      switch (result) {
        case Err(:final failure):
          _setFailure(failure, 'location');
          return false;
        case Ok():
          unawaited(_analytics.locationSubmitted());
          _clearFailure();
          return true;
      }
    } finally {
      _setGeocodingLoading(false);
    }
  }

  Future<void> removeRememberedAddress(String address) async {
    await _addressMemoryController.removeRememberedAddress(address);
  }

  Future<void> removeRememberedAddresses(Iterable<String> addresses) async {
    await _addressMemoryController.removeRememberedAddresses(addresses);
  }

  void setSelectedType(String? type) {
    _meetingPlanningController.setSelectedType(type);
  }

  void setSearchRadius(double value) {
    _meetingPlanningController.setSearchRadius(value);
  }

  Future<void> recalculateForRadius() async {
    await _meetingPlanningController.recalculateForRadius();
  }

  /// Bumps search radius by one slider step (≈200m) then recalculates places.
  Future<void> expandSearchRadiusAndRetry() async {
    const step = 200.0;
    const maxRadius = 3000.0;
    final next = (state.meeting.searchRadius + step).clamp(200.0, maxRadius);
    setSearchRadius(next);
    await recalculateForRadius();
  }

  Future<void> calculateMeeting() async {
    await _meetingPlanningController.calculateMeeting();
  }

  Future<void> voteForPlace(Place place) async {
    await _votingController.voteForPlace(place);
  }

  Future<void> proposePlace(Place place) async {
    await _votingController.proposePlace(place);
  }

  Future<void> respondToProposal(ProposalResponseDecision decision) async {
    await _votingController.respondToProposal(decision);
  }

  void clearError() {
    if (state.ui.errorMessage != null) {
      _clearFailure();
    }
  }

  Future<void> retryLastFailure() async {
    final failure = state.ui.lastFailure;
    if (failure == null) return;
    final action = _retryPolicy.actionFor(
      failure: failure,
      failureOperation: state.ui.failureOperation,
      hasBothPoints: state.room.point1 != null && state.room.point2 != null,
    );
    switch (action) {
      case FailureRetryAction.recalculateMeeting:
        await recalculateForRadius();
      case FailureRetryAction.retryGeocode:
        final address = _lastSubmittedAddress;
        if (address != null && address.isNotEmpty) {
          await submitMyAddress(address);
        } else {
          _clearFailure();
        }
      case FailureRetryAction.resubscribeRoom:
        final roomId = state.room.roomId;
        if (roomId == null || roomId.isEmpty) {
          _clearFailure();
          return;
        }
        Observability.breadcrumb('room_stream_retry', data: {'roomId': roomId});
        _clearFailure();
        _subscribeToRoom(roomId);
      case FailureRetryAction.none:
        break;
    }
  }

  Future<void> completeSession() async {
    await _roomSessionController.completeSession();
  }

  Future<void> startNewRoom() async {
    await _roomSessionController.startNewRoom();
  }

  void setMeetingFormats(Set<MeetingFormat> formats) {
    _meetingPlanningController.setMeetingFormats(formats);
  }

  void confirmMeetingFormat(MeetingFormat format) {
    _meetingPlanningController.confirmMeetingFormat(format);
  }

  Future<void> applyPartnerRadiusSuggestion() async {
    await _meetingPlanningController.applyPartnerRadiusSuggestion();
  }

  void respondMeetingRevote(MeetingRevoteResponseDecision decision) {
    _meetingPlanningController.respondMeetingRevote(decision);
  }

  void applyPartnerMeetingFormatSuggestion() {
    _meetingPlanningController.applyPartnerMeetingFormatSuggestion();
  }

  Future<void> selectScenario(DateScenario scenario) async {
    await _votingController.selectScenario(scenario);
  }

  /// Выход из комнаты на этом устройстве (подписка снимается, локальное состояние сбрасывается).
  void leaveRoom() {
    _roomSessionController.leaveRoom();
  }

  void _subscribeToFrequentAddresses() {
    _frequentAddressesSubscription.bind(
      userId: _authSession.currentUserId,
      onData: (addresses) => _writeState(
        state.copyWith(
          addressMemory: state.addressMemory.copyWith(
            recentAddresses: addresses,
          ),
        ),
      ),
    );
  }

  void _subscribeToRoom(String code) {
    _roomStreamSubscription.bind(
      roomId: code,
      currentState: () => state,
      userId: userId,
      meetingPlanner: _meetingPlanningController.meetingPlanner,
      snapshotFreshFor: _snapshotFreshFor,
      onApplication: _applyRoomStreamApplication,
      onError: (error, stack) {
        AppLogger.e('Room stream failed', error, stack);
        _setFailure(
          const NetworkFailure(FailureCodes.roomStreamFailed),
          'room_stream',
        );
      },
    );
  }

  void _applyRoomStreamApplication(RoomStreamApplicationResult application) {
    _writeState(application.nextState);
    if (application.matchedFormatToTrack != null) {
      unawaited(
        _analytics.meetingFormatMatched(
          format: application.matchedFormatToTrack!,
        ),
      );
    }
    if (application.shouldStartMeetingSearch ||
        application.shouldRecoverMissingMeeting ||
        application.shouldCalculateAsCreator) {
      unawaited(calculateMeeting());
    }
    if (application.shouldSyncScenarioForFinalChoice) {
      _meetingPlanningController.syncScenarioForFinalChoice();
    }
    if (application.snapshotRadiusToSync != null) {
      _meetingPlanningController.meetingPlanner.syncFetchedRadiusFromSnapshot(
        application.snapshotRadiusToSync,
      );
    }
    if (application.shouldResetPlannerOnPointsChanged) {
      _meetingPlanningController.meetingPlanner.resetOnPointsChanged();
    }
    if (application.shouldStopCalculating) {
      _meetingPlanningController.stopCalculating();
    }
    if (application.shouldCalculateWithPartnerFallback &&
        application.fallbackPoint1 != null &&
        application.fallbackPoint2 != null) {
      unawaited(
        _meetingPlanningController.calculateMeetingFallbackForPartner(
          point1: application.fallbackPoint1!,
          point2: application.fallbackPoint2!,
        ),
      );
    }
  }

  double scorePlace(Place place) =>
      _meetingPlanningController.scorePlace(place);
}
