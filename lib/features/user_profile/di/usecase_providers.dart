import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/usecases/remember_user_address.dart';
import '../domain/usecases/record_meeting_history.dart';
import '../domain/usecases/remove_user_favorite.dart';
import '../domain/usecases/upsert_user_favorite.dart';
import '../domain/usecases/watch_remembered_addresses.dart';
import '../domain/usecases/watch_user_favorites.dart';
import '../domain/usecases/watch_user_history.dart';
import 'repository_providers.dart';

part 'usecase_providers.g.dart';

@Riverpod(keepAlive: true)
WatchUserFavorites profileWatchUserFavorites(Ref ref) {
  return WatchUserFavorites(ref.watch(favoritesRepositoryProvider));
}

@Riverpod(keepAlive: true)
WatchUserHistory profileWatchUserHistory(Ref ref) {
  return WatchUserHistory(ref.watch(meetingHistoryRepositoryProvider));
}

@Riverpod(keepAlive: true)
WatchRememberedAddresses profileWatchRememberedAddresses(Ref ref) {
  return WatchRememberedAddresses(ref.watch(addressMemoryRepositoryProvider));
}

@Riverpod(keepAlive: true)
UpsertUserFavorite profileUpsertUserFavorite(Ref ref) {
  return UpsertUserFavorite(ref.watch(favoritesRepositoryProvider));
}

@Riverpod(keepAlive: true)
RemoveUserFavorite profileRemoveUserFavorite(Ref ref) {
  return RemoveUserFavorite(ref.watch(favoritesRepositoryProvider));
}

@Riverpod(keepAlive: true)
RemoveUserFavoriteByPlace profileRemoveUserFavoriteByPlace(Ref ref) {
  return RemoveUserFavoriteByPlace(ref.watch(favoritesRepositoryProvider));
}

@Riverpod(keepAlive: true)
RememberUserAddress profileRememberUserAddress(Ref ref) {
  return RememberUserAddress(ref.watch(addressMemoryRepositoryProvider));
}

@Riverpod(keepAlive: true)
RemoveRememberedUserAddress profileRemoveRememberedUserAddress(Ref ref) {
  return RemoveRememberedUserAddress(
    ref.watch(addressMemoryRepositoryProvider),
  );
}

@Riverpod(keepAlive: true)
RecordMeetingHistory profileRecordMeetingHistory(Ref ref) {
  return RecordMeetingHistory(ref.watch(meetingHistoryRepositoryProvider));
}
