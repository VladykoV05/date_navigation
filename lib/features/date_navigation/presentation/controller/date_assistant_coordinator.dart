import 'dart:async';

import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../domain/usecases/build_date_scenarios.dart';
import '../../domain/usecases/save_date_vibe.dart';
import '../../domain/usecases/save_selected_scenario.dart';

class DateAssistantCoordinator {
  const DateAssistantCoordinator({
    required BuildDateScenarios buildDateScenarios,
    required SaveMeetingFormat saveMeetingFormat,
    required ConfirmMeetingFormat confirmMeetingFormat,
    required RequestMeetingRevote requestMeetingRevote,
    required RespondMeetingRevote respondMeetingRevote,
    required SaveSelectedScenario saveSelectedScenario,
    required AnalyticsService analytics,
  }) : _buildDateScenarios = buildDateScenarios,
       _saveMeetingFormat = saveMeetingFormat,
       _confirmMeetingFormat = confirmMeetingFormat,
       _requestMeetingRevote = requestMeetingRevote,
       _respondMeetingRevote = respondMeetingRevote,
       _saveSelectedScenario = saveSelectedScenario,
       _analytics = analytics;

  final BuildDateScenarios _buildDateScenarios;
  final SaveMeetingFormat _saveMeetingFormat;
  final ConfirmMeetingFormat _confirmMeetingFormat;
  final RequestMeetingRevote _requestMeetingRevote;
  final RespondMeetingRevote _respondMeetingRevote;
  final SaveSelectedScenario _saveSelectedScenario;
  final AnalyticsService _analytics;

  List<DateScenario> buildScenarios({
    required MeetingFormat format,
    required List<Place> places,
  }) {
    return _buildDateScenarios(format: format, places: places);
  }

  Future<Result<void>> selectMeetingFormats({
    required String roomId,
    required String userId,
    required Set<MeetingFormat> formats,
  }) async {
    final result = await _saveMeetingFormat(
      roomId: roomId,
      userId: userId,
      formats: formats,
    );
    if (result case Err(:final failure)) {
      unawaited(
        _analytics.operationFailed(
          operation: 'save_meeting_format',
          failureType: failure.runtimeType.toString(),
        ),
      );
      return Err(failure);
    }
    for (final format in formats) {
      unawaited(_analytics.meetingFormatSelected(format: format.wireValue));
    }
    return const Ok(null);
  }

  Future<Result<void>> confirmMeetingFormat({
    required String roomId,
    required String userId,
    required MeetingFormat format,
  }) async {
    final result = await _confirmMeetingFormat(
      roomId: roomId,
      userId: userId,
      format: format,
    );
    if (result case Err(:final failure)) {
      unawaited(
        _analytics.operationFailed(
          operation: 'confirm_meeting_format',
          failureType: failure.runtimeType.toString(),
        ),
      );
      return Err(failure);
    }
    return const Ok(null);
  }

  Future<Result<void>> requestMeetingRevote({
    required String roomId,
    required String userId,
    required Set<MeetingFormat> formats,
  }) async {
    final result = await _requestMeetingRevote(
      roomId: roomId,
      userId: userId,
      formats: formats,
    );
    if (result case Err(:final failure)) {
      unawaited(
        _analytics.operationFailed(
          operation: 'request_meeting_revote',
          failureType: failure.runtimeType.toString(),
        ),
      );
      return Err(failure);
    }
    return const Ok(null);
  }

  Future<Result<void>> respondMeetingRevote({
    required String roomId,
    required String userId,
    required MeetingRevoteResponseDecision decision,
  }) async {
    final result = await _respondMeetingRevote(
      roomId: roomId,
      userId: userId,
      decision: decision,
    );
    if (result case Err(:final failure)) {
      unawaited(
        _analytics.operationFailed(
          operation: 'respond_meeting_revote',
          failureType: failure.runtimeType.toString(),
        ),
      );
      return Err(failure);
    }
    return const Ok(null);
  }

  Future<Result<void>> selectScenario({
    required String roomId,
    required String userId,
    required DateScenario scenario,
  }) async {
    final result = await _saveSelectedScenario(
      roomId: roomId,
      scenario: scenario,
      selectedByUserId: userId,
    );
    if (result case Err(:final failure)) {
      unawaited(
        _analytics.operationFailed(
          operation: 'save_selected_scenario',
          failureType: failure.runtimeType.toString(),
        ),
      );
      return Err(failure);
    }
    return const Ok(null);
  }
}
