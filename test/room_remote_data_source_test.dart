import 'package:flutter_test/flutter_test.dart';

import 'package:date_navigation/features/date_navigation/data/datasources/remote/room_remote_data_source.dart';

void main() {
  group('RoomRemoteDataSource.normalizeParticipants', () {
    test('returns unique non-empty ids', () {
      final result = RoomRemoteDataSource.normalizeParticipants(
        creatorUid: 'creator',
        partnerUid: 'partner',
        participants: const ['creator', 'partner', 'creator', ''],
        actedByUserId: 'partner',
      );

      expect(result.toSet(), {'creator', 'partner'});
    });
  });

  group('RoomRemoteDataSource.favoriteDocId', () {
    test('includes coordinates to avoid name collisions', () {
      final a = RoomRemoteDataSource.favoriteDocId(
        placeName: 'Love Coffee',
        lat: 53.90001,
        lon: 27.56667,
      );
      final b = RoomRemoteDataSource.favoriteDocId(
        placeName: 'Love Coffee',
        lat: 53.91001,
        lon: 27.57667,
      );

      expect(a, isNot(equals(b)));
    });
  });
}
