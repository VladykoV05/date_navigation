import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/address_memory_repository_impl.dart';
import '../data/repositories/favorites_repository_impl.dart';
import '../data/repositories/meeting_history_repository_impl.dart';
import '../data/repositories/user_profile_repository_impl.dart';
import '../domain/repositories/address_memory_repository.dart';
import '../domain/repositories/favorites_repository.dart';
import '../domain/repositories/meeting_history_repository.dart';
import '../domain/repositories/user_profile_repository.dart';
import 'data_providers.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(Ref ref) {
  return FavoritesRepositoryImpl(
    ref.watch(userFavoritesRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
AddressMemoryRepository addressMemoryRepository(Ref ref) {
  return AddressMemoryRepositoryImpl(
    ref.watch(userAddressMemoryRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
MeetingHistoryRepository meetingHistoryRepository(Ref ref) {
  return MeetingHistoryRepositoryImpl(
    ref.watch(userMeetingHistoryRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepositoryImpl(
    favorites: ref.watch(favoritesRepositoryProvider),
    meetingHistory: ref.watch(meetingHistoryRepositoryProvider),
    addressMemory: ref.watch(addressMemoryRepositoryProvider),
  );
}
