import 'package:date_navigation/features/date_navigation/domain/entities/room_snapshot.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/room_status.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/meeting_planner_coordinator.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/room_sync_coordinator.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

void main() {
  const coordinator = RoomSyncCoordinator();
  final planner = MeetingPlannerCoordinator();

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
      foundPlaces: const [],
      centerPoint: latlong.LatLng(53.9, 27.56),
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
    expect(outcome.nextState.finalChoiceName, 'Cafe X');
    expect(outcome.nextState.finalChoicePlace, isNotNull);
    expect(outcome.nextState.finalChoicePlace!.name, 'Cafe X');
  });

  test('buildOutcome detects pointsChanged', () {
    final currentState = DateNavigationState(
      point1: latlong.LatLng(1, 1),
      point2: latlong.LatLng(2, 2),
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
    final currentState = DateNavigationState(searchRadius: 500);

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

    expect(outcome.nextState.peerSuggestedRadius, 900);
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

    expect(outcome.nextState.selectedMeetingFormat, isNull);
    expect(outcome.nextState.peerSuggestedMeetingFormat, isNull);
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

      expect(outcome.nextState.peerSuggestedMeetingFormat, isNull);
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

    expect(outcome.nextState.creatorMeetingFormats, [
      MeetingFormat.food,
      MeetingFormat.culture,
    ]);
    expect(outcome.nextState.partnerMeetingFormats, [
      MeetingFormat.culture,
      MeetingFormat.walkOnly,
    ]);
    expect(
      outcome.nextState.creatorSelectedMeetingFormat,
      MeetingFormat.culture,
    );
    expect(
      outcome.nextState.partnerSelectedMeetingFormat,
      MeetingFormat.culture,
    );
    expect(outcome.nextState.commonMeetingFormats, [MeetingFormat.culture]);
    expect(outcome.nextState.selectedMeetingFormat, MeetingFormat.culture);
  });
}
