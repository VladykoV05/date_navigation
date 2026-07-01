import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/auth_session.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../user_profile/user_profile.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../domain/usecases/save_search_radius.dart';
import '../../domain/usecases/watch_room.dart';
import '../../application/policies/meeting_guard_policy.dart';
import '../../application/services/address_submission_service.dart';
import '../../application/services/date_assistant_service.dart';
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

class DateNavigationController extends StateNotifier<DateNavigationState> {
  static const Duration _snapshotFreshFor = Duration(seconds: 20);

  DateNavigationController({
    required AddressSubmissionService addressSubmission,
    required DateAssistantService dateAssistant,
    required MeetingExecutionService meetingExecution,
    required RoomInteractionService roomInteraction,
    required RoomLifecycleService roomLifecycle,
    required WatchRoom watchRoom,
    required WatchRememberedAddresses watchFrequentAddresses,
    required RemoveRememberedUserAddress removeRememberedAddress,
    required SaveSearchRadius saveSearchRadius,
    required AuthSession authSession,
    required AnalyticsService analytics,
  }) : _addressSubmission = addressSubmission,
       _dateAssistant = dateAssistant,
       _meetingExecution = meetingExecution,
       _roomInteraction = roomInteraction,
       _roomLifecycle = roomLifecycle,
       _watchRoom = watchRoom,
       _watchFrequentAddresses = watchFrequentAddresses,
       _removeRememberedAddress = removeRememberedAddress,
       _saveSearchRadius = saveSearchRadius,
       _authSession = authSession,
       _analytics = analytics,
       super(const DateNavigationState()) {
    _subscribeToFrequentAddresses();
  }

  final AddressSubmissionService _addressSubmission;
  final DateAssistantService _dateAssistant;
  final MeetingExecutionService _meetingExecution;
  final RoomInteractionService _roomInteraction;
  final RoomLifecycleService _roomLifecycle;
  final WatchRoom _watchRoom;
  final WatchRememberedAddresses _watchFrequentAddresses;
  final RemoveRememberedUserAddress _removeRememberedAddress;
  final SaveSearchRadius _saveSearchRadius;
  final AuthSession _authSession;
  final AnalyticsService _analytics;
  late final MeetingPlanningController _meetingPlanningController =
      MeetingPlanningController(
        dateAssistant: _dateAssistant,
        meetingExecution: _meetingExecution,
        saveSearchRadius: _saveSearchRadius,
        analytics: _analytics,
        readState: () => state,
        writeState: (next) => state = next,
        ensureSessionActive: _ensureSessionActive,
        ensureMeetingFormatMatched: _ensureMeetingFormatMatched,
        requireUserId: _requireUserId,
        setFailure: _setFailure,
        clearFailure: _clearFailure,
        setRoomActionLoading: _setRoomActionLoading,
        setMeetingLoading: _setMeetingLoading,
      );
  late final RoomStreamSubscription _roomStreamSubscription =
      RoomStreamSubscription(watchRoom: _watchRoom);
  final MeetingGuardPolicy _meetingGuard = const MeetingGuardPolicy();
  final ProposalActions _proposalActions = const ProposalActions();
  final VoteScenarioActions _voteScenarioActions = const VoteScenarioActions();
  final RoomSessionStateTransitions _roomActions =
      const RoomSessionStateTransitions();
  final MeetingInteractionTransitions _meetingInteraction =
      const MeetingInteractionTransitions();
  late final FrequentAddressesSubscription _frequentAddressesSubscription =
      FrequentAddressesSubscription(
        watchFrequentAddresses: _watchFrequentAddresses,
      );
  late final RoomSessionController _roomSessionController =
      RoomSessionController(
        roomLifecycle: _roomLifecycle,
        roomActions: _roomActions,
        meetingPlanner: _meetingPlanningController.meetingPlanner,
        readState: () => state,
        writeState: (next) => state = next,
        requireUserId: _requireUserId,
        setFailure: _setFailure,
        clearFailure: _clearFailure,
        setRoomActionLoading: _setRoomActionLoading,
        cancelRoomSubscription: _roomStreamSubscription.cancel,
        subscribeToRoom: _subscribeToRoom,
      );
  late final AddressMemoryController _addressMemoryController =
      AddressMemoryController(
        removeRememberedAddress: _removeRememberedAddress,
        requireUserId: _requireUserId,
        setFailure: _setFailure,
        clearFailure: _clearFailure,
      );
  late final VotingController _votingController = VotingController(
    roomInteraction: _roomInteraction,
    dateAssistant: _dateAssistant,
    proposalActions: _proposalActions,
    voteScenarioActions: _voteScenarioActions,
    meetingInteraction: _meetingInteraction,
    readState: () => state,
    writeState: (next) => state = next,
    ensureSessionActive: _ensureSessionActive,
    ensureMeetingFormatMatched: _ensureMeetingFormatMatched,
    requireUserId: _requireUserId,
    setFailure: _setFailure,
    clearFailure: _clearFailure,
    setRoomActionLoading: _setRoomActionLoading,
  );

  int _geocodeRequestSeq = 0;

  String get userId => _authSession.currentUserId ?? '';

  String? _requireUserId(String operation) {
    final uid = _authSession.currentUserId;
    if (uid != null && uid.isNotEmpty) return uid;
    _setFailure(const UnknownFailure('Пользователь не авторизован'), operation);
    return null;
  }

  void _clearFailure() {
    state = state.copyWith(
      ui: state.ui.copyWith(lastFailure: null, failureOperation: null),
    );
  }

  void _setFailure(Failure failure, String operation) {
    state = state.copyWith(
      ui: state.ui.copyWith(lastFailure: failure, failureOperation: operation),
    );
  }

  void _setRoomActionLoading(bool value) {
    state = state.copyWith(ui: state.ui.copyWith(isLoadingRoomAction: value));
  }

  void _setGeocodingLoading(bool value) {
    state = state.copyWith(ui: state.ui.copyWith(isGeocoding: value));
  }

  void _setMeetingLoading(bool value) {
    state = state.copyWith(ui: state.ui.copyWith(isCalculatingMeeting: value));
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

  @override
  void dispose() {
    unawaited(_roomStreamSubscription.cancel());
    unawaited(_frequentAddressesSubscription.dispose());
    super.dispose();
  }

  Future<void> createRoom() async {
    await _roomSessionController.createRoom();
  }

  void joinRoom(String code) {
    _roomSessionController.joinRoom(code);
  }

  Future<bool> submitMyAddress(String address) async {
    final uid = _requireUserId('geocode');
    if (uid == null) return false;
    if (address.isEmpty || state.room.roomId == null) return false;
    if (!_ensureSessionActive('geocode')) return false;
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
      onData: (addresses) => state = state.copyWith(
        addressMemory: state.addressMemory.copyWith(recentAddresses: addresses),
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
    );
  }

  void _applyRoomStreamApplication(RoomStreamApplicationResult application) {
    state = application.nextState;
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
