import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/firestore_di.dart';
import '../data/datasources/remote/user_profile_remote_data_source.dart';

part 'data_providers.g.dart';

@Riverpod(keepAlive: true)
UserProfileRemoteDataSource userProfileRemoteDataSource(Ref ref) {
  return UserProfileRemoteDataSource(ref.watch(firestoreProvider));
}
