import 'package:date_navigation/features/date_navigation/domain/entities/room_snapshot.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/room_status.dart';
import 'package:date_navigation/features/date_navigation/presentation/runtime/meeting_planner_runtime.dart';
import 'package:date_navigation/features/date_navigation/presentation/sync/room_snapshot_reducer.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

void main() {
  const coordinator = RoomSnapshotReducer();
  final planner = MeetingPlannerRuntime();

  RoomSnapshot snapshot({
    String creatorUid = 'creator-1',
    latlong.LatLng? point1,
    latlong.LatLng? point2,
    RoomFinalChoiceSnapshot finalChoice = const RoomFinalChoiceSnapshot(),
    RoomProposalSnapshot proposal = const RoomProposalSnapshot(),
    Map<String, String> votes = const {},
    int? creatorSearchRadius,
    int? partnerSearchRadius,
    DateTime? creatorSearchRadiusUpdatedAt,
    DateTime? partnerSearchRadiusUpdatedAt,
    List<MeetingFormat> creatorMeetingFormats = const [],
    List<MeetingFormat> partnerMeetingFormats = const [],
    MeetingFormat? creatorSelectedMeetingFormat,
    MeetingFormat? partnerSelectedMeetingFormat,
  }) {
    return RoomSnapshot(
      id: 'room-1',
      creatorUid: creatorUid,
      point1: point1,
      point2: point2,
      finalChoice: finalChoice,
      proposal: proposal,
      votes: votes,
      creatorSearchRadius: creatorSearchRadius,
      partnerSearchRadius: partnerSearchRadius,
      creatorSearchRadiusUpdatedAt: creatorSearchRadiusUpdatedAt,
      partnerSearchRadiusUpdatedAt: partnerSearchRadiusUpdatedAt,
      creatorMeetingFormats: creatorMeetingFormats,
      partnerMeetingFormats: partnerMeetingFormats,
      creatorSelectedMeetingFormat: creatorSelectedMeetingFormat,
      partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
    );
  }

  test('buildOutcome marks venueLocked and resolves final place', () {
    final currentState = DateNavigationState(
      meeting: MeetingPlanningState(
        foundPlaces: const [],
        centerPoint: latlong.LatLng(53.9, 27.56),
      ),
    );

    final outcome = coordinator.buildOutcome(
      currentState: currentState,
      userId: 'creator-1',
      meetingPlanner: planner,
      roomSnapshot: snapshot(
        point1: const latlong.LatLng(53.9, 27.56),
        point2: const latlong.LatLng(53.91, 27.57),
        finalChoice: const RoomFinalChoiceSnapshot(
          name: 'Cafe X',
          lat: 53.905,
          lon: 27.565,
          address: 'Some street',
          type: 'cafe',
        ),
        proposal: const RoomProposalSnapshot(
          placeName: 'Cafe X',
          status: ProposalStatus.accepted,
        ),
        votes: const {'u1': 'Cafe X'},
      ),
    );

    expect(outcome.venueLocked, isTrue);
    expect(outcome.isCreator, isTrue);
    expect(outcome.nextState.meeting.finalChoiceName, 'Cafe X');
    expect(outcome.nextState.meeting.finalChoicePlace, isNotNull);
    expect(outcome.nextState.meeting.finalChoicePlace!.name, 'Cafe X');
  });

  test('buildOutcome detects pointsChanged', () {
    final currentState = DateNavigationState(
      room: RoomSessionState(
        point1: latlong.LatLng(1, 1),
        point2: latlong.LatLng(2, 2),
      ),
    );

    final outcome = coordinator.buildOutcome(
      currentState: currentState,
      userId: 'x',
      meetingPlanner: planner,
      roomSnapshot: snapshot(
        creatorUid: 'x',
        point1: const latlong.LatLng(1.0, 1.5),
        point2: const latlong.LatLng(2.0, 2.0),
      ),
    );

    expect(outcome.pointsChanged, isTrue);
  });

  test('buildOutcome suggests peer radius only if peer update is newer', () {
    final now = DateTime.now();
    const currentState = DateNavigationState(
      meeting: MeetingPlanningState(searchRadius: 500),
    );

    final outcome = coordinator.buildOutcome(
      currentState: currentState,
      userId: 'creator-1',
      meetingPlanner: planner,
      roomSnapshot: snapshot(
        creatorSearchRadius: 500,
        partnerSearchRadius: 900,
        creatorSearchRadiusUpdatedAt: now.subtract(const Duration(minutes: 2)),
        partnerSearchRadiusUpdatedAt: now,
      ),
    );

    expect(outcome.nextState.meeting.peerSuggestedRadius, 900);
  });

  test('buildOutcome does not create peer format suggestions', () {
    final currentState = const DateNavigationState();

    final outcome = coordinator.buildOutcome(
      currentState: currentState,
      userId: 'creator-1',
      meetingPlanner: planner,
      roomSnapshot: snapshot(
        creatorMeetingFormats: const [MeetingFormat.food],
        partnerMeetingFormats: const [MeetingFormat.culture],
      ),
    );

    expect(outcome.nextState.meeting.selectedMeetingFormat, isNull);
    expect(outcome.nextState.meeting.peerSuggestedMeetingFormat, isNull);
  });

  test(
    'buildOutcome does not suggest peer format when sets equal but order differs',
    () {
      final outcome = coordinator.buildOutcome(
        currentState: const DateNavigationState(),
        userId: 'creator-1',
        meetingPlanner: planner,
        roomSnapshot: snapshot(
          creatorMeetingFormats: const [
            MeetingFormat.food,
            MeetingFormat.culture,
          ],
          partnerMeetingFormats: const [
            MeetingFormat.culture,
            MeetingFormat.food,
          ],
        ),
      );

      expect(outcome.nextState.meeting.peerSuggestedMeetingFormat, isNull);
    },
  );

  test('buildOutcome resolves agreed format only when both confirmed same', () {
    final outcome = coordinator.buildOutcome(
      currentState: const DateNavigationState(),
      userId: 'creator-1',
      meetingPlanner: planner,
      roomSnapshot: snapshot(
        creatorMeetingFormats: const [
          MeetingFormat.food,
          MeetingFormat.culture,
        ],
        partnerMeetingFormats: const [
          MeetingFormat.culture,
          MeetingFormat.walkOnly,
        ],
        creatorSelectedMeetingFormat: MeetingFormat.culture,
        partnerSelectedMeetingFormat: MeetingFormat.culture,
      ),
    );

    expect(outcome.nextState.meeting.creatorMeetingFormats, [
      MeetingFormat.food,
      MeetingFormat.culture,
    ]);
    expect(outcome.nextState.meeting.partnerMeetingFormats, [
      MeetingFormat.culture,
      MeetingFormat.walkOnly,
    ]);
    expect(
      outcome.nextState.meeting.creatorSelectedMeetingFormat,
      MeetingFormat.culture,
    );
    expect(
      outcome.nextState.meeting.partnerSelectedMeetingFormat,
      MeetingFormat.culture,
    );
    expect(outcome.nextState.meeting.commonMeetingFormats, [
      MeetingFormat.culture,
    ]);
    expect(
      outcome.nextState.meeting.selectedMeetingFormat,
      MeetingFormat.culture,
    );
  });
}
