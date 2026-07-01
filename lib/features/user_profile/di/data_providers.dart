import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/firestore_di.dart';
import '../data/datasources/remote/user_address_memory_remote_data_source.dart';
import '../data/datasources/remote/user_favorites_remote_data_source.dart';
import '../data/datasources/remote/user_meeting_history_remote_data_source.dart';

part 'data_providers.g.dart';

@Riverpod(keepAlive: true)
UserFavoritesRemoteDataSource userFavoritesRemoteDataSource(Ref ref) {
  return UserFavoritesRemoteDataSource(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
UserAddressMemoryRemoteDataSource userAddressMemoryRemoteDataSource(Ref ref) {
  return UserAddressMemoryRemoteDataSource(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
UserMeetingHistoryRemoteDataSource userMeetingHistoryRemoteDataSource(Ref ref) {
  return UserMeetingHistoryRemoteDataSource(ref.watch(firestoreProvider));
}
