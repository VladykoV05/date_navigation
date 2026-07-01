import 'package:flutter_riverpod/legacy.dart';

import '../../../core/di/auth_di.dart';
import '../../user_profile/user_profile.dart';
import '../presentation/controllers/account_controller.dart';
import '../presentation/state/account_state.dart';

final accountControllerProvider =
    StateNotifierProvider.autoDispose<AccountController, AccountState>(
      (ref) => AccountController(
        watchUserFavorites: ref.watch(profileWatchUserFavoritesProvider),
        watchUserHistory: ref.watch(profileWatchUserHistoryProvider),
        addUserFavorite: ref.watch(profileUpsertUserFavoriteProvider),
        removeUserFavorite: ref.watch(profileRemoveUserFavoriteProvider),
        authSession: ref.watch(authSessionProvider),
      ),
    );
