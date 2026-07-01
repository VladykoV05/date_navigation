import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/meeting_history_item.dart';
import '../../domain/entities/remembered_address.dart';
import '../../domain/entities/user_favorite.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/remote/user_profile_remote_data_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(this._remote);

  final UserProfileRemoteDataSource _remote;

  @override
  Stream<List<UserFavorite>> watchFavorites({
    required String userId,
    int limit = 100,
  }) {
    return _remote.watchFavorites(userId: userId, limit: limit);
  }

  @override
  Stream<List<MeetingHistoryItem>> watchRecentHistory({
    required String userId,
    int limit = 10,
  }) {
    return _remote.watchRecentHistory(userId: userId, limit: limit);
  }

  @override
  Stream<List<RememberedAddress>> watchFrequentAddresses({
    required String userId,
    int limit = 6,
  }) {
    return _remote.watchFrequentAddresses(userId: userId, limit: limit);
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
    return _runVoid(
      () => _remote.upsertFavorite(
        userId: userId,
        placeName: placeName,
        placeAddress: placeAddress,
        placeType: placeType,
        lat: lat,
        lon: lon,
      ),
      fallback: 'Не удалось сохранить в избранное',
    );
  }

  @override
  Future<Result<void>> removeFavorite({
    required String userId,
    required String favoriteId,
  }) {
    return _runVoid(
      () => _remote.removeFavorite(userId: userId, favoriteId: favoriteId),
      fallback: 'Не удалось удалить из избранного',
    );
  }

  @override
  Future<Result<void>> removeFavoriteByPlace({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return _runVoid(
      () => _remote.removeFavoriteByPlace(
        userId: userId,
        placeName: placeName,
        lat: lat,
        lon: lon,
      ),
      fallback: 'Не удалось удалить из избранного',
    );
  }

  @override
  Future<Result<void>> rememberAddress({
    required String userId,
    required String address,
  }) {
    return _runVoid(
      () => _remote.rememberAddress(userId: userId, address: address),
      fallback: 'Не удалось сохранить адрес',
    );
  }

  @override
  Future<Result<void>> removeRememberedAddress({
    required String userId,
    required String address,
  }) {
    return _runVoid(
      () => _remote.removeRememberedAddress(userId: userId, address: address),
      fallback: 'Не удалось удалить адрес',
    );
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
    return _runVoid(
      () => _remote.recordMeetingHistory(
        roomId: roomId,
        placeName: placeName,
        participantIds: participantIds,
        placeAddress: placeAddress,
        placeType: placeType,
        lat: lat,
        lon: lon,
      ),
      fallback: 'Не удалось сохранить историю встречи',
    );
  }

  Future<Result<void>> _runVoid(
    Future<void> Function() action, {
    required String fallback,
  }) async {
    try {
      await action();
      return const Ok(null);
    } on FirebaseException catch (e) {
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return Err(UnknownFailure(fallback));
    }
  }

  Failure _mapFirestoreFailure(
    FirebaseException e, {
    required String fallback,
  }) {
    return switch (e.code) {
      'unavailable' => const NetworkFailure('Сервис временно недоступен'),
      'permission-denied' => const UnknownFailure('Нет прав для операции'),
      _ => UnknownFailure(fallback),
    };
  }
}
