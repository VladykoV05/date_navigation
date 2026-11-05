import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../domain/entities/room_status.dart';
import 'firestore_error_guard.dart';

/// Короткий код открытой сессии: 6 символов без похожих (0/O, 1/I).
const String _openRoomCodeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const int openRoomCodeLength = 6;

String generateOpenRoomCode({Random? random}) {
  final rnd = random ?? Random.secure();
  return List.generate(
    openRoomCodeLength,
    (_) => _openRoomCodeAlphabet[rnd.nextInt(_openRoomCodeAlphabet.length)],
  ).join();
}

class RoomSessionRemoteDataSource {
  const RoomSessionRemoteDataSource(this._firestore, this._mapFirestoreFailure);

  final FirebaseFirestore _firestore;
  final Failure Function(FirebaseException e, {required String fallback})
  _mapFirestoreFailure;

  Future<Result<String>> createRoom(
    String inviteCode, {
    required String roomsCollection,
    required String invitesCollection,
    String? createdBy,
  }) async {
    try {
      final creatorUid = (createdBy ?? '').trim();
      if (creatorUid.isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'failed-precondition',
          message: FailureCodes.creatorUnresolved,
        );
      }
      final now = DateTime.now();
      final expiresAt = Timestamp.fromDate(now.add(const Duration(hours: 12)));
      final normalizedInviteCode = inviteCode.trim();
      if (normalizedInviteCode.isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'failed-precondition',
          message: FailureCodes.roomCodeEmpty,
        );
      }
      final roomRef = _firestore.collection(roomsCollection).doc();
      final inviteRef = _firestore
          .collection(invitesCollection)
          .doc(normalizedInviteCode);
      await _firestore.runTransaction((tx) async {
        final inviteSnap = await tx.get(inviteRef);
        if (inviteSnap.exists) {
          final inviteData = inviteSnap.data() ?? <String, dynamic>{};
          final inviteExpiresAt = inviteData['expiresAt'];
          final isExpired =
              inviteExpiresAt is Timestamp &&
              inviteExpiresAt.toDate().isBefore(now);
          if (!isExpired) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'already-exists',
              message: FailureCodes.roomCodeExists,
            );
          }
        }
        tx.set(roomRef, {
          'inviteCode': normalizedInviteCode,
          'point1': null,
          'point2': null,
          'finalChoice': null,
          'proposal': null,
          'votes': <String, String>{},
          'sessionStatus': SessionStatus.active.wireValue,
          'createdAt': Timestamp.fromDate(now),
          'updatedAt': Timestamp.fromDate(now),
          'expiresAt': expiresAt,
          'createdBy': creatorUid,
          'creatorUid': creatorUid,
          'partnerUid': null,
          'participants': <String>[creatorUid],
          'creatorSearchRadius': 500,
          'partnerSearchRadius': null,
          'creatorSearchRadiusUpdatedAt': Timestamp.fromDate(now),
          'partnerSearchRadiusUpdatedAt': null,
          'creatorMeetingFormats': <String>[],
          'partnerMeetingFormats': <String>[],
          'creatorSelectedMeetingFormat': null,
          'partnerSelectedMeetingFormat': null,
          'selectedMeetingFormat': null,
          'creatorMeetingFormatUpdatedAt': null,
          'partnerMeetingFormatUpdatedAt': null,
        });
        tx.set(inviteRef, {
          'roomId': roomRef.id,
          'expiresAt': expiresAt,
          'createdAt': Timestamp.fromDate(now),
          'createdBy': creatorUid,
        });
      });
      return Ok(roomRef.id);
    } on FirebaseException catch (e) {
      final fallback = switch (e.code) {
        'already-exists' => FailureCodes.roomCodeExists,
        'failed-precondition' => e.message ?? FailureCodes.creatorUnresolved,
        _ => FailureCodes.createRoomFailed,
      };
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.createRoomFailed));
    }
  }

  Future<Result<String>> joinRoom({
    required String roomsCollection,
    required String invitesCollection,
    required String inviteCode,
    required String userId,
  }) async {
    try {
      final normalizedInviteCode = inviteCode.trim();
      if (normalizedInviteCode.isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'not-found',
          message: FailureCodes.roomNotFound,
        );
      }
      final inviteRef = _firestore
          .collection(invitesCollection)
          .doc(normalizedInviteCode);
      final inviteSnapshot = await inviteRef.get();
      if (!inviteSnapshot.exists) {
        // Backward compatibility: old rooms used short code as document id.
        return await _joinLegacyRoomById(
          roomsCollection: roomsCollection,
          roomId: normalizedInviteCode,
          userId: userId,
        );
      }
      late final String resolvedRoomId;
      await _firestore.runTransaction((tx) async {
        final inviteSnap = await tx.get(inviteRef);
        if (!inviteSnap.exists) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: FailureCodes.roomNotFound,
          );
        }
        final inviteData = inviteSnap.data() ?? <String, dynamic>{};
        final mappedRoomId = (inviteData['roomId'] ?? '').toString().trim();
        final inviteExpiresAt = inviteData['expiresAt'];
        final isExpired =
            inviteExpiresAt is Timestamp &&
            inviteExpiresAt.toDate().isBefore(DateTime.now());
        if (mappedRoomId.isEmpty || isExpired) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: FailureCodes.roomNotFound,
          );
        }
        final roomRef = _firestore
            .collection(roomsCollection)
            .doc(mappedRoomId);
        final snap = await tx.get(roomRef);
        if (!snap.exists) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: FailureCodes.roomNotFound,
          );
        }
        final data = snap.data() ?? <String, dynamic>{};
        if (data['type'] == 'open') {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: FailureCodes.roomNotOpen,
          );
        }
        final creatorUid = ((data['creatorUid'] ?? data['createdBy']) ?? '')
            .toString();
        final partnerUid = (data['partnerUid'] ?? '').toString();
        final participants = List<String>.from(
          data['participants'] ?? const <String>[],
        );
        final roomExpiresAt = data['expiresAt'];
        final roomIsExpired =
            roomExpiresAt is Timestamp &&
            roomExpiresAt.toDate().isBefore(DateTime.now());
        if (roomIsExpired) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: FailureCodes.roomNotFound,
          );
        }

        if (creatorUid.isEmpty) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: FailureCodes.roomCorrupt,
          );
        }

        if (userId == creatorUid ||
            userId == partnerUid ||
            participants.contains(userId)) {
          resolvedRoomId = mappedRoomId;
          return;
        }

        if (partnerUid.isNotEmpty && partnerUid != userId) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'already-exists',
            message: FailureCodes.roomFull,
          );
        }

        final normalizedParticipants = <String>{creatorUid, userId}.toList();
        tx.update(roomRef, {
          'partnerUid': userId,
          'participants': normalizedParticipants,
          'partnerSearchRadius': 500,
          'partnerSearchRadiusUpdatedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        resolvedRoomId = mappedRoomId;
      });
      return Ok(resolvedRoomId);
    } on FirebaseException catch (e) {
      final fallback = switch (e.code) {
        'not-found' => FailureCodes.roomNotFound,
        'already-exists' => FailureCodes.roomFull,
        'failed-precondition' =>
          e.message == FailureCodes.roomNotOpen
              ? FailureCodes.roomNotOpen
              : FailureCodes.roomCorrupt,
        _ => FailureCodes.joinRoomFailed,
      };
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.joinRoomFailed));
    }
  }

  Future<Result<String>> _joinLegacyRoomById({
    required String roomsCollection,
    required String roomId,
    required String userId,
  }) async {
    try {
      final roomRef = _firestore.collection(roomsCollection).doc(roomId);
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(roomRef);
        if (!snap.exists) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: FailureCodes.roomNotFound,
          );
        }
        final data = snap.data() ?? <String, dynamic>{};
        if (data['type'] == 'open') {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: FailureCodes.roomNotOpen,
          );
        }
        final creatorUid = ((data['creatorUid'] ?? data['createdBy']) ?? '')
            .toString();
        final partnerUid = (data['partnerUid'] ?? '').toString();
        final participants = List<String>.from(
          data['participants'] ?? const <String>[],
        );
        if (creatorUid.isEmpty) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: FailureCodes.roomCorrupt,
          );
        }
        if (userId == creatorUid ||
            userId == partnerUid ||
            participants.contains(userId)) {
          return;
        }
        if (partnerUid.isNotEmpty && partnerUid != userId) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'already-exists',
            message: FailureCodes.roomFull,
          );
        }
        final normalizedParticipants = <String>{creatorUid, userId}.toList();
        tx.update(roomRef, {
          'partnerUid': userId,
          'participants': normalizedParticipants,
          'partnerSearchRadius': 500,
          'partnerSearchRadiusUpdatedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
      return Ok(roomId);
    } on FirebaseException catch (e) {
      final fallback = switch (e.code) {
        'not-found' => FailureCodes.roomNotFound,
        'already-exists' => FailureCodes.roomFull,
        'failed-precondition' =>
          e.message == FailureCodes.roomNotOpen
              ? FailureCodes.roomNotOpen
              : FailureCodes.roomCorrupt,
        _ => FailureCodes.joinRoomFailed,
      };
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.joinRoomFailed));
    }
  }

  Future<Result<void>> updateLocation({
    required String roomsCollection,
    required String roomId,
    required String userId,
    required latlong.LatLng coords,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
        final roomRef = _firestore.collection(roomsCollection).doc(roomId);
        await _firestore.runTransaction((tx) async {
          final snap = await tx.get(roomRef);
          final data = snap.data() ?? <String, dynamic>{};
          if (data['type'] == 'open') {
            final participants = List<String>.from(
              data['participants'] ?? const <String>[],
            );
            if (!participants.contains(userId)) {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                code: 'permission-denied',
                message: FailureCodes.notRoomMember,
              );
            }
            tx.set(roomRef.collection('participants').doc(userId), {
              'point': {'lat': coords.latitude, 'lng': coords.longitude},
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
            return;
          }
          final creatorUid = ((data['creatorUid'] ?? data['createdBy']) ?? '')
              .toString();
          final partnerUid = (data['partnerUid'] ?? '').toString();
          final field = userId == creatorUid
              ? 'point1'
              : (userId == partnerUid ? 'point2' : null);
          if (field == null) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
              message: FailureCodes.notRoomMember,
            );
          }
          tx.update(roomRef, {
            field: {'lat': coords.latitude, 'lng': coords.longitude},
          });
        });
      },
      mapper: _mapFirestoreFailure,
      fallback: FailureCodes.updateLocationFailed,
    );
  }

  Future<Result<void>> completeSession({
    required String roomsCollection,
    required String roomId,
    required String userId,
  }) async {
    return FirestoreErrorGuard.runVoidWithFallback(
      () async {
        final roomRef = _firestore.collection(roomsCollection).doc(roomId);
        await _firestore.runTransaction((tx) async {
          final snap = await tx.get(roomRef);
          if (!snap.exists) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'not-found',
              message: FailureCodes.roomNotFound,
            );
          }
          final data = snap.data() ?? <String, dynamic>{};
          final creatorUid = ((data['creatorUid'] ?? data['createdBy']) ?? '')
              .toString();
          if (creatorUid.isEmpty || creatorUid != userId) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
              message: FailureCodes.onlyCreatorCanEnd,
            );
          }
          if (SessionStatus.fromWireValue(data['sessionStatus']).isCompleted) {
            return;
          }
          tx.update(roomRef, {
            'sessionStatus': SessionStatus.completed.wireValue,
            'completedAt': FieldValue.serverTimestamp(),
            'completedBy': userId,
          });
        });
      },
      mapper: _mapFirestoreFailure,
      fallbackFor: (e) => switch (e.code) {
        'not-found' => FailureCodes.roomNotFound,
        'permission-denied' => FailureCodes.onlyCreatorCanEnd,
        _ => FailureCodes.completeSessionFailed,
      },
      unknownFallback: FailureCodes.completeSessionFailed,
    );
  }

  /// Member leaves an open room: one transaction updates the room, writes a
  /// system message while still a member, and deletes the member document.
  Future<Result<void>> leaveOpenRoom({
    required String roomsCollection,
    required String roomId,
    required String userId,
  }) async {
    return FirestoreErrorGuard.runVoidWithFallback(
      () async {
        final roomRef = _firestore.collection(roomsCollection).doc(roomId);
        final memberRef = roomRef.collection('participants').doc(userId);
        final messageRef = roomRef.collection('messages').doc();
        await _firestore.runTransaction((tx) async {
          final snap = await tx.get(roomRef);
          if (!snap.exists) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'not-found',
              message: FailureCodes.roomNotFound,
            );
          }
          final data = snap.data() ?? <String, dynamic>{};
          if ((data['type'] ?? '').toString() != 'open') {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
              message: FailureCodes.notRoomMember,
            );
          }
          final creatorUid = ((data['creatorUid'] ?? data['createdBy']) ?? '')
              .toString();
          final sessionClosed = SessionStatus.fromWireValue(
            data['sessionStatus'],
          ).isClosed;
          if (creatorUid == userId && !sessionClosed) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
              message: FailureCodes.hostCannotLeave,
            );
          }
          final participants = List<String>.from(
            data['participants'] ?? const <String>[],
          );
          if (!participants.contains(userId)) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
              message: FailureCodes.notRoomMember,
            );
          }
          final remaining = participants
              .where((uid) => uid != userId)
              .toList(growable: false);
          final storedCount =
              (data['participantCount'] as num?)?.toInt() ??
              participants.length;
          tx.update(roomRef, {
            'participants': remaining,
            'participantCount': storedCount - 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          tx.set(messageRef, {
            'senderUid': userId,
            'text': 'system.participant_left',
            'kind': 'system',
            'clientId': messageRef.id,
            'createdAt': FieldValue.serverTimestamp(),
          });
          tx.delete(memberRef);
        });
      },
      mapper: _mapFirestoreFailure,
      fallbackFor: (e) => switch (e.code) {
        'not-found' => FailureCodes.roomNotFound,
        'permission-denied' => e.message ?? FailureCodes.leaveRoomFailed,
        _ => FailureCodes.leaveRoomFailed,
      },
      unknownFallback: FailureCodes.leaveRoomFailed,
    );
  }

  static const int openRoomCapacityMax = 20;

  Future<Result<String>> createOpenRoom({
    required String roomsCollection,
    required String hostUid,
    required int capacity,
    Map<String, dynamic>? event,
  }) async {
    try {
      final host = hostUid.trim();
      if (host.isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'failed-precondition',
          message: FailureCodes.creatorUnresolved,
        );
      }
      if (capacity < 2 || capacity > openRoomCapacityMax) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invalid-argument',
          message: FailureCodes.roomCapacityInvalid,
        );
      }
      final now = DateTime.now();
      final roomRef = _firestore.collection(roomsCollection).doc();
      final batch = _firestore.batch();
      batch.set(roomRef, {
        'schemaVersion': 2,
        'inviteCode': generateOpenRoomCode(),
        'type': 'open',
        'visibility': 'public',
        'capacity': capacity,
        'hostUid': host,
        'creatorUid': host,
        'createdBy': host,
        'participants': <String>[host],
        'participantCount': 1,
        'sessionStatus': SessionStatus.active.wireValue,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(now.add(const Duration(hours: 12))),
        'event': ?event,
      });
      batch.set(roomRef.collection('participants').doc(host), {
        'role': 'host',
        'joinedAt': Timestamp.fromDate(now),
      });
      await batch.commit();
      return Ok(roomRef.id);
    } on FirebaseException catch (e) {
      final fallback = switch (e.code) {
        'invalid-argument' => FailureCodes.roomCapacityInvalid,
        'failed-precondition' => e.message ?? FailureCodes.creatorUnresolved,
        _ => FailureCodes.createRoomFailed,
      };
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.createRoomFailed));
    }
  }

  Future<Result<void>> joinOpenRoom({
    required String roomsCollection,
    required String roomId,
    required String userId,
  }) async {
    try {
      final uid = userId.trim();
      if (uid.isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'failed-precondition',
          message: FailureCodes.creatorUnresolved,
        );
      }
      final now = DateTime.now();
      final roomRef = _firestore.collection(roomsCollection).doc(roomId);
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(roomRef);
        final data = snap.data();
        if (!snap.exists || data == null) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: FailureCodes.roomNotFound,
          );
        }
        if (data['type'] != 'open') {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: FailureCodes.roomNotOpen,
          );
        }
        final status = SessionStatus.fromWireValue(data['sessionStatus']);
        if (!status.isActive) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: FailureCodes.sessionAlreadyEnded,
          );
        }
        final expiresAt = data['expiresAt'];
        if (expiresAt is Timestamp && expiresAt.toDate().isBefore(now)) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: FailureCodes.roomNotFound,
          );
        }
        final participants = List<String>.from(
          data['participants'] ?? const <String>[],
        );
        if (participants.contains(uid)) return;
        final capacity = (data['capacity'] as num?)?.toInt() ?? 2;
        if (participants.length >= capacity) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'already-exists',
            message: FailureCodes.roomFull,
          );
        }
        participants.add(uid);
        tx.update(roomRef, {
          'participants': participants,
          'participantCount': participants.length,
          'updatedAt': Timestamp.fromDate(now),
        });
        tx.set(roomRef.collection('participants').doc(uid), {
          'role': 'member',
          'joinedAt': Timestamp.fromDate(now),
        });
      });
      return const Ok(null);
    } on FirebaseException catch (e) {
      final fallback = switch (e.code) {
        'not-found' => FailureCodes.roomNotFound,
        'already-exists' => FailureCodes.roomFull,
        'failed-precondition' => e.message ?? FailureCodes.roomNotOpen,
        _ => FailureCodes.joinRoomFailed,
      };
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.joinRoomFailed));
    }
  }

  Future<Result<List<QueryDocumentSnapshot<Map<String, dynamic>>>>>
  listOpenRooms({required String roomsCollection, int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection(roomsCollection)
          .where('type', isEqualTo: 'open')
          .where('visibility', isEqualTo: 'public')
          .where('sessionStatus', isEqualTo: 'active')
          .orderBy('updatedAt', descending: true)
          .limit(limit)
          .get();
      return Ok(snapshot.docs);
    } on FirebaseException catch (e) {
      return Err(
        _mapFirestoreFailure(e, fallback: FailureCodes.roomStreamFailed),
      );
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.roomStreamFailed));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchParticipants({
    required String roomsCollection,
    required String roomId,
  }) {
    return _firestore
        .collection(roomsCollection)
        .doc(roomId)
        .collection('participants')
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchRoom({
    required String roomsCollection,
    required String roomId,
  }) {
    return _firestore.collection(roomsCollection).doc(roomId).snapshots();
  }
}
