import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/auth_di.dart';
import '../../di/user_profile_providers.dart';
import '../controllers/favorites_controller.dart';
import '../state/favorites_state.dart';

final favoritesControllerProvider =
    StateNotifierProvider.autoDispose<FavoritesController, FavoritesState>(
      (ref) => FavoritesController(
        watchFavorites: ref.watch(profileWatchUserFavoritesProvider),
        upsertFavorite: ref.watch(profileUpsertUserFavoriteProvider),
        removeFavorite: ref.watch(profileRemoveUserFavoriteByPlaceProvider),
        authSession: ref.watch(authSessionProvider),
      ),
    );
