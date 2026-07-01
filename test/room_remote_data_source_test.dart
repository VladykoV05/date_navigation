import 'package:flutter_test/flutter_test.dart';

import 'package:date_navigation/features/date_navigation/data/datasources/remote/room_remote_data_source.dart';
import 'package:date_navigation/features/user_profile/data/datasources/remote/user_favorites_remote_data_source.dart';

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

  group('UserFavoritesRemoteDataSource.favoriteDocId', () {
    test('includes coordinates to avoid name collisions', () {
      final a = UserFavoritesRemoteDataSource.favoriteDocId(
        placeName: 'Love Coffee',
        lat: 53.90001,
        lon: 27.56667,
      );
      final b = UserFavoritesRemoteDataSource.favoriteDocId(
        placeName: 'Love Coffee',
        lat: 53.91001,
        lon: 27.57667,
      );

      expect(a, isNot(equals(b)));
    });
  });
}
