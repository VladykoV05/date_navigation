import 'package:date_navigation/features/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('favorite place key separates same name with different coordinates', () {
    final first = FavoritePlaceKey.fromPlace(
      placeName: 'Coffee Spot',
      lat: 55.751244,
      lon: 37.618423,
    );
    final second = FavoritePlaceKey.fromPlace(
      placeName: 'coffee spot',
      lat: 55.761244,
      lon: 37.628423,
    );

    expect(first, isNot(second));
    expect(first.docId, isNot(second.docId));
  });

  test('favorites state checks places by composite identity', () {
    const state = FavoritesState(
      isLoading: false,
      favorites: [
        UserFavorite(
          id: 'coffee_55.75124_37.61842',
          name: 'Coffee Spot',
          lat: 55.751244,
          lon: 37.618423,
        ),
      ],
    );

    expect(
      state.containsPlace(
        placeName: 'coffee spot',
        lat: 55.751244,
        lon: 37.618423,
      ),
      isTrue,
    );
    expect(
      state.containsPlace(
        placeName: 'coffee spot',
        lat: 55.761244,
        lon: 37.628423,
      ),
      isFalse,
    );
  });
}
