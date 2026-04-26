import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_session.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/account_favorite.dart';
import '../../domain/entities/account_history_item.dart';
import '../../domain/usecases/add_user_favorite.dart';
import '../../domain/usecases/remove_user_favorite.dart';
import '../../domain/usecases/watch_user_favorites.dart';
import '../../domain/usecases/watch_user_history.dart';
import '../state/account_state.dart';

class AccountController extends StateNotifier<AccountState> {
  AccountController({
    required WatchUserFavorites watchUserFavorites,
    required WatchUserHistory watchUserHistory,
    required AddUserFavorite addUserFavorite,
    required RemoveUserFavorite removeUserFavorite,
    required AuthSession authSession,
  }) : _watchUserFavorites = watchUserFavorites,
       _watchUserHistory = watchUserHistory,
       _addUserFavorite = addUserFavorite,
       _removeUserFavorite = removeUserFavorite,
       _authSession = authSession,
       super(const AccountState()) {
    _bind();
  }

  final WatchUserFavorites _watchUserFavorites;
  final WatchUserHistory _watchUserHistory;
  final AddUserFavorite _addUserFavorite;
  final RemoveUserFavorite _removeUserFavorite;
  final AuthSession _authSession;

  StreamSubscription<List<AccountFavorite>>? _favoritesSub;
  StreamSubscription? _historySub;
  String? _favoritesError;
  String? _historyError;

  String get _userId => _authSession.currentUserId ?? '';

  void _bind() {
    if (_userId.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Пользователь не авторизован',
      );
      return;
    }

    _favoritesSub = _watchUserFavorites(_userId).listen(
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
        _favoritesError = 'Не удалось загрузить избранное';
        state = state.copyWith(
          isLoading: false,
          favorites: const [],
          error: _mergedError,
        );
      },
    );

    _historySub = _watchUserHistory(_userId).listen(
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
        _historyError = 'Не удалось загрузить историю';
        state = state.copyWith(
          isLoading: false,
          history: const [],
          error: _mergedError,
        );
      },
    );
  }

  String? get _mergedError => _favoritesError ?? _historyError;

  Future<void> removeFavorite(AccountFavorite favorite) async {
    if (_userId.isEmpty) return;
    try {
      await _removeUserFavorite(userId: _userId, favorite: favorite);
    } catch (e, s) {
      AppLogger.e('Account remove favorite failed', e, s);
      state = state.copyWith(error: 'Не удалось удалить из избранного');
    }
  }

  Future<void> addFavoriteFromHistory(AccountHistoryItem item) async {
    if (_userId.isEmpty) return;
    final normalizedName = item.placeName.trim();
    if (normalizedName.isEmpty) return;
    try {
      await _addUserFavorite(
        userId: _userId,
        placeName: normalizedName,
        placeAddress: item.placeAddress,
        placeType: item.placeType,
        lat: item.lat,
        lon: item.lon,
      );
    } catch (e, s) {
      AppLogger.e('Account add favorite from history failed', e, s);
      state = state.copyWith(error: 'Не удалось добавить в избранное');
    }
  }

  @override
  void dispose() {
    _favoritesSub?.cancel();
    _historySub?.cancel();
    super.dispose();
  }
}
