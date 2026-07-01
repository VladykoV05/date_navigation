import '../../../../core/error/result.dart';
import '../entities/meeting_history_item.dart';
import '../entities/remembered_address.dart';
import '../entities/user_favorite.dart';

abstract interface class UserProfileRepository {
  Stream<List<UserFavorite>> watchFavorites({
    required String userId,
    int limit = 100,
  });

  Stream<List<MeetingHistoryItem>> watchRecentHistory({
    required String userId,
    int limit = 10,
  });

  Stream<List<RememberedAddress>> watchFrequentAddresses({
    required String userId,
    int limit = 6,
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
    required String favoriteId,
  });

  Future<Result<void>> removeFavoriteByPlace({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  });

  Future<Result<void>> rememberAddress({
    required String userId,
    required String address,
  });

  Future<Result<void>> removeRememberedAddress({
    required String userId,
    required String address,
  });

  Future<Result<void>> recordMeetingHistory({
    required String roomId,
    required String placeName,
    required List<String> participantIds,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  });
}
