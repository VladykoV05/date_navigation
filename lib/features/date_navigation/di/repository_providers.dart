import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../user_profile/di/user_profile_providers.dart';
import '../data/repositories/geocoding_repository_impl.dart';
import '../data/repositories/meeting_repository_impl.dart';
import '../data/repositories/meeting_snapshot_repository_impl.dart';
import '../data/repositories/room_session_repository_impl.dart';
import '../data/repositories/room_voting_repository_impl.dart';
import '../domain/repositories/geocoding_repository.dart';
import '../domain/repositories/meeting_repository.dart';
import '../domain/repositories/meeting_snapshot_repository.dart';
import '../domain/repositories/room_session_repository.dart';
import '../domain/repositories/room_voting_repository.dart';
import 'data_providers.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
RoomSessionRepository roomSessionRepository(Ref ref) {
  return RoomSessionRepositoryImpl(ref.watch(roomRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
RoomVotingRepository roomVotingRepository(Ref ref) {
  return RoomVotingRepositoryImpl(
    ref.watch(roomRemoteDataSourceProvider),
    ref.watch(profileRecordMeetingHistoryProvider),
  );
}

@Riverpod(keepAlive: true)
MeetingSnapshotRepository meetingSnapshotRepository(Ref ref) {
  return MeetingSnapshotRepositoryImpl(ref.watch(roomRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
GeocodingRepository geocodingRepository(Ref ref) {
  return GeocodingRepositoryImpl(ref.watch(geocodingRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
MeetingRepository meetingRepository(Ref ref) {
  return MeetingRepositoryImpl(
    ref.watch(osrmRemoteDataSourceProvider),
    ref.watch(placesRemoteDataSourceProvider),
  );
}
