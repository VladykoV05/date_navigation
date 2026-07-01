import 'package:date_navigation/features/date_navigation/data/mappers/room_snapshot_mapper.dart';
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
}
