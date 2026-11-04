import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/error/failure_codes.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../user_profile/user_profile.dart';
import '../state/account_state.dart';

class AccountController extends Notifier<AccountState> {
  StreamSubscription<List<UserFavorite>>? _favoritesSub;
  StreamSubscription? _historySub;
  String? _favoritesError;
  String? _historyError;

  String get _userId => ref.read(authSessionProvider).currentUserId ?? '';

  @override
  AccountState build() {
    ref.onDispose(() {
      _favoritesSub?.cancel();
      _historySub?.cancel();
    });

    if (_userId.isEmpty) {
      return const AccountState(
        isLoading: false,
        error: FailureCodes.userNotAuthenticated,
      );
    }

    _bindStreams();
    return const AccountState();
  }

  void _bindStreams() {
    final watchFavorites = ref.read(profileWatchUserFavoritesProvider);
    final watchHistory = ref.read(profileWatchUserHistoryProvider);

    _favoritesSub = watchFavorites(userId: _userId).listen(
      (favorites) {
        _favoritesError = null;
        state = state.copyWith(
          isLoading: false,
          favorites: favorites,
          error: _mergedError,
        );
      },
      onError: (Object e, StackTrace s) {
        AppLogger.e('Account favorites stream failed', e, s);
        _favoritesError = FailureCodes.favoritesLoadFailed;
        state = state.copyWith(
          isLoading: false,
          favorites: const [],
          error: _mergedError,
        );
      },
    );

    _historySub = watchHistory(userId: _userId).listen(
      (history) {
        _historyError = null;
        state = state.copyWith(
          isLoading: false,
          history: history,
          error: _mergedError,
        );
      },
      onError: (Object e, StackTrace s) {
        AppLogger.e('Account history stream failed', e, s);
        _historyError = FailureCodes.historyLoadFailed;
        state = state.copyWith(
          isLoading: false,
          history: const [],
          error: _mergedError,
        );
      },
    );
  }

  String? get _mergedError => _favoritesError ?? _historyError;

  Future<void> removeFavorite(UserFavorite favorite) async {
    if (_userId.isEmpty) return;
    final result = await ref.read(profileRemoveUserFavoriteProvider)(
      userId: _userId,
      favorite: favorite,
    );
    if (result case Err(:final failure)) {
      AppLogger.e('Account remove favorite failed', failure.message);
      state = state.copyWith(error: failure.message);
    }
  }

  Future<void> addFavoriteFromHistory(MeetingHistoryItem item) async {
    if (_userId.isEmpty) return;
    final normalizedName = item.placeName.trim();
    if (normalizedName.isEmpty) return;
    final result = await ref.read(profileUpsertUserFavoriteProvider)(
      userId: _userId,
      placeName: normalizedName,
      placeAddress: item.placeAddress,
      placeType: item.placeType,
      lat: item.lat,
      lon: item.lon,
    );
    if (result case Err(:final failure)) {
      AppLogger.e('Account add favorite from history failed', failure.message);
      state = state.copyWith(error: failure.message);
    }
  }
}

final accountControllerProvider =
    NotifierProvider.autoDispose<AccountController, AccountState>(
      AccountController.new,
    );
