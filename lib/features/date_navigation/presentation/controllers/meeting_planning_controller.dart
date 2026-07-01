import 'dart:async';

import '../../domain/value_objects/geo_coordinate.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/meeting_point.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../domain/usecases/save_search_radius.dart';
import '../../application/services/date_assistant_service.dart';
import '../../application/services/meeting_execution_service.dart';
import '../../application/flows/final_choice_scenario_sync_flow.dart';
import '../../application/flows/partner_fallback_flow.dart';
import '../../application/flows/partner_fallback_effects.dart';
import '../../application/flows/partner_fallback_request_builder.dart';
import '../../application/flows/partner_fallback_result_resolver.dart';
import './meeting_format_controller.dart';
import './search_radius_controller.dart';
import '../../application/runtime/meeting_planner_runtime.dart';
import '../../application/state_transitions/meeting_state_transitions.dart';
import '../../application/state/date_navigation_state.dart';

typedef MeetingStateReader = DateNavigationState Function();
typedef MeetingStateWriter = void Function(DateNavigationState state);
typedef MeetingGuard = bool Function(String operation);
typedef MeetingUserIdRequirement = String? Function(String operation);
typedef MeetingFailureWriter = void Function(Failure failure, String operation);

class MeetingPlanningController {
  MeetingPlanningController({
    required DateAssistantService dateAssistant,
    required MeetingExecutionService meetingExecution,
    required SaveSearchRadius saveSearchRadius,
    required AnalyticsService analytics,
    required MeetingStateReader readState,
    required MeetingStateWriter writeState,
    required MeetingGuard ensureSessionActive,
    required MeetingGuard ensureMeetingFormatMatched,
    required MeetingUserIdRequirement requireUserId,
    required MeetingFailureWriter setFailure,
    required void Function() clearFailure,
    required void Function(bool value) setRoomActionLoading,
    required void Function(bool value) setMeetingLoading,
  }) : _dateAssistant = dateAssistant,
       _meetingExecution = meetingExecution,
       _saveSearchRadius = saveSearchRadius,
       _analytics = analytics,
       _readState = readState,
       _writeState = writeState,
       _ensureSessionActive = ensureSessionActive,
       _ensureMeetingFormatMatched = ensureMeetingFormatMatched,
       _requireUserId = requireUserId,
       _setFailure = setFailure,
       _clearFailure = clearFailure,
       _setRoomActionLoading = setRoomActionLoading,
       _setMeetingLoading = setMeetingLoading;

  final DateAssistantService _dateAssistant;
  final MeetingExecutionService _meetingExecution;
  final SaveSearchRadius _saveSearchRadius;
  final AnalyticsService _analytics;
  final MeetingStateReader _readState;
  final MeetingStateWriter _writeState;
  final MeetingGuard _ensureSessionActive;
  final MeetingGuard _ensureMeetingFormatMatched;
  final MeetingUserIdRequirement _requireUserId;
  final MeetingFailureWriter _setFailure;
  final void Function() _clearFailure;
  final void Function(bool value) _setRoomActionLoading;
  final void Function(bool value) _setMeetingLoading;

  final MeetingPlannerRuntime meetingPlanner = MeetingPlannerRuntime();
  late final MeetingFormatController _meetingFormatController =
      MeetingFormatController(
        dateAssistant: _dateAssistant,
        meetingPlanner: meetingPlanner,
        readState: _readState,
        writeState: _writeState,
        ensureSessionActive: _ensureSessionActive,
        requireUserId: _requireUserId,
        setFailure: _setFailure,
        clearFailure: _clearFailure,
        setRoomActionLoading: _setRoomActionLoading,
      );
  late final SearchRadiusController _searchRadiusController =
      SearchRadiusController(
        meetingPlanner: meetingPlanner,
        saveSearchRadius: _saveSearchRadius,
        readState: _readState,
        writeState: _writeState,
        ensureSessionActive: _ensureSessionActive,
        ensureMeetingFormatMatched: _ensureMeetingFormatMatched,
        requireUserId: _requireUserId,
        setFailure: _setFailure,
        clearFailure: _clearFailure,
        calculateMeeting: calculateMeeting,
      );
  final MeetingStateTransitions _meetingState = const MeetingStateTransitions();
  final PartnerFallbackFlow _partnerFallback = const PartnerFallbackFlow();
  final PartnerFallbackRequestBuilder _partnerFallbackRequest =
      const PartnerFallbackRequestBuilder();
  final PartnerFallbackEffects _partnerFallbackEffects =
      const PartnerFallbackEffects();
  late final PartnerFallbackResultResolver _partnerFallbackResult =
      PartnerFallbackResultResolver(_partnerFallback);
  final FinalChoiceScenarioSyncFlow _finalChoiceScenarioSync =
      const FinalChoiceScenarioSyncFlow();

  void setSelectedType(String? type) {
    if (!_ensureSessionActive('meeting')) return;
    final state = _readState();
    final filtered = meetingPlanner.computeFilteredPlaces(
      places: state.meeting.foundPlaces,
      point1: state.room.point1,
      point2: state.room.point2,
      selectedType: type,
      centerPoint: state.meeting.centerPoint,
      searchRadius: state.meeting.searchRadius,
      meetingFormat: state.meeting.selectedMeetingFormat,
    );
    _writeState(
      state.copyWith(
        meeting: state.meeting.copyWith(
          selectedType: type,
          filteredPlaces: filtered,
        ),
      ),
    );
  }

  void setSearchRadius(double value) {
    _searchRadiusController.setSearchRadius(value);
  }

  Future<void> recalculateForRadius() async {
    await _searchRadiusController.recalculateForRadius();
  }

  Future<void> calculateMeeting() async {
    final initialState = _readState();
    if (!_ensureSessionActive('meeting')) return;
    if (initialState.meeting.selectedMeetingFormat == null) return;
    if (meetingPlanner.isMeetingInFlight) {
      meetingPlanner.requestMeetingRecalculate();
      return;
    }
    final roomSession = initialState.room;
    final meetingState = initialState.meeting;
    if (meetingState.finalChoiceName != null &&
        meetingState.finalChoiceName!.isNotEmpty) {
      return;
    }
    final point1 = roomSession.point1;
    final point2 = roomSession.point2;
    if (point1 == null || point2 == null) return;

    final req = meetingPlanner.nextMeetingRequest();
    final format = meetingState.selectedMeetingFormat!;
    final meetingKey = meetingPlanner.buildMeetingKey(
      point1: point1,
      point2: point2,
      searchRadius: meetingState.searchRadius.round(),
      format: format,
    );
    if (meetingPlanner.canReuseMeetingResult(
      meetingKey: meetingKey,
      hasCenterPoint: meetingState.centerPoint != null,
    )) {
      return;
    }

    _setMeetingLoading(true);
    _clearFailure();
    await meetingPlanner.runMeetingTask(() async {
      try {
        final currentState = _readState();
        final res = await _meetingExecution.calculateMeeting(
          searchRadius: currentState.meeting.searchRadius.round(),
          point1: point1,
          point2: point2,
          format: format,
          trackAnalytics: true,
        );
        if (meetingPlanner.isStaleRequest(req)) return;
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
            _handleMeetingSuccess(
              req: req,
              meetingKey: meetingKey,
              meeting: meeting,
              point1: point1,
              point2: point2,
              format: format,
            );
        }
      } catch (e, stack) {
        AppLogger.e('Calculate meeting failed', e, stack);
        if (meetingPlanner.isStaleRequest(req)) return;
        _setMeetingLoading(false);
        _setFailure(
          const UnknownFailure('Не удалось рассчитать точку встречи'),
          'meeting',
        );
      }
    });
    if (meetingPlanner.consumeMeetingRecalculateRequest()) {
      unawaited(calculateMeeting());
    }
  }

  void _handleMeetingSuccess({
    required int req,
    required String meetingKey,
    required MeetingPoint meeting,
    required GeoCoordinate point1,
    required GeoCoordinate point2,
    required MeetingFormat format,
  }) {
    var state = _readState();
    final filtered = meetingPlanner.computeFilteredPlaces(
      places: meeting.nearbyPlaces,
      point1: point1,
      point2: point2,
      selectedType: state.meeting.selectedType,
      centerPoint: meeting.location,
      searchRadius: state.meeting.searchRadius,
      meetingFormat: state.meeting.selectedMeetingFormat,
    );
    if (meetingPlanner.isStaleRequest(req)) return;
    if (_meetingState.isVenueLocked(state)) {
      _writeState(
        state.copyWith(ui: state.ui.copyWith(isCalculatingMeeting: false)),
      );
      return;
    }
    meetingPlanner.markMeetingCalculated(
      meetingKey: meetingKey,
      fetchedRadius: state.meeting.searchRadius.round(),
    );
    _writeState(
      _meetingState.applyMeetingSuccess(
        state: state,
        meeting: meeting,
        filteredPlaces: filtered,
      ),
    );
    _clearFailure();
    state = _readState();
    if (state.room.roomId != null && state.room.isCreator) {
      _meetingExecution.saveSnapshot(
        roomId: state.room.roomId!,
        centerPoint: meeting.location,
        routePoints: meeting.fullRouteGeometry,
        places: meeting.nearbyPlaces,
        searchRadius: state.meeting.searchRadius.round(),
        meetingFormat: format,
      );
    }
  }

  void setMeetingFormats(Set<MeetingFormat> formats) {
    _meetingFormatController.setMeetingFormats(formats);
  }

  void confirmMeetingFormat(MeetingFormat format) {
    _meetingFormatController.confirmMeetingFormat(format);
  }

  Future<void> applyPartnerRadiusSuggestion() async {
    await _searchRadiusController.applyPartnerRadiusSuggestion();
  }

  void respondMeetingRevote(MeetingRevoteResponseDecision decision) {
    _meetingFormatController.respondMeetingRevote(decision);
  }

  void applyPartnerMeetingFormatSuggestion() {
    _meetingFormatController.applyPartnerMeetingFormatSuggestion();
  }

  void stopCalculating() {
    final state = _readState();
    _writeState(
      state.copyWith(ui: state.ui.copyWith(isCalculatingMeeting: false)),
    );
  }

  Future<void> calculateMeetingFallbackForPartner({
    required GeoCoordinate point1,
    required GeoCoordinate point2,
  }) async {
    final state = _readState();
    if (!_partnerFallback.canRun(
      state: state,
      isPartnerFallbackInFlight: meetingPlanner.isPartnerFallbackInFlight,
    )) {
      return;
    }
    final request = _partnerFallbackRequest.build(
      state: state,
      point1: point1,
      point2: point2,
    );
    if (request == null) return;
    final req = meetingPlanner.nextMeetingRequest();
    _setMeetingLoading(true);
    _clearFailure();
    await meetingPlanner.runPartnerFallbackTask(() async {
      try {
        final res = await _meetingExecution.calculateMeeting(
          searchRadius: request.searchRadius,
          point1: request.point1,
          point2: request.point2,
          format: request.format,
          trackAnalytics: false,
        );
        if (meetingPlanner.isStaleRequest(req)) return;
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
        if (meetingPlanner.isStaleRequest(req)) return;
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
    required GeoCoordinate point1,
    required GeoCoordinate point2,
  }) {
    final effects = _partnerFallbackEffects.buildSuccess(
      state: _readState(),
      meeting: meeting,
      point1: point1,
      point2: point2,
      meetingPlanner: meetingPlanner,
      resultResolver: _partnerFallbackResult,
    );
    final success = effects.success;
    _writeState(success.nextState);
    if (effects.shouldMarkFetchedRadius && effects.fetchedRadius != null) {
      meetingPlanner.markFetchedRadius(effects.fetchedRadius!);
    }
    if (success.shouldClearFailure) {
      _clearFailure();
    }
    final state = _readState();
    if (success.shouldSaveSnapshot) {
      _meetingExecution.saveSnapshot(
        roomId: success.snapshotRoomId!,
        centerPoint: meeting.location,
        routePoints: meeting.fullRouteGeometry,
        places: meeting.nearbyPlaces,
        searchRadius: state.meeting.searchRadius.round(),
        meetingFormat: state.meeting.selectedMeetingFormat!,
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

  double scorePlace(Place place) {
    final state = _readState();
    return meetingPlanner.scorePlace(
      place,
      point1: state.room.point1,
      point2: state.room.point2,
      meetingFormat: state.meeting.selectedMeetingFormat,
    );
  }

  void syncScenarioForFinalChoice() {
    final result = _finalChoiceScenarioSync.resolve(
      state: _readState(),
      dateAssistant: _dateAssistant,
      meetingState: _meetingState,
    );
    if (!result.hasChanges) return;
    _writeState(result.nextState!);
    unawaited(
      _analytics.planGenerated(
        format: result.analyticsFormatWireValue!,
        stepsCount: result.stepsCount ?? 0,
      ),
    );
  }
}
