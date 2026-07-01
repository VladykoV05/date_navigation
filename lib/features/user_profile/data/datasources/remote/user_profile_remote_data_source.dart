import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/meeting_history_item.dart';
import '../../../domain/entities/remembered_address.dart';
import '../../../domain/entities/user_favorite.dart';
import 'user_address_memory_remote_data_source.dart';
import 'user_favorites_remote_data_source.dart';
import 'user_meeting_history_remote_data_source.dart';

class UserProfileRemoteDataSource {
  UserProfileRemoteDataSource(FirebaseFirestore firestore)
    : _favorites = UserFavoritesRemoteDataSource(firestore),
      _addressMemory = UserAddressMemoryRemoteDataSource(firestore),
      _meetingHistory = UserMeetingHistoryRemoteDataSource(firestore);

  final UserFavoritesRemoteDataSource _favorites;
  final UserAddressMemoryRemoteDataSource _addressMemory;
  final UserMeetingHistoryRemoteDataSource _meetingHistory;

  Stream<List<UserFavorite>> watchFavorites({
    required String userId,
    int limit = 100,
  }) {
    return _favorites.watchFavorites(userId: userId, limit: limit);
  }

  Stream<List<MeetingHistoryItem>> watchRecentHistory({
    required String userId,
    int limit = 10,
  }) {
    return _meetingHistory.watchRecentHistory(userId: userId, limit: limit);
  }

  Stream<List<RememberedAddress>> watchFrequentAddresses({
    required String userId,
    int limit = 6,
  }) {
    return _addressMemory.watchFrequentAddresses(userId: userId, limit: limit);
  }

  Future<void> upsertFavorite({
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

  Future<void> removeFavorite({
    required String userId,
    required String favoriteId,
  }) {
    return _favorites.removeFavorite(userId: userId, favoriteId: favoriteId);
  }

  Future<void> removeFavoriteByPlace({
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

  Future<void> rememberAddress({
    required String userId,
    required String address,
  }) {
    return _addressMemory.rememberAddress(userId: userId, address: address);
  }

  Future<void> removeRememberedAddress({
    required String userId,
    required String address,
  }) {
    return _addressMemory.removeRememberedAddress(
      userId: userId,
      address: address,
    );
  }

  Future<void> recordMeetingHistory({
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

  static String favoriteDocId({
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return UserFavoritesRemoteDataSource.favoriteDocId(
      placeName: placeName,
      lat: lat,
      lon: lon,
    );
  }

  static String addressDocId(String address) {
    return UserAddressMemoryRemoteDataSource.addressDocId(address);
  }
}
