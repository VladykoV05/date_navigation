import '../domain/usecases/add_user_favorite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/remove_user_favorite.dart';
import '../domain/usecases/watch_user_favorites.dart';
import '../domain/usecases/watch_user_history.dart';
import 'repository_providers.dart';

final watchUserFavoritesProvider = Provider<WatchUserFavorites>(
  (ref) => WatchUserFavorites(ref.watch(accountRepositoryProvider)),
);

final watchUserHistoryProvider = Provider<WatchUserHistory>(
  (ref) => WatchUserHistory(ref.watch(accountRepositoryProvider)),
);

final removeUserFavoriteProvider = Provider<RemoveUserFavorite>(
  (ref) => RemoveUserFavorite(ref.watch(accountRepositoryProvider)),
);

final addUserFavoriteProvider = Provider<AddUserFavorite>(
  (ref) => AddUserFavorite(ref.watch(accountRepositoryProvider)),
);
