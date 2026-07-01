import '../../../../core/error/result.dart';
import '../../domain/entities/meeting_history_item.dart';
import '../../domain/entities/remembered_address.dart';
import '../../domain/entities/user_favorite.dart';
import '../../domain/repositories/address_memory_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/meeting_history_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl({
    required FavoritesRepository favorites,
    required MeetingHistoryRepository meetingHistory,
    required AddressMemoryRepository addressMemory,
  }) : _favorites = favorites,
       _meetingHistory = meetingHistory,
       _addressMemory = addressMemory;

  final FavoritesRepository _favorites;
  final MeetingHistoryRepository _meetingHistory;
  final AddressMemoryRepository _addressMemory;

  @override
  Stream<List<UserFavorite>> watchFavorites({
    required String userId,
    int limit = 100,
  }) {
    return _favorites.watchFavorites(userId: userId, limit: limit);
  }

  @override
  Future<Result<void>> upsertFavorite({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    return _favorites.upsertFavorite(
      userId: userId,
      placeName: placeName,
      placeAddress: placeAddress,
      placeType: placeType,
      lat: lat,
      lon: lon,
    );
  }

  @override
  Future<Result<void>> removeFavorite({
    required String userId,
    required String favoriteId,
  }) {
    return _favorites.removeFavorite(userId: userId, favoriteId: favoriteId);
  }

  @override
  Future<Result<void>> removeFavoriteByPlace({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return _favorites.removeFavoriteByPlace(
      userId: userId,
      placeName: placeName,
      lat: lat,
      lon: lon,
    );
  }

  @override
  Stream<List<MeetingHistoryItem>> watchRecentHistory({
    required String userId,
    int limit = 10,
  }) {
    return _meetingHistory.watchRecentHistory(userId: userId, limit: limit);
  }

  @override
  Future<Result<void>> recordMeetingHistory({
    required String roomId,
    required String placeName,
    required List<String> participantIds,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    return _meetingHistory.recordMeetingHistory(
      roomId: roomId,
      placeName: placeName,
      participantIds: participantIds,
      placeAddress: placeAddress,
      placeType: placeType,
      lat: lat,
      lon: lon,
    );
  }

  @override
  Stream<List<RememberedAddress>> watchFrequentAddresses({
    required String userId,
    int limit = 6,
  }) {
    return _addressMemory.watchFrequentAddresses(userId: userId, limit: limit);
  }

  @override
  Future<Result<void>> rememberAddress({
    required String userId,
    required String address,
  }) {
    return _addressMemory.rememberAddress(userId: userId, address: address);
  }

  @override
  Future<Result<void>> removeRememberedAddress({
    required String userId,
    required String address,
  }) {
    return _addressMemory.removeRememberedAddress(
      userId: userId,
      address: address,
    );
  }
}
