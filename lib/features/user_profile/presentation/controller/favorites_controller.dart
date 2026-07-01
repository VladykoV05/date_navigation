import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/auth_session.dart';
import '../../di/user_profile_providers.dart';
import '../../domain/entities/user_favorite.dart';
import '../../domain/usecases/remove_user_favorite.dart';
import '../../domain/usecases/upsert_user_favorite.dart';
import '../../domain/usecases/watch_user_favorites.dart';

class FavoritesController extends StateNotifier<List<String>> {
  FavoritesController({
    required WatchUserFavorites watchFavorites,
    required UpsertUserFavorite upsertFavorite,
    required RemoveUserFavoriteByPlace removeFavorite,
    required AuthSession authSession,
  }) : _watchFavorites = watchFavorites,
       _upsertFavorite = upsertFavorite,
       _removeFavorite = removeFavorite,
       _authSession = authSession,
       super(const []) {
    final uid = userId;
    if (uid == null || uid.isEmpty) return;
    _favoritesSubscription = _watchFavorites(userId: uid).listen((favorites) {
      final names = favorites
          .map((favorite) => favorite.name)
          .where((name) => name.isNotEmpty)
          .toList(growable: false);
      state = names;
    });
  }

  final WatchUserFavorites _watchFavorites;
  final UpsertUserFavorite _upsertFavorite;
  final RemoveUserFavoriteByPlace _removeFavorite;
  final AuthSession _authSession;

  StreamSubscription<List<UserFavorite>>? _favoritesSubscription;

  String? get userId => _authSession.currentUserId;

  bool isFavorite(String placeName) => state.contains(placeName);

  Future<bool> toggleFavorite({
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) async {
    final uid = userId;
    if (uid == null || uid.isEmpty) return false;
    final favorite = isFavorite(placeName);
    final res = favorite
        ? await _removeFavorite(
            userId: uid,
            placeName: placeName,
            lat: lat,
            lon: lon,
          )
        : await _upsertFavorite(
            userId: uid,
            placeName: placeName,
            placeAddress: placeAddress,
            placeType: placeType,
            lat: lat,
            lon: lon,
          );
    return res is Ok<void>;
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}

final favoritesControllerProvider =
    StateNotifierProvider.autoDispose<FavoritesController, List<String>>(
      (ref) => FavoritesController(
        watchFavorites: ref.watch(profileWatchUserFavoritesProvider),
        upsertFavorite: ref.watch(profileUpsertUserFavoriteProvider),
        removeFavorite: ref.watch(profileRemoveUserFavoriteByPlaceProvider),
        authSession: ref.watch(authSessionProvider),
      ),
    );
