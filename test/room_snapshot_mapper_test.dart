import 'package:date_navigation/features/date_navigation/data/mappers/room_snapshot_mapper.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/room_snapshot.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/room_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = RoomSnapshotMapper();

  test('fromMap parses typed room statuses from wire values', () {
    final snapshot = mapper.fromMap('room-1', {
      'creatorUid': 'creator-1',
      'sessionStatus': 'completed',
      'proposal': {'placeName': 'Cafe X', 'status': 'accepted'},
      'meetingRevoteRequest': {'requestedBy': 'partner', 'status': 'pending'},
    });

    expect(snapshot.sessionStatus, SessionStatus.completed);
    expect(snapshot.proposal.status, ProposalStatus.accepted);
    expect(snapshot.meetingRevoteRequest.status, RevoteRequestStatus.pending);
  });

  test('fromMap falls back to active session and null optional statuses', () {
    final snapshot = mapper.fromMap('room-2', {
      'creatorUid': 'creator-1',
      'sessionStatus': 'unexpected',
      'proposal': {'status': 'unknown'},
      'meetingRevoteRequest': {'status': 'done'},
    });

    expect(snapshot.sessionStatus, SessionStatus.active);
    expect(snapshot.proposal.status, isNull);
    expect(snapshot.meetingRevoteRequest.status, isNull);
  });

  test('derives v1 participants from creator and partner fields', () {
    final snapshot = mapper.fromMap('room-3', {
      'creatorUid': 'creator-1',
      'partnerUid': 'partner-1',
      'point1': {'lat': 53.9, 'lng': 27.5},
      'point2': {'lat': 53.8, 'lng': 27.6},
    });

    expect(snapshot.schemaVersion, 1);
    expect(snapshot.type, RoomType.private);
    expect(snapshot.visibility, RoomVisibility.invite);
    expect(snapshot.capacity, 2);
    expect(snapshot.hostUid, 'creator-1');
    expect(snapshot.participants, hasLength(2));
    expect(snapshot.participants.first.role, RoomParticipantRole.host);
    expect(snapshot.participants.last.uid, 'partner-1');
  });

  test('parses v2 open room with participants and event', () {
    final snapshot = mapper.fromMap('room-4', {
      'schemaVersion': 2,
      'type': 'open',
      'visibility': 'public',
      'capacity': 4,
      'hostUid': 'creator-1',
      'creatorUid': 'creator-1',
      'participants': [
        {
          'uid': 'creator-1',
          'role': 'host',
          'point': {'lat': 53.9, 'lng': 27.5},
          'searchRadius': 500,
          'meetingFormats': ['food'],
        },
        {
          'uid': 'member-1',
          'role': 'member',
          'point': {'lat': 53.8, 'lng': 27.6},
          'searchRadius': 700,
        },
      ],
      'event': {
        'id': 'ticketpro-1',
        'title': 'Zoloto',
        'startsAt': null,
        'venueName': 'Дворец спорта',
        'address': 'пр-т Победителей, 4',
        'lat': 53.912589,
        'lon': 27.548675,
        'sourceUrl': 'https://ticketpro.by/ru/event/zoloto',
        'category': 'Концерты',
        'source': 'ticketpro',
      },
    });

    expect(snapshot.schemaVersion, 2);
    expect(snapshot.type, RoomType.open);
    expect(snapshot.isOpen, isTrue);
    expect(snapshot.visibility, RoomVisibility.public);
    expect(snapshot.capacity, 4);
    expect(snapshot.participants, hasLength(2));
    expect(snapshot.participants.last.searchRadius, 700);
    expect(snapshot.event?.title, 'Zoloto');
    expect(snapshot.event?.lat, 53.912589);
    expect(snapshot.event?.category, 'Концерты');
  });
}
