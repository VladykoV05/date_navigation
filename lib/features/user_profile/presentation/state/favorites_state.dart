import '../../domain/entities/favorite_place_key.dart';
import '../../domain/entities/user_favorite.dart';

class FavoritesState {
  const FavoritesState({this.favorites = const [], this.isLoading = true});

  final List<UserFavorite> favorites;
  final bool isLoading;

  Set<FavoritePlaceKey> get keys {
    return favorites
        .map(
          (favorite) => FavoritePlaceKey.fromPlace(
            placeName: favorite.name,
            lat: favorite.lat,
            lon: favorite.lon,
          ),
        )
        .toSet();
  }

  bool containsPlace({required String placeName, double? lat, double? lon}) {
    return keys.contains(
      FavoritePlaceKey.fromPlace(placeName: placeName, lat: lat, lon: lon),
    );
  }

  FavoritesState copyWith({List<UserFavorite>? favorites, bool? isLoading}) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
