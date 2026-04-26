import '../../domain/entities/account_favorite.dart';
import '../../domain/entities/account_history_item.dart';

class AccountState {
  final bool isLoading;
  final List<AccountFavorite> favorites;
  final List<AccountHistoryItem> history;
  final String? error;

  const AccountState({
    this.isLoading = true,
    this.favorites = const [],
    this.history = const [],
    this.error,
  });

  AccountState copyWith({
    bool? isLoading,
    List<AccountFavorite>? favorites,
    List<AccountHistoryItem>? history,
    Object? error = _unset,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
      history: history ?? this.history,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}

const _unset = Object();
