import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/result.dart';

abstract interface class UserFavoritesRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchFavorites({
    required String userId,
    int limit = 100,
  });

  Future<Result<void>> upsertFavorite({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  });

  Future<Result<void>> removeFavorite({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  });
}
