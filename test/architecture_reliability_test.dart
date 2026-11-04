import 'package:date_navigation/features/date_navigation/application/state_transitions/room_session_state_transitions.dart';
import 'package:date_navigation/features/date_navigation/application/state/date_navigation_state.dart';
import 'package:date_navigation/features/date_navigation/data/mappers/date_scenario_mapper.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_scenario.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/scenario_step.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('afterLeaveRoom clears address memory', () {
    const transitions = RoomSessionStateTransitions();
    final previous = DateNavigationState(
      addressMemory: const AddressMemoryState(recentAddresses: ['Zybitskaya']),
    );

    final next = transitions.afterLeaveRoom(previous);

    expect(next.addressMemory.recentAddresses, isEmpty);
    expect(next.room.roomId, isNull);
  });

  test('DateScenarioMapper round-trips scenario', () {
    const scenario = DateScenario(
      id: 's1',
      meetingFormat: MeetingFormat.food,
      title: 'Coffee',
      description: 'Short walk and coffee',
      totalDurationMinutes: 90,
      steps: [
        ScenarioStep(
          title: 'Meet',
          description: 'At the cafe',
          etaMinutes: 15,
          placeName: 'Central Cafe',
        ),
      ],
    );

    final mapped = DateScenarioMapper.fromFirestore(
      DateScenarioMapper.toFirestore(scenario),
    );

    expect(mapped.id, scenario.id);
    expect(mapped.title, scenario.title);
    expect(mapped.meetingFormat, scenario.meetingFormat);
    expect(mapped.steps, hasLength(1));
    expect(mapped.steps.first.placeName, 'Central Cafe');
  });
}
