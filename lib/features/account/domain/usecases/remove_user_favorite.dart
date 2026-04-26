import '../entities/account_favorite.dart';
import '../repositories/account_repository.dart';

class RemoveUserFavorite {
  final AccountRepository _repo;
  const RemoveUserFavorite(this._repo);

  Future<void> call({
    required String userId,
    required AccountFavorite favorite,
  }) {
    return _repo.removeFavorite(userId: userId, favorite: favorite);
  }
}
