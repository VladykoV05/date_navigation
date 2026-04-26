import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/auth_session.dart';
import '../../domain/entities/place.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../domain/usecases/upsert_favorite.dart';
import '../../domain/usecases/watch_favorites.dart';
import '../../di/date_navigation_di.dart';

class FavoritesController extends StateNotifier<List<String>> {
  FavoritesController({
    required WatchFavorites watchFavorites,
    required UpsertFavorite upsertFavorite,
    required RemoveFavorite removeFavorite,
    required AuthSession authSession,
  }) : _watchFavorites = watchFavorites,
       _upsertFavorite = upsertFavorite,
       _removeFavorite = removeFavorite,
       _authSession = authSession,
       super(const []) {
    final uid = userId;
    if (uid == null || uid.isEmpty) return;
    _favoritesSubscription = _watchFavorites(userId: uid).listen((snap) {
      final names = snap.docs
          .map((doc) => (doc.data()['placeName'] ?? '').toString())
          .where((name) => name.isNotEmpty)
          .toList(growable: false);
      state = names;
    });
  }

  final WatchFavorites _watchFavorites;
  final UpsertFavorite _upsertFavorite;
  final RemoveFavorite _removeFavorite;
  final AuthSession _authSession;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _favoritesSubscription;

  String? get userId => _authSession.currentUserId;

  bool isFavorite(String placeName) => state.contains(placeName);

  Future<bool> toggleFavorite(Place place) async {
    final uid = userId;
    if (uid == null || uid.isEmpty) return false;
    final favorite = isFavorite(place.name);
    final res = favorite
        ? await _removeFavorite(
            userId: uid,
            placeName: place.name,
            lat: place.lat,
            lon: place.lon,
          )
        : await _upsertFavorite(
            userId: uid,
            placeName: place.name,
            placeAddress: place.address,
            placeType: place.type,
            lat: place.lat,
            lon: place.lon,
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
        watchFavorites: ref.watch(watchFavoritesProvider),
        upsertFavorite: ref.watch(upsertFavoriteProvider),
        removeFavorite: ref.watch(removeFavoriteProvider),
        authSession: ref.watch(authSessionProvider),
      ),
    );
