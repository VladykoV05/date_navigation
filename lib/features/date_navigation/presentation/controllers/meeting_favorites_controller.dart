import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/auth_session.dart';
import '../../../user_profile/user_profile.dart';
import '../../application/ports/favorites_port.dart';
import '../state/meeting_favorites_state.dart';

class MeetingFavoritesController extends StateNotifier<MeetingFavoritesState> {
  MeetingFavoritesController({
    required FavoritesPort favoritesPort,
    required AuthSession authSession,
  }) : _favoritesPort = favoritesPort,
       _authSession = authSession,
       super(const MeetingFavoritesState()) {
    final uid = userId;
    if (uid == null || uid.isEmpty) {
      state = state.copyWith(isLoading: false);
      return;
    }
    _favoritesSubscription = _favoritesPort
        .watchFavorites(userId: uid)
        .listen((favorites) {
          state = MeetingFavoritesState(
            favorites: favorites
                .where((favorite) => favorite.name.isNotEmpty)
                .toList(growable: false),
            isLoading: false,
          );
        });
  }

  final FavoritesPort _favoritesPort;
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
        ? await _favoritesPort.removeFavorite(
            userId: uid,
            placeName: placeName,
            lat: lat,
            lon: lon,
          )
        : await _favoritesPort.upsertFavorite(
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
