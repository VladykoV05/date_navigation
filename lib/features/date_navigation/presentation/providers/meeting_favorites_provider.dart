import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/error/result.dart';
import '../../../user_profile/user_profile.dart';
import '../../application/adapters/user_profile_favorites_adapter.dart';
import '../../application/ports/favorites_port.dart';
import '../state/meeting_favorites_state.dart';

final favoritesPortProvider = Provider<FavoritesPort>(
  (ref) => UserProfileFavoritesAdapter(
    watchFavorites: ref.watch(profileWatchUserFavoritesProvider),
    upsertFavorite: ref.watch(profileUpsertUserFavoriteProvider),
    removeFavorite: ref.watch(profileRemoveUserFavoriteByPlaceProvider),
  ),
);

class MeetingFavoritesController extends Notifier<MeetingFavoritesState> {
  StreamSubscription<List<UserFavorite>>? _favoritesSubscription;

  String? get userId => ref.read(authSessionProvider).currentUserId;

  @override
  MeetingFavoritesState build() {
    ref.onDispose(() {
      _favoritesSubscription?.cancel();
    });

    final uid = userId;
    if (uid == null || uid.isEmpty) {
      return const MeetingFavoritesState(isLoading: false);
    }

    _favoritesSubscription = ref
        .read(favoritesPortProvider)
        .watchFavorites(userId: uid)
        .listen((favorites) {
          state = MeetingFavoritesState(
            favorites: favorites
                .where((favorite) => favorite.name.isNotEmpty)
                .toList(growable: false),
            isLoading: false,
          );
        });

    return const MeetingFavoritesState();
  }

  bool isFavorite({required String placeName, double? lat, double? lon}) {
    return state.containsPlace(placeName: placeName, lat: lat, lon: lon);
  }

  Future<bool> toggleFavorite({
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) async {
    final uid = userId;
    if (uid == null || uid.isEmpty) return false;
    final favorite = isFavorite(placeName: placeName, lat: lat, lon: lon);
    final port = ref.read(favoritesPortProvider);
    final res = favorite
        ? await port.removeFavorite(
            userId: uid,
            placeName: placeName,
            lat: lat,
            lon: lon,
          )
        : await port.upsertFavorite(
            userId: uid,
            placeName: placeName,
            placeAddress: placeAddress,
            placeType: placeType,
            lat: lat,
            lon: lon,
          );
    return res is Ok<void>;
  }
}

final meetingFavoritesControllerProvider =
    NotifierProvider.autoDispose<
      MeetingFavoritesController,
      MeetingFavoritesState
    >(MeetingFavoritesController.new);
