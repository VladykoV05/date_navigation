import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/place.dart';
import '../state/date_navigation_state.dart';

class VoteForPlaceCommand {
  const VoteForPlaceCommand({
    required this.roomId,
    required this.userId,
    required this.placeName,
    required this.meetingFormatWireValue,
  });

  final String roomId;
  final String userId;
  final String placeName;
  final String? meetingFormatWireValue;
}

class SelectScenarioCommand {
  const SelectScenarioCommand({
    required this.roomId,
    required this.userId,
    required this.scenario,
  });

  final String roomId;
  final String userId;
  final DateScenario scenario;
}

class VoteScenarioActions {
  const VoteScenarioActions();

  VoteForPlaceCommand? buildVoteForPlaceCommand({
    required DateNavigationState state,
    required String userId,
    required Place place,
  }) {
    if (userId.isEmpty) return null;
    final roomId = state.room.roomId;
    if (roomId == null || roomId.isEmpty) return null;
    return VoteForPlaceCommand(
      roomId: roomId,
      userId: userId,
      placeName: place.name,
      meetingFormatWireValue: state.meeting.selectedMeetingFormat?.wireValue,
    );
  }

  SelectScenarioCommand? buildSelectScenarioCommand({
    required DateNavigationState state,
    required String userId,
    required DateScenario scenario,
  }) {
    if (userId.isEmpty) return null;
    final roomId = state.room.roomId;
    if (roomId == null || roomId.isEmpty) return null;
    return SelectScenarioCommand(
      roomId: roomId,
      userId: userId,
      scenario: scenario,
    );
  }
}
