import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/auth_di.dart';
import '../../../user_profile/user_profile.dart';
import '../../application/adapters/user_profile_favorites_adapter.dart';
import '../../application/ports/favorites_port.dart';
import '../controllers/meeting_favorites_controller.dart';
import '../state/meeting_favorites_state.dart';

final favoritesPortProvider = Provider<FavoritesPort>(
  (ref) => UserProfileFavoritesAdapter(
    watchFavorites: ref.watch(profileWatchUserFavoritesProvider),
    upsertFavorite: ref.watch(profileUpsertUserFavoriteProvider),
    removeFavorite: ref.watch(profileRemoveUserFavoriteByPlaceProvider),
  ),
);

final meetingFavoritesControllerProvider =
    StateNotifierProvider.autoDispose<
      MeetingFavoritesController,
      MeetingFavoritesState
    >(
      (ref) => MeetingFavoritesController(
        favoritesPort: ref.watch(favoritesPortProvider),
        authSession: ref.watch(authSessionProvider),
      ),
    );
