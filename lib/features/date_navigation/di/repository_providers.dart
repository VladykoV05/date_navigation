import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/geocoding_repository_impl.dart';
import '../data/repositories/meeting_history_repository_impl.dart';
import '../data/repositories/meeting_repository_impl.dart';
import '../data/repositories/meeting_snapshot_repository_impl.dart';
import '../data/repositories/room_session_repository_impl.dart';
import '../data/repositories/room_voting_repository_impl.dart';
import '../data/repositories/user_address_memory_repository_impl.dart';
import '../data/repositories/user_favorites_repository_impl.dart';
import '../domain/repositories/geocoding_repository.dart';
import '../domain/repositories/meeting_history_repository.dart';
import '../domain/repositories/meeting_repository.dart';
import '../domain/repositories/meeting_snapshot_repository.dart';
import '../domain/repositories/room_session_repository.dart';
import '../domain/repositories/room_voting_repository.dart';
import '../domain/repositories/user_address_memory_repository.dart';
import '../domain/repositories/user_favorites_repository.dart';
import 'data_providers.dart';

final roomSessionRepositoryProvider = Provider<RoomSessionRepository>(
  (ref) => RoomSessionRepositoryImpl(ref.watch(roomRemoteDataSourceProvider)),
);

final roomVotingRepositoryProvider = Provider<RoomVotingRepository>(
  (ref) => RoomVotingRepositoryImpl(ref.watch(roomRemoteDataSourceProvider)),
);

final userFavoritesRepositoryProvider = Provider<UserFavoritesRepository>(
  (ref) => UserFavoritesRepositoryImpl(ref.watch(roomRemoteDataSourceProvider)),
);

final userAddressMemoryRepositoryProvider = Provider<UserAddressMemoryRepository>(
  (ref) =>
      UserAddressMemoryRepositoryImpl(ref.watch(roomRemoteDataSourceProvider)),
);

final meetingSnapshotRepositoryProvider = Provider<MeetingSnapshotRepository>(
  (ref) => MeetingSnapshotRepositoryImpl(ref.watch(roomRemoteDataSourceProvider)),
);

final meetingHistoryRepositoryProvider = Provider<MeetingHistoryRepository>(
  (ref) => MeetingHistoryRepositoryImpl(ref.watch(roomRemoteDataSourceProvider)),
);

final geocodingRepositoryProvider = Provider<GeocodingRepository>((ref) {
  return GeocodingRepositoryImpl(ref.watch(geocodingRemoteDataSourceProvider));
});

final meetingRepositoryProvider = Provider<MeetingRepository>((ref) {
  return MeetingRepositoryImpl(
    ref.watch(osrmRemoteDataSourceProvider),
    ref.watch(placesRemoteDataSourceProvider),
  );
});
