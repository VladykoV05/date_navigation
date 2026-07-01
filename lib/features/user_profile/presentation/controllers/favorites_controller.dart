import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/auth_session.dart';
import '../../domain/entities/user_favorite.dart';
import '../../domain/usecases/remove_user_favorite.dart';
import '../../domain/usecases/upsert_user_favorite.dart';
import '../../domain/usecases/watch_user_favorites.dart';
import '../state/favorites_state.dart';

class FavoritesController extends StateNotifier<FavoritesState> {
  FavoritesController({
    required WatchUserFavorites watchFavorites,
    required UpsertUserFavorite upsertFavorite,
    required RemoveUserFavoriteByPlace removeFavorite,
    required AuthSession authSession,
  }) : _watchFavorites = watchFavorites,
       _upsertFavorite = upsertFavorite,
       _removeFavorite = removeFavorite,
       _authSession = authSession,
       super(const FavoritesState()) {
    final uid = userId;
    if (uid == null || uid.isEmpty) {
      state = state.copyWith(isLoading: false);
      return;
    }
    _favoritesSubscription = _watchFavorites(userId: uid).listen((favorites) {
      state = FavoritesState(
        favorites: favorites
            .where((favorite) => favorite.name.isNotEmpty)
            .toList(growable: false),
        isLoading: false,
      );
    });
  }

  final WatchUserFavorites _watchFavorites;
  final UpsertUserFavorite _upsertFavorite;
  final RemoveUserFavoriteByPlace _removeFavorite;
  final AuthSession _authSession;

  StreamSubscription<List<UserFavorite>>? _favoritesSubscription;

  String? get userId => _authSession.currentUserId;

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
