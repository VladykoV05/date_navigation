import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/result.dart';
import '../../../domain/entities/voting_decisions.dart';
import 'room_session_remote_data_source.dart';
import 'room_user_data_remote_data_source.dart';
import 'room_voting_remote_data_source.dart';

class RoomRemoteDataSource {
  static const String roomsCollection = 'rooms';
  static const String roomInvitesCollection = 'roomInvites';
  static const String usersCollection = 'users';
  static const int defaultRecentHistoryLimit = 10;
  static const int defaultFavoritesLimit = 100;
  static const int defaultFrequentAddressesLimit = 6;

  final FirebaseFirestore _firestore;
  late final RoomSessionRemoteDataSource _sessionDataSource;
  late final RoomVotingRemoteDataSource _votingDataSource;
  late final RoomUserDataRemoteDataSource _userDataSource;

  RoomRemoteDataSource(this._firestore) {
    _initializeDataSources();
  }

  void _initializeDataSources() {
    _sessionDataSource = RoomSessionRemoteDataSource(
      _firestore,
      _mapFirestoreFailure,
    );
    _votingDataSource = RoomVotingRemoteDataSource(
      _firestore,
      _mapFirestoreFailure,
      normalizeParticipants: normalizeParticipants,
    );
    _userDataSource = RoomUserDataRemoteDataSource(
      _firestore,
      _mapFirestoreFailure,
      favoriteDocId: favoriteDocId,
    );
  }

  Future<Result<String>> createRoom(String code, {String? createdBy}) async {
    return _sessionDataSource.createRoom(
      code,
      roomsCollection: roomsCollection,
      invitesCollection: roomInvitesCollection,
      createdBy: createdBy,
    );
  }

  Future<Result<String>> joinRoom({
    required String inviteCode,
    required String userId,
  }) async {
    return _sessionDataSource.joinRoom(
      roomsCollection: roomsCollection,
      invitesCollection: roomInvitesCollection,
      inviteCode: inviteCode,
      userId: userId,
    );
  }

  Future<Result<void>> updateLocation({
    required String roomId,
    required String userId,
    required latlong.LatLng coords,
  }) async {
    return _sessionDataSource.updateLocation(
      roomsCollection: roomsCollection,
      roomId: roomId,
      userId: userId,
      coords: coords,
    );
  }

  Future<Result<void>> completeSession({
    required String roomId,
    required String userId,
  }) async {
    return _sessionDataSource.completeSession(
      roomsCollection: roomsCollection,
      roomId: roomId,
      userId: userId,
    );
  }

  Future<Result<void>> voteForPlace({
    required String roomId,
    required String userId,
    required String placeName,
  }) async {
    return _votingDataSource.voteForPlace(
      roomsCollection: roomsCollection,
      roomId: roomId,
      userId: userId,
      placeName: placeName,
    );
  }

  Future<Result<void>> proposePlace({
    required String roomId,
    required String placeName,
    required ProposalAuthorRole authorRole,
    required double lat,
    required double lon,
    String? placeAddress,
    String? placeType,
  }) async {
    return _votingDataSource.proposePlace(
      roomsCollection: roomsCollection,
      roomId: roomId,
      placeName: placeName,
      authorRole: authorRole,
      lat: lat,
      lon: lon,
      placeAddress: placeAddress,
      placeType: placeType,
    );
  }

  Future<Result<void>> respondToProposal({
    required String roomId,
    required ProposalResponseDecision decision,
    required String actedByUserId,
  }) async {
    return _votingDataSource.respondToProposal(
      roomsCollection: roomsCollection,
      usersCollection: usersCollection,
      roomId: roomId,
      decision: decision,
      actedByUserId: actedByUserId,
    );
  }

  Future<Result<void>> saveMeetingSnapshot({
    required String roomId,
    required latlong.LatLng centerPoint,
    required List<latlong.LatLng> routePoints,
    required List<Map<String, dynamic>> places,
    required int searchRadius,
    required String meetingFormat,
  }) async {
    return _votingDataSource.saveMeetingSnapshot(
      roomsCollection: roomsCollection,
      roomId: roomId,
      centerPoint: centerPoint,
      routePoints: routePoints,
      places: places,
      searchRadius: searchRadius,
      meetingFormat: meetingFormat,
    );
  }

  Future<Result<void>> saveSelectedScenario({
    required String roomId,
    required Map<String, dynamic> scenario,
    required String selectedByUserId,
  }) async {
    return _votingDataSource.saveSelectedScenario(
      roomsCollection: roomsCollection,
      roomId: roomId,
      scenario: scenario,
      selectedByUserId: selectedByUserId,
    );
  }

  Future<Result<void>> saveMeetingFormats({
    required String roomId,
    required String userId,
    required List<String> formats,
  }) async {
    return _votingDataSource.saveMeetingFormats(
      roomsCollection: roomsCollection,
      roomId: roomId,
      userId: userId,
      formats: formats,
    );
  }

  Future<Result<void>> requestMeetingRevote({
    required String roomId,
    required String userId,
    required List<String> formats,
  }) async {
    return _votingDataSource.requestMeetingRevote(
      roomsCollection: roomsCollection,
      roomId: roomId,
      userId: userId,
      formats: formats,
    );
  }

  Future<Result<void>> respondMeetingRevote({
    required String roomId,
    required String userId,
    required MeetingRevoteResponseDecision decision,
  }) async {
    return _votingDataSource.respondMeetingRevote(
      roomsCollection: roomsCollection,
      roomId: roomId,
      userId: userId,
      decision: decision,
    );
  }

  Future<Result<void>> saveSelectedMeetingFormat({
    required String roomId,
    required String userId,
    required String format,
  }) async {
    return _votingDataSource.saveSelectedMeetingFormat(
      roomsCollection: roomsCollection,
      roomId: roomId,
      userId: userId,
      format: format,
    );
  }

  Future<Result<void>> saveSearchRadius({
    required String roomId,
    required String userId,
    required int radius,
  }) async {
    return _votingDataSource.saveSearchRadius(
      roomsCollection: roomsCollection,
      roomId: roomId,
      userId: userId,
      radius: radius,
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchRoom(String roomId) {
    return _sessionDataSource.watchRoom(
      roomsCollection: roomsCollection,
      roomId: roomId,
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRecentHistory({
    required String userId,
    int limit = defaultRecentHistoryLimit,
  }) {
    return _userDataSource.watchRecentHistory(
      usersCollection: usersCollection,
      userId: userId,
      limit: limit,
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchFavorites({
    required String userId,
    int limit = defaultFavoritesLimit,
  }) {
    return _userDataSource.watchFavorites(
      usersCollection: usersCollection,
      userId: userId,
      limit: limit,
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchFrequentAddresses({
    required String userId,
    int limit = defaultFrequentAddressesLimit,
  }) {
    return _userDataSource.watchFrequentAddresses(
      usersCollection: usersCollection,
      userId: userId,
      limit: limit,
    );
  }

  Future<Result<void>> upsertFavorite({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) async {
    return _userDataSource.upsertFavorite(
      usersCollection: usersCollection,
      userId: userId,
      placeName: placeName,
      placeAddress: placeAddress,
      placeType: placeType,
      lat: lat,
      lon: lon,
    );
  }

  Future<Result<void>> removeFavorite({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) async {
    return _userDataSource.removeFavorite(
      usersCollection: usersCollection,
      userId: userId,
      placeName: placeName,
      lat: lat,
      lon: lon,
    );
  }

  Future<Result<void>> rememberAddress({
    required String userId,
    required String address,
  }) {
    return _userDataSource.rememberAddress(
      usersCollection: usersCollection,
      userId: userId,
      address: address,
    );
  }

  Future<Result<void>> removeRememberedAddress({
    required String userId,
    required String address,
  }) {
    return _userDataSource.removeRememberedAddress(
      usersCollection: usersCollection,
      userId: userId,
      address: address,
    );
  }

  @visibleForTesting
  static List<String> normalizeParticipants({
    required String creatorUid,
    required String partnerUid,
    required List<String> participants,
    required String actedByUserId,
  }) {
    final ids = <String>{
      ...participants.map((id) => id.trim()).where((id) => id.isNotEmpty),
      creatorUid.trim(),
      partnerUid.trim(),
      actedByUserId.trim(),
    }..removeWhere((id) => id.isEmpty);
    return ids.toList(growable: false);
  }

  @visibleForTesting
  static String favoriteDocId({
    required String placeName,
    double? lat,
    double? lon,
  }) {
    final normalized = placeName.trim().toLowerCase();
    final sanitized = normalized.replaceAll(
      RegExp(r'[^a-z0-9а-яё]+', caseSensitive: false),
      '_',
    );
    final latPart = lat?.toStringAsFixed(5) ?? 'na';
    final lonPart = lon?.toStringAsFixed(5) ?? 'na';
    final base = sanitized.isEmpty ? 'favorite_place' : sanitized;
    return '${base}_${latPart}_$lonPart';
  }

  Failure _mapFirestoreFailure(
    FirebaseException e, {
    required String fallback,
  }) {
    // Keep user-facing failures deterministic for the most common Firestore codes.
    return switch (e.code) {
      'unavailable' => const NetworkFailure('Сервис временно недоступен'),
      'permission-denied' => const UnknownFailure('Нет прав для операции'),
      _ => UnknownFailure(fallback),
    };
  }
}
