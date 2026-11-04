import 'package:date_navigation/features/date_navigation/application/state/date_navigation_state.dart';
import 'package:date_navigation/features/date_navigation/application/state_transitions/room_session_state_transitions.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/room_status.dart';
import 'package:date_navigation/features/date_navigation/domain/value_objects/geo_coordinate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const transitions = RoomSessionStateTransitions();

  test('afterLeaveRoom clears room, meeting, voting, and address memory', () {
    final previous = DateNavigationState(
      room: const RoomSessionState(
        roomId: 'room-1',
        inviteCode: '1234',
        isCreator: true,
        point1: GeoCoordinate(latitude: 53.9, longitude: 27.5),
        partnerJoined: true,
      ),
      meeting: const MeetingPlanningState(
        searchRadius: 800,
        isRoutingDegraded: true,
      ),
      addressMemory: const AddressMemoryState(
        recentAddresses: ['Zybitskaya 1'],
      ),
      ui: const DateNavigationUiState(isGeocoding: true),
    );

    final next = transitions.afterLeaveRoom(previous);

    expect(next.room.roomId, isNull);
    expect(next.room.inviteCode, isNull);
    expect(next.room.partnerJoined, isFalse);
    expect(next.meeting.isRoutingDegraded, isFalse);
    expect(next.addressMemory.recentAddresses, isEmpty);
    expect(next.ui.isGeocoding, isFalse);
  });

  test('afterCreateSuccess marks creator and stores invite', () {
    final next = transitions.afterCreateSuccess(
      const DateNavigationState(),
      roomId: 'r1',
      inviteCode: '4321',
    );

    expect(next.room.roomId, 'r1');
    expect(next.room.inviteCode, '4321');
    expect(next.room.isCreator, isTrue);
    expect(next.room.sessionStatus, SessionStatus.active);
  });
}
