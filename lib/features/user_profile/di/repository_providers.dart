import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/user_profile_repository_impl.dart';
import '../domain/repositories/user_profile_repository.dart';
import 'data_providers.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepositoryImpl(
    ref.watch(userProfileRemoteDataSourceProvider),
  );
}
