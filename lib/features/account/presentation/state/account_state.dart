import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/account_favorite.dart';
import '../../domain/entities/account_history_item.dart';

part 'account_state.freezed.dart';

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState({
    @Default(true) bool isLoading,
    @Default(<AccountFavorite>[]) List<AccountFavorite> favorites,
    @Default(<AccountHistoryItem>[]) List<AccountHistoryItem> history,
    String? error,
  }) = _AccountState;
}
