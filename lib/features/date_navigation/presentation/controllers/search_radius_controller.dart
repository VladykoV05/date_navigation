import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/usecases/save_search_radius.dart';
import '../actions/meeting_collaboration_actions.dart';
import '../flows/search_radius_persistence_builder.dart';
import '../policies/recalculate_policy.dart';
import '../runtime/meeting_planner_runtime.dart';
import '../state/date_navigation_state.dart';

typedef SearchRadiusStateReader = DateNavigationState Function();
typedef SearchRadiusStateWriter = void Function(DateNavigationState state);
typedef SearchRadiusGuard = bool Function(String operation);
typedef SearchRadiusUserIdRequirement = String? Function(String operation);
typedef SearchRadiusFailureWriter =
    void Function(Failure failure, String operation);

class SearchRadiusController {
  const SearchRadiusController({
    required MeetingPlannerRuntime meetingPlanner,
    required SaveSearchRadius saveSearchRadius,
    required SearchRadiusStateReader readState,
    required SearchRadiusStateWriter writeState,
    required SearchRadiusGuard ensureSessionActive,
    required SearchRadiusGuard ensureMeetingFormatMatched,
    required SearchRadiusUserIdRequirement requireUserId,
    required SearchRadiusFailureWriter setFailure,
    required void Function() clearFailure,
    required Future<void> Function() calculateMeeting,
    MeetingCollaborationActions meetingCollaborationActions =
        const MeetingCollaborationActions(),
    RecalculatePolicy recalculatePolicy = const RecalculatePolicy(),
    SearchRadiusPersistenceCommandBuilder searchRadiusPersistence =
        const SearchRadiusPersistenceCommandBuilder(),
  }) : _meetingPlanner = meetingPlanner,
       _saveSearchRadius = saveSearchRadius,
       _readState = readState,
       _writeState = writeState,
       _ensureSessionActive = ensureSessionActive,
       _ensureMeetingFormatMatched = ensureMeetingFormatMatched,
       _requireUserId = requireUserId,
       _setFailure = setFailure,
       _clearFailure = clearFailure,
       _calculateMeeting = calculateMeeting,
       _meetingCollaborationActions = meetingCollaborationActions,
       _recalculatePolicy = recalculatePolicy,
       _searchRadiusPersistence = searchRadiusPersistence;

  final MeetingPlannerRuntime _meetingPlanner;
  final SaveSearchRadius _saveSearchRadius;
  final SearchRadiusStateReader _readState;
  final SearchRadiusStateWriter _writeState;
  final SearchRadiusGuard _ensureSessionActive;
  final SearchRadiusGuard _ensureMeetingFormatMatched;
  final SearchRadiusUserIdRequirement _requireUserId;
  final SearchRadiusFailureWriter _setFailure;
  final void Function() _clearFailure;
  final Future<void> Function() _calculateMeeting;
  final MeetingCollaborationActions _meetingCollaborationActions;
  final RecalculatePolicy _recalculatePolicy;
  final SearchRadiusPersistenceCommandBuilder _searchRadiusPersistence;

  void setSearchRadius(double value) {
    if (!_ensureSessionActive('meeting')) return;
    final state = _readState();
    _writeState(
      state.copyWith(meeting: state.meeting.copyWith(searchRadius: value)),
    );
  }

  Future<void> recalculateForRadius() async {
    if (!_ensureSessionActive('meeting')) return;
    if (!_ensureMeetingFormatMatched('meeting')) return;
    await _persistMySearchRadius();
    var state = _readState();
    if (!_recalculatePolicy.canRecalculate(state)) return;
    final meeting = state.meeting;
    final center = meeting.centerPoint;
    final hasCenterAndPlaces = center != null && meeting.foundPlaces.isNotEmpty;
    if (hasCenterAndPlaces) {
      final filtered = _meetingPlanner.computeFilteredPlaces(
        places: meeting.foundPlaces,
        point1: state.room.point1,
        point2: state.room.point2,
        selectedType: meeting.selectedType,
        centerPoint: center,
        searchRadius: meeting.searchRadius,
        meetingFormat: state.meeting.selectedMeetingFormat,
      );
      _writeState(
        state.copyWith(
          meeting: state.meeting.copyWith(filteredPlaces: filtered),
          ui: state.ui.copyWith(isCalculatingMeeting: false),
        ),
      );
      _clearFailure();
      state = _readState();
      final shouldStop = _recalculatePolicy.shouldStopAfterLocalFilter(
        state: state,
        hasCenterAndPlaces: hasCenterAndPlaces,
        shouldSkipRadiusFetch: _meetingPlanner.shouldSkipRadiusFetch(
          state.meeting.searchRadius,
        ),
      );
      if (shouldStop) return;
    }
    await _calculateMeeting();
  }

  Future<void> applyPartnerRadiusSuggestion() async {
    if (!_ensureSessionActive('meeting')) return;
    final state = _readState();
    final suggestedRadius = _meetingCollaborationActions
        .resolvePartnerSuggestedRadius(state);
    if (suggestedRadius == null) return;
    _writeState(
      state.copyWith(
        meeting: state.meeting.copyWith(searchRadius: suggestedRadius),
      ),
    );
    await recalculateForRadius();
  }

  Future<void> _persistMySearchRadius() async {
    final command = _searchRadiusPersistence.buildCommand(_readState());
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
