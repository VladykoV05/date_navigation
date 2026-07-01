import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/auth_session.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../user_profile/domain/usecases/remember_user_address.dart';
import '../../../user_profile/domain/usecases/watch_remembered_addresses.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/meeting_point.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../domain/usecases/save_search_radius.dart';
import '../../domain/usecases/watch_room.dart';
import 'address_memory_controller.dart';
import 'address_submission_coordinator.dart';
import 'date_assistant_coordinator.dart';
import 'frequent_addresses_subscription_coordinator.dart';
import 'flows/final_choice_scenario_sync_coordinator.dart';
import 'meeting_execution_coordinator.dart';
import 'actions/meeting_collaboration_actions_coordinator.dart';
import 'actions/meeting_format_actions_coordinator.dart';
import 'meeting_guard_coordinator.dart';
import 'meeting_interaction_coordinator.dart';
import 'meeting_planner_coordinator.dart';
import 'meeting_state_coordinator.dart';
import 'flows/partner_fallback_coordinator.dart';
import 'flows/partner_fallback_effects_coordinator.dart';
import 'flows/partner_fallback_request_coordinator.dart';
import 'flows/partner_fallback_result_coordinator.dart';
import 'actions/proposal_actions_coordinator.dart';
import 'recalculate_policy_coordinator.dart';
import 'room_actions_coordinator.dart';
import 'room_interaction_coordinator.dart';
import 'room_lifecycle_coordinator.dart';
import 'room_session_controller.dart';
import 'flows/room_stream_application_coordinator.dart';
import 'room_stream_subscription_coordinator.dart';
import 'flows/search_radius_persistence_coordinator.dart';
import 'actions/vote_scenario_actions_coordinator.dart';
import 'voting_controller.dart';
import '../state/date_navigation_state.dart';

class DateNavigationController extends StateNotifier<DateNavigationState> {
  static const Duration _snapshotFreshFor = Duration(seconds: 20);

  DateNavigationController({
    required AddressSubmissionCoordinator addressSubmission,
    required DateAssistantCoordinator dateAssistant,
    required MeetingExecutionCoordinator meetingExecution,
    required RoomInteractionCoordinator roomInteraction,
    required RoomLifecycleCoordinator roomLifecycle,
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

  final AddressSubmissionCoordinator _addressSubmission;
  final DateAssistantCoordinator _dateAssistant;
  final MeetingExecutionCoordinator _meetingExecution;
  final RoomInteractionCoordinator _roomInteraction;
  final RoomLifecycleCoordinator _roomLifecycle;
  final WatchRoom _watchRoom;
  final WatchRememberedAddresses _watchFrequentAddresses;
  final RemoveRememberedUserAddress _removeRememberedAddress;
  final SaveSearchRadius _saveSearchRadius;
  final AuthSession _authSession;
  final AnalyticsService _analytics;
  final MeetingPlannerCoordinator _meetingPlanner = MeetingPlannerCoordinator();
  final RecalculatePolicyCoordinator _recalculatePolicy =
      const RecalculatePolicyCoordinator();
  late final RoomStreamSubscriptionCoordinator _roomStreamSubscription =
      RoomStreamSubscriptionCoordinator(watchRoom: _watchRoom);
  final MeetingGuardCoordinator _meetingGuard = const MeetingGuardCoordinator();
  final MeetingFormatActionsCoordinator _meetingFormatActions =
      const MeetingFormatActionsCoordinator();
  final MeetingCollaborationActionsCoordinator _meetingCollaborationActions =
      const MeetingCollaborationActionsCoordinator();
  final ProposalActionsCoordinator _proposalActions =
      const ProposalActionsCoordinator();
  final VoteScenarioActionsCoordinator _voteScenarioActions =
      const VoteScenarioActionsCoordinator();
  final RoomActionsCoordinator _roomActions = const RoomActionsCoordinator();
  final MeetingInteractionCoordinator _meetingInteraction =
      const MeetingInteractionCoordinator();
  final MeetingStateCoordinator _meetingState = const MeetingStateCoordinator();
  final PartnerFallbackCoordinator _partnerFallback =
      const PartnerFallbackCoordinator();
  final PartnerFallbackRequestCoordinator _partnerFallbackRequest =
      const PartnerFallbackRequestCoordinator();
  final PartnerFallbackEffectsCoordinator _partnerFallbackEffects =
      const PartnerFallbackEffectsCoordinator();
  late final PartnerFallbackResultCoordinator _partnerFallbackResult =
      PartnerFallbackResultCoordinator(_partnerFallback);
  late final FrequentAddressesSubscriptionCoordinator
  _frequentAddressesSubscription = FrequentAddressesSubscriptionCoordinator(
    watchFrequentAddresses: _watchFrequentAddresses,
  );
  final FinalChoiceScenarioSyncCoordinator _finalChoiceScenarioSync =
      const FinalChoiceScenarioSyncCoordinator();
  final SearchRadiusPersistenceCoordinator _searchRadiusPersistence =
      const SearchRadiusPersistenceCoordinator();
  late final RoomSessionController _roomSessionController =
      RoomSessionController(
        roomLifecycle: _roomLifecycle,
        roomActions: _roomActions,
        meetingPlanner: _meetingPlanner,
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
    state = state.copyWith(lastFailure: null, failureOperation: null);
  }

  void _setFailure(Failure failure, String operation) {
    state = state.copyWith(lastFailure: failure, failureOperation: operation);
  }

  void _setRoomActionLoading(bool value) {
    state = state.copyWith(isLoadingRoomAction: value);
  }

  void _setGeocodingLoading(bool value) {
    state = state.copyWith(isGeocoding: value);
  }

  void _setMeetingLoading(bool value) {
    state = state.copyWith(isCalculatingMeeting: value);
  }

  bool _ensureSessionActive(String operation) {
    final failure = _meetingGuard.ensureSessionActive(state);
    if (failure == null) return true;
    _setFailure(failure, operation);
    return false;
  }

  bool _ensureMeetingFormatMatched(String operation) {
    final failure = _meetingGuard.ensureMeetingFormatMatched(state);
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
    if (address.isEmpty || state.roomId == null) return false;
    if (!_ensureSessionActive('geocode')) return false;
    final req = ++_geocodeRequestSeq;
    _setGeocodingLoading(true);
    _clearFailure();
    final res = await _addressSubmission.submitAddress(
      roomId: state.roomId!,
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
    if (!_ensureSessionActive('meeting')) return;
    final filtered = _meetingPlanner.computeFilteredPlaces(
      places: state.foundPlaces,
      point1: state.point1,
      point2: state.point2,
      selectedType: type,
      centerPoint: state.centerPoint,
      searchRadius: state.searchRadius,
      meetingFormat: state.selectedMeetingFormat,
    );
    state = state.copyWith(selectedType: type, filteredPlaces: filtered);
  }

  void setSearchRadius(double value) {
    if (!_ensureSessionActive('meeting')) return;
    state = state.copyWith(searchRadius: value);
  }

  Future<void> recalculateForRadius() async {
    if (!_ensureSessionActive('meeting')) return;
    if (!_ensureMeetingFormatMatched('meeting')) return;
    await _persistMySearchRadius();
    if (!_recalculatePolicy.canRecalculate(state)) return;
    final meeting = state.meeting;
    final center = meeting.centerPoint;
    final hasCenterAndPlaces = center != null && meeting.foundPlaces.isNotEmpty;
    if (hasCenterAndPlaces) {
      final filtered = _meetingPlanner.computeFilteredPlaces(
        places: meeting.foundPlaces,
        point1: state.roomSession.point1,
        point2: state.roomSession.point2,
        selectedType: meeting.selectedType,
        centerPoint: center,
        searchRadius: meeting.searchRadius,
        meetingFormat: state.selectedMeetingFormat,
      );
      state = state.copyWith(
        filteredPlaces: filtered,
        isCalculatingMeeting: false,
      );
      _clearFailure();
      final shouldStop = _recalculatePolicy.shouldStopAfterLocalFilter(
        state: state,
        hasCenterAndPlaces: hasCenterAndPlaces,
        shouldSkipRadiusFetch: _meetingPlanner.shouldSkipRadiusFetch(
          state.meeting.searchRadius,
        ),
      );
      if (shouldStop) return;
    }
    await calculateMeeting();
  }

  Future<void> calculateMeeting() async {
    if (!_ensureSessionActive('meeting')) return;
    if (state.selectedMeetingFormat == null) return;
    if (_meetingPlanner.isMeetingInFlight) {
      _meetingPlanner.requestMeetingRecalculate();
      return;
    }
    final roomSession = state.roomSession;
    final meeting = state.meeting;
    if (meeting.finalChoiceName != null &&
        meeting.finalChoiceName!.isNotEmpty) {
      return;
    }
    final point1 = roomSession.point1;
    final point2 = roomSession.point2;
    if (point1 == null || point2 == null) return;

    final req = _meetingPlanner.nextMeetingRequest();
    final format = state.selectedMeetingFormat!;
    final meetingKey = _meetingPlanner.buildMeetingKey(
      point1: point1,
      point2: point2,
      searchRadius: meeting.searchRadius.round(),
      format: format,
    );
    if (_meetingPlanner.canReuseMeetingResult(
      meetingKey: meetingKey,
      hasCenterPoint: meeting.centerPoint != null,
    )) {
      return;
    }

    _setMeetingLoading(true);
    _clearFailure();
    await _meetingPlanner.runMeetingTask(() async {
      try {
        final res = await _meetingExecution.calculateMeeting(
          searchRadius: state.meeting.searchRadius.round(),
          point1: point1,
          point2: point2,
          format: format,
          trackAnalytics: true,
        );
        if (_meetingPlanner.isStaleRequest(req)) return;
        switch (res) {
          case Err(:final failure):
            final fallbackFailure = _partnerFallbackResult.resolveDomainFailure(
              failure,
            );
            if (fallbackFailure.shouldStopLoading) {
              _setMeetingLoading(false);
            }
            _setFailure(fallbackFailure.failure, 'meeting');
          case Ok(value: final meeting):
            final filtered = _meetingPlanner.computeFilteredPlaces(
              places: meeting.nearbyPlaces,
              point1: point1,
              point2: point2,
              selectedType: state.meeting.selectedType,
              centerPoint: meeting.location,
              searchRadius: state.meeting.searchRadius,
              meetingFormat: state.selectedMeetingFormat,
            );
            if (_meetingPlanner.isStaleRequest(req)) return;
            if (_meetingState.isVenueLocked(state)) {
              state = state.copyWith(isCalculatingMeeting: false);
              return;
            }
            _meetingPlanner.markMeetingCalculated(
              meetingKey: meetingKey,
              fetchedRadius: state.meeting.searchRadius.round(),
            );
            state = _meetingState.applyMeetingSuccess(
              state: state,
              meeting: meeting,
              filteredPlaces: filtered,
            );
            _clearFailure();
            if (state.roomSession.roomId != null &&
                state.roomSession.isCreator) {
              _meetingExecution.saveSnapshot(
                roomId: state.roomSession.roomId!,
                centerPoint: meeting.location,
                routePoints: meeting.fullRouteGeometry,
                places: meeting.nearbyPlaces,
                searchRadius: state.meeting.searchRadius.round(),
                meetingFormat: format,
              );
            }
        }
      } catch (e, stack) {
        AppLogger.e('Calculate meeting failed', e, stack);
        if (_meetingPlanner.isStaleRequest(req)) return;
        _setMeetingLoading(false);
        _setFailure(
          const UnknownFailure('Не удалось рассчитать точку встречи'),
          'meeting',
        );
      }
    });
    if (_meetingPlanner.consumeMeetingRecalculateRequest()) {
      unawaited(calculateMeeting());
    }
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
    if (state.errorMessage != null) {
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
    unawaited(_setMeetingFormatsInternal(formats));
  }

  Future<void> _setMeetingFormatsInternal(Set<MeetingFormat> formats) async {
    if (!_ensureSessionActive('meeting')) return;
    final roomId = state.roomId;
    final uid = _requireUserId('meeting');
    if (roomId == null || uid == null) return;
    final decision = _meetingFormatActions.resolveSetFormatsAction(
      state: state,
      nextFormats: formats,
    );
    switch (decision.type) {
      case MeetingFormatActionType.noop:
        return;
      case MeetingFormatActionType.error:
        _setFailure(decision.failure!, 'meeting');
        return;
      case MeetingFormatActionType.requestRevote:
        final revoteFormats = decision.formats!;
        _setRoomActionLoading(true);
        final result = await _dateAssistant.requestMeetingRevote(
          roomId: roomId,
          userId: uid,
          formats: revoteFormats,
        );
        _setRoomActionLoading(false);
        final failure = _meetingInteraction.mapInteractionFailure(result);
        if (failure != null) {
          _setFailure(failure, 'meeting');
          return;
        }
        _clearFailure();
        return;
      case MeetingFormatActionType.selectFormats:
        final selectedFormats = decision.formats!;
        _setRoomActionLoading(true);
        final result = await _dateAssistant.selectMeetingFormats(
          roomId: roomId,
          userId: uid,
          formats: selectedFormats,
        );
        _setRoomActionLoading(false);
        final failure = _meetingInteraction.mapInteractionFailure(result);
        if (failure != null) {
          _setFailure(failure, 'meeting');
          return;
        }
        _meetingPlanner.resetOnPointsChanged();
        state = _meetingInteraction.onMeetingFormatsSubmitted(
          state,
          formats: selectedFormats,
        );
        return;
      case MeetingFormatActionType.confirmFormat:
        return;
    }
  }

  void confirmMeetingFormat(MeetingFormat format) {
    unawaited(_confirmMeetingFormatInternal(format));
  }

  Future<void> _confirmMeetingFormatInternal(MeetingFormat format) async {
    if (!_ensureSessionActive('meeting')) return;
    final roomId = state.roomId;
    final uid = _requireUserId('meeting');
    if (roomId == null || uid == null) return;
    final decision = _meetingFormatActions.resolveConfirmFormatAction(
      state: state,
      format: format,
    );
    switch (decision.type) {
      case MeetingFormatActionType.noop:
        return;
      case MeetingFormatActionType.error:
        _setFailure(decision.failure!, 'meeting');
        return;
      case MeetingFormatActionType.requestRevote:
        final revoteFormats = decision.formats!;
        _setRoomActionLoading(true);
        final revoteResult = await _dateAssistant.requestMeetingRevote(
          roomId: roomId,
          userId: uid,
          formats: revoteFormats,
        );
        _setRoomActionLoading(false);
        final revoteFailure = _meetingInteraction.mapInteractionFailure(
          revoteResult,
        );
        if (revoteFailure != null) {
          _setFailure(revoteFailure, 'meeting');
        } else {
          _clearFailure();
        }
        return;
      case MeetingFormatActionType.confirmFormat:
        final confirmedFormat = decision.format!;
        _setRoomActionLoading(true);
        final result = await _dateAssistant.confirmMeetingFormat(
          roomId: roomId,
          userId: uid,
          format: confirmedFormat,
        );
        _setRoomActionLoading(false);
        final failure = _meetingInteraction.mapInteractionFailure(result);
        if (failure != null) {
          _setFailure(failure, 'meeting');
          return;
        }
        state = _meetingInteraction.onMeetingFormatConfirmed(
          state,
          format: confirmedFormat,
        );
        return;
      case MeetingFormatActionType.selectFormats:
        return;
    }
  }

  Future<void> applyPartnerRadiusSuggestion() async {
    if (!_ensureSessionActive('meeting')) return;
    final suggestedRadius = _meetingCollaborationActions
        .resolvePartnerSuggestedRadius(state);
    if (suggestedRadius == null) return;
    state = state.copyWith(searchRadius: suggestedRadius);
    await recalculateForRadius();
  }

  void respondMeetingRevote(MeetingRevoteResponseDecision decision) {
    unawaited(_respondMeetingRevoteInternal(decision));
  }

  Future<void> _respondMeetingRevoteInternal(
    MeetingRevoteResponseDecision decision,
  ) async {
    if (!_ensureSessionActive('meeting')) return;
    final roomId = state.roomId;
    final uid = _requireUserId('meeting');
    if (roomId == null || uid == null) return;
    if (!_meetingCollaborationActions.canRespondToMeetingRevote(state)) return;
    _setRoomActionLoading(true);
    final result = await _dateAssistant.respondMeetingRevote(
      roomId: roomId,
      userId: uid,
      decision: decision,
    );
    _setRoomActionLoading(false);
    final failure = _meetingInteraction.mapInteractionFailure(result);
    if (failure != null) {
      _setFailure(failure, 'meeting');
      return;
    }
    _clearFailure();
  }

  void applyPartnerMeetingFormatSuggestion() {
    if (!_ensureSessionActive('meeting')) return;
    final merged = _meetingCollaborationActions.resolveMergedFormatsFromPartner(
      state,
    );
    if (merged == null) return;
    setMeetingFormats(merged);
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
      onData: (addresses) => state = state.copyWith(recentAddresses: addresses),
    );
  }

  void _subscribeToRoom(String code) {
    _roomStreamSubscription.bind(
      roomId: code,
      currentState: () => state,
      userId: userId,
      meetingPlanner: _meetingPlanner,
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
      _syncScenarioForFinalChoice();
    }
    if (application.snapshotRadiusToSync != null) {
      _meetingPlanner.syncFetchedRadiusFromSnapshot(
        application.snapshotRadiusToSync,
      );
    }
    if (application.shouldResetPlannerOnPointsChanged) {
      _meetingPlanner.resetOnPointsChanged();
    }
    if (application.shouldStopCalculating) {
      state = state.copyWith(isCalculatingMeeting: false);
    }
    if (application.shouldCalculateWithPartnerFallback &&
        application.fallbackPoint1 != null &&
        application.fallbackPoint2 != null) {
      unawaited(
        _calculateMeetingFallbackForPartner(
          point1: application.fallbackPoint1!,
          point2: application.fallbackPoint2!,
        ),
      );
    }
  }

  Future<void> _calculateMeetingFallbackForPartner({
    required latlong.LatLng point1,
    required latlong.LatLng point2,
  }) async {
    if (!_partnerFallback.canRun(
      state: state,
      isPartnerFallbackInFlight: _meetingPlanner.isPartnerFallbackInFlight,
    )) {
      return;
    }
    final request = _partnerFallbackRequest.build(
      state: state,
      point1: point1,
      point2: point2,
    );
    if (request == null) return;
    final req = _meetingPlanner.nextMeetingRequest();
    _setMeetingLoading(true);
    _clearFailure();
    await _meetingPlanner.runPartnerFallbackTask(() async {
      try {
        final res = await _meetingExecution.calculateMeeting(
          searchRadius: request.searchRadius,
          point1: request.point1,
          point2: request.point2,
          format: request.format,
          trackAnalytics: false,
        );
        if (_meetingPlanner.isStaleRequest(req)) return;
        switch (res) {
          case Err(:final failure):
            _handlePartnerFallbackDomainFailure(failure);
          case Ok(value: final meeting):
            _handlePartnerFallbackSuccess(
              meeting: meeting,
              point1: point1,
              point2: point2,
            );
        }
      } catch (e, stack) {
        AppLogger.e('Partner fallback meeting failed', e, stack);
        if (_meetingPlanner.isStaleRequest(req)) return;
        _handlePartnerFallbackUnexpectedFailure();
      }
    });
  }

  void _handlePartnerFallbackDomainFailure(Failure failure) {
    final fallbackFailure = _partnerFallbackResult.resolveDomainFailure(
      failure,
    );
    if (fallbackFailure.shouldStopLoading) {
      _setMeetingLoading(false);
    }
    _setFailure(fallbackFailure.failure, 'meeting');
  }

  void _handlePartnerFallbackSuccess({
    required MeetingPoint meeting,
    required latlong.LatLng point1,
    required latlong.LatLng point2,
  }) {
    final effects = _partnerFallbackEffects.buildSuccess(
      state: state,
      meeting: meeting,
      point1: point1,
      point2: point2,
      meetingPlanner: _meetingPlanner,
      resultCoordinator: _partnerFallbackResult,
    );
    final success = effects.success;
    state = success.nextState;
    if (effects.shouldMarkFetchedRadius && effects.fetchedRadius != null) {
      _meetingPlanner.markFetchedRadius(effects.fetchedRadius!);
    }
    if (success.shouldClearFailure) {
      _clearFailure();
    }
    if (success.shouldSaveSnapshot) {
      _meetingExecution.saveSnapshot(
        roomId: success.snapshotRoomId!,
        centerPoint: meeting.location,
        routePoints: meeting.fullRouteGeometry,
        places: meeting.nearbyPlaces,
        searchRadius: state.meeting.searchRadius.round(),
        meetingFormat: state.selectedMeetingFormat!,
      );
    }
  }

  void _handlePartnerFallbackUnexpectedFailure() {
    final fallbackFailure = _partnerFallbackResult.resolveUnexpectedFailure();
    if (fallbackFailure.shouldStopLoading) {
      _setMeetingLoading(false);
    }
    _setFailure(fallbackFailure.failure, 'meeting');
  }

  double scorePlace(Place place) => _meetingPlanner.scorePlace(
    place,
    point1: state.point1,
    point2: state.point2,
    meetingFormat: state.selectedMeetingFormat,
  );

  void _syncScenarioForFinalChoice() {
    final result = _finalChoiceScenarioSync.resolve(
      state: state,
      dateAssistant: _dateAssistant,
      meetingState: _meetingState,
    );
    if (!result.hasChanges) return;
    state = result.nextState!;
    unawaited(
      _analytics.planGenerated(
        format: result.analyticsFormatWireValue!,
        stepsCount: result.stepsCount ?? 0,
      ),
    );
  }

  Future<void> _persistMySearchRadius() async {
    final command = _searchRadiusPersistence.buildCommand(state);
    final uid = _requireUserId('meeting');
    if (command == null || uid == null) return;
    final result = await _saveSearchRadius(
      roomId: command.roomId,
      userId: uid,
      radius: command.radius,
    );
    if (result case Err(:final failure)) {
      _setFailure(failure, 'meeting');
    }
  }
}
