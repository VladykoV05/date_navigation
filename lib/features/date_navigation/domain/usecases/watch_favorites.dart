import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/user_favorites_repository.dart';

class WatchFavorites {
  final UserFavoritesRepository _repo;
  const WatchFavorites(this._repo);

  Stream<QuerySnapshot<Map<String, dynamic>>> call({
    required String userId,
    int limit = 100,
  }) {
    return _repo.watchFavorites(userId: userId, limit: limit);
  }
}
