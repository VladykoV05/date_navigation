import '../entities/user_favorite.dart';
import '../repositories/user_profile_repository.dart';

class WatchUserFavorites {
  const WatchUserFavorites(this._repo);

  final UserProfileRepository _repo;

  Stream<List<UserFavorite>> call({required String userId, int limit = 100}) {
    return _repo.watchFavorites(userId: userId, limit: limit);
  }
}
