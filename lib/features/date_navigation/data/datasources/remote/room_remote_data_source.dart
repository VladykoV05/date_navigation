import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/result.dart';
import '../../../domain/entities/voting_decisions.dart';
import 'room_session_remote_data_source.dart';
import 'room_voting_remote_data_source.dart';

class RoomRemoteDataSource {
  static const String roomsCollection = 'rooms';
  static const String roomInvitesCollection = 'roomInvites';
  static const String usersCollection = 'users';

  final FirebaseFirestore _firestore;
  late final RoomSessionRemoteDataSource _sessionDataSource;
  late final RoomVotingRemoteDataSource _votingDataSource;

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
    final result = await respondToProposalForHistory(
      roomId: roomId,
      decision: decision,
      actedByUserId: actedByUserId,
    );
    return switch (result) {
      Ok() => const Ok(null),
      Err(:final failure) => Err(failure),
    };
  }

  Future<Result<AcceptedProposalHistoryDraft?>> respondToProposalForHistory({
    required String roomId,
    required ProposalResponseDecision decision,
    required String actedByUserId,
  }) async {
    return _votingDataSource.respondToProposal(
      roomsCollection: roomsCollection,
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
