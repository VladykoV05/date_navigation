import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/meeting_planner_coordinator.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/room_document_mapper.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/room_sync_coordinator.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

void main() {
  final coordinator = RoomSyncCoordinator(const RoomDocumentMapper());
  final planner = MeetingPlannerCoordinator();

  test('buildOutcome marks venueLocked and resolves final place', () {
    final currentState = DateNavigationState(
      foundPlaces: const [],
      centerPoint: latlong.LatLng(53.9, 27.56),
    );

    final outcome = coordinator.buildOutcome(
      currentState: currentState,
      userId: 'creator-1',
      meetingPlanner: planner,
      roomData: {
        'creatorUid': 'creator-1',
        'point1': {'lat': 53.9, 'lng': 27.56},
        'point2': {'lat': 53.91, 'lng': 27.57},
        'finalChoice': 'Cafe X',
        'finalChoiceLat': 53.905,
        'finalChoiceLon': 27.565,
        'finalChoiceAddress': 'Some street',
        'finalChoiceType': 'cafe',
        'proposal': {'placeName': 'Cafe X', 'status': 'accepted'},
        'votes': {'u1': 'Cafe X'},
      },
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
      roomData: {
        'creatorUid': 'x',
        'point1': {'lat': 1.0, 'lng': 1.5},
        'point2': {'lat': 2.0, 'lng': 2.0},
        'proposal': {},
        'votes': {},
      },
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
      roomData: {
        'creatorUid': 'creator-1',
        'partnerUid': 'partner-1',
        'creatorSearchRadius': 500,
        'partnerSearchRadius': 900,
        'creatorSearchRadiusUpdatedAt': Timestamp.fromDate(
          now.subtract(const Duration(minutes: 2)),
        ),
        'partnerSearchRadiusUpdatedAt': Timestamp.fromDate(now),
        'proposal': {},
        'votes': {},
      },
    );

    expect(outcome.nextState.peerSuggestedRadius, 900);
  });

  test('buildOutcome does not create peer format suggestions', () {
    final now = DateTime.now();
    final currentState = const DateNavigationState();

    final outcome = coordinator.buildOutcome(
      currentState: currentState,
      userId: 'creator-1',
      meetingPlanner: planner,
      roomData: {
        'creatorUid': 'creator-1',
        'partnerUid': 'partner-1',
        'creatorMeetingFormat': 'food',
        'partnerMeetingFormat': 'culture',
        'creatorMeetingFormatUpdatedAt': Timestamp.fromDate(
          now.subtract(const Duration(minutes: 3)),
        ),
        'partnerMeetingFormatUpdatedAt': Timestamp.fromDate(now),
        'proposal': {},
        'votes': {},
      },
    );

    expect(outcome.nextState.selectedMeetingFormat, isNull);
    expect(outcome.nextState.peerSuggestedMeetingFormat, isNull);
  });

  test(
    'buildOutcome does not suggest peer format when sets equal but order differs',
    () {
      final now = DateTime.now();
      final outcome = coordinator.buildOutcome(
        currentState: const DateNavigationState(),
        userId: 'creator-1',
        meetingPlanner: planner,
        roomData: {
          'creatorUid': 'creator-1',
          'partnerUid': 'partner-1',
          'creatorMeetingFormats': ['food', 'culture'],
          'partnerMeetingFormats': ['culture', 'food'],
          'creatorMeetingFormatUpdatedAt': Timestamp.fromDate(
            now.subtract(const Duration(minutes: 1)),
          ),
          'partnerMeetingFormatUpdatedAt': Timestamp.fromDate(now),
          'proposal': {},
          'votes': {},
        },
      );

      expect(outcome.nextState.peerSuggestedMeetingFormat, isNull);
    },
  );

  test('buildOutcome resolves agreed format only when both confirmed same', () {
    final outcome = coordinator.buildOutcome(
      currentState: const DateNavigationState(),
      userId: 'creator-1',
      meetingPlanner: planner,
      roomData: {
        'creatorUid': 'creator-1',
        'partnerUid': 'partner-1',
        'creatorMeetingFormats': ['food', 'culture'],
        'partnerMeetingFormats': ['walk_only', 'culture'],
        'creatorSelectedMeetingFormat': 'culture',
        'partnerSelectedMeetingFormat': 'culture',
        'proposal': {},
        'votes': {},
      },
    );

    expect(outcome.nextState.creatorMeetingFormats, [
      MeetingFormat.food,
      MeetingFormat.culture,
    ]);
    expect(outcome.nextState.partnerMeetingFormats, [
      MeetingFormat.culture,
      MeetingFormat.walkOnly,
    ]);
    expect(outcome.nextState.creatorSelectedMeetingFormat, MeetingFormat.culture);
    expect(outcome.nextState.partnerSelectedMeetingFormat, MeetingFormat.culture);
    expect(outcome.nextState.commonMeetingFormats, [MeetingFormat.culture]);
    expect(outcome.nextState.selectedMeetingFormat, MeetingFormat.culture);
  });
}
