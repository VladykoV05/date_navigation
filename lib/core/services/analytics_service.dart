import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;
  const AnalyticsService(this._analytics);

  Future<void> roomCreated() => _analytics.logEvent(name: 'room_created');

  Future<void> roomJoined() => _analytics.logEvent(name: 'room_joined');

  Future<void> roomClosed({required String reason}) => _analytics.logEvent(
    name: 'room_closed',
    parameters: {'reason': reason},
  );

  Future<void> addressSubmitted() =>
      _analytics.logEvent(name: 'address_submitted');

  Future<void> meetingCalculated({required int placesCount}) =>
      _analytics.logEvent(
        name: 'meeting_calculated',
        parameters: {'places_count': placesCount},
      );

  Future<void> placeVoted() => _analytics.logEvent(name: 'place_voted');

  Future<void> placeProposed() => _analytics.logEvent(name: 'place_proposed');

  Future<void> meetingFormatSelected({required String format}) =>
      _analytics.logEvent(
        name: 'meeting_format_selected',
        parameters: {'format': format},
      );

  Future<void> meetingFormatMatched({required String format}) => _analytics.logEvent(
    name: 'meeting_format_matched',
    parameters: {'format': format},
  );

  Future<void> placeSelectedAfterFormat({
    required String format,
    required String action,
  }) => _analytics.logEvent(
    name: 'place_selected_after_format',
    parameters: {'format': format, 'action': action},
  );

  Future<void> planGenerated({required String format, required int stepsCount}) =>
      _analytics.logEvent(
        name: 'plan_generated',
        parameters: {'format': format, 'steps_count': stepsCount},
      );

  Future<void> proposalResponded({required bool accepted}) =>
      _analytics.logEvent(
        name: 'proposal_responded',
        parameters: {'accepted': accepted ? 1 : 0},
      );

  Future<void> operationFailed({
    required String operation,
    required String failureType,
  }) => _analytics.logEvent(
    name: 'operation_failed',
    parameters: {'operation': operation, 'failure_type': failureType},
  );
}
