import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/controller/account_controller.dart';
import '../presentation/state/account_state.dart';
import 'infra_providers.dart';
import 'usecase_providers.dart';

final accountControllerProvider =
    StateNotifierProvider.autoDispose<AccountController, AccountState>(
      (ref) => AccountController(
        watchUserFavorites: ref.watch(watchUserFavoritesProvider),
        watchUserHistory: ref.watch(watchUserHistoryProvider),
        addUserFavorite: ref.watch(addUserFavoriteProvider),
        removeUserFavorite: ref.watch(removeUserFavoriteProvider),
        authSession: ref.watch(accountAuthSessionProvider),
      ),
    );
