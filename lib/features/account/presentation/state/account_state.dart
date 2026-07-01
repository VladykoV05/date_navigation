import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../user_profile/user_profile.dart';

part 'account_state.freezed.dart';

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState({
    @Default(true) bool isLoading,
    @Default(<UserFavorite>[]) List<UserFavorite> favorites,
    @Default(<MeetingHistoryItem>[]) List<MeetingHistoryItem> history,
    String? error,
  }) = _AccountState;
}
