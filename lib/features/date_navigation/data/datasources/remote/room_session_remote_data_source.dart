import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/result.dart';
import '../../../domain/entities/room_status.dart';
import 'firestore_error_guard.dart';

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
          message: 'Не удалось определить создателя комнаты',
        );
      }
      final now = DateTime.now();
      final expiresAt = Timestamp.fromDate(now.add(const Duration(hours: 12)));
      final normalizedInviteCode = inviteCode.trim();
      if (normalizedInviteCode.isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'failed-precondition',
          message: 'Код комнаты пустой',
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
              message: 'Комната с таким кодом уже существует',
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
        'already-exists' => 'Комната с таким кодом уже существует',
        'failed-precondition' => 'Не удалось определить создателя комнаты',
        _ => 'Не удалось создать комнату',
      };
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return const Err(UnknownFailure('Не удалось создать комнату'));
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
          message: 'Комната не найдена',
        );
      }
      final inviteRef = _firestore
          .collection(invitesCollection)
          .doc(normalizedInviteCode);
      final inviteSnapshot = await inviteRef.get();
      if (!inviteSnapshot.exists) {
        // Backward compatibility: old rooms used short code as document id.
        return _joinLegacyRoomById(
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
            message: 'Комната не найдена',
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
            message: 'Комната не найдена',
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
            message: 'Комната не найдена',
          );
        }
        final data = snap.data() ?? <String, dynamic>{};
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
            message: 'Комната не найдена',
          );
        }

        if (creatorUid.isEmpty) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: 'Комната повреждена: нет creatorUid',
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
            message: 'Комната уже занята вторым участником',
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
        'not-found' => 'Комната не найдена',
        'already-exists' => 'В комнате уже есть второй участник',
        _ => 'Не удалось присоединиться к комнате',
      };
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return const Err(UnknownFailure('Не удалось присоединиться к комнате'));
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
            message: 'Комната не найдена',
          );
        }
        final data = snap.data() ?? <String, dynamic>{};
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
            message: 'Комната повреждена: нет creatorUid',
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
            message: 'Комната уже занята вторым участником',
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
        'not-found' => 'Комната не найдена',
        'already-exists' => 'В комнате уже есть второй участник',
        _ => 'Не удалось присоединиться к комнате',
      };
      return Err(_mapFirestoreFailure(e, fallback: fallback));
    } catch (_) {
      return const Err(UnknownFailure('Не удалось присоединиться к комнате'));
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
              message: 'Пользователь не является участником комнаты',
            );
          }
          tx.update(roomRef, {
            field: {'lat': coords.latitude, 'lng': coords.longitude},
          });
        });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось обновить координаты',
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
              message: 'Комната не найдена',
            );
          }
          final data = snap.data() ?? <String, dynamic>{};
          final creatorUid = ((data['creatorUid'] ?? data['createdBy']) ?? '')
              .toString();
          if (creatorUid.isEmpty || creatorUid != userId) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
              message: 'Только креатор может завершить сессию',
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
        'not-found' => 'Комната не найдена',
        'permission-denied' => 'Только креатор может завершить сессию',
        _ => 'Не удалось завершить сессию',
      },
      unknownFallback: 'Не удалось завершить сессию',
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchRoom({
    required String roomsCollection,
    required String roomId,
  }) {
    return _firestore.collection(roomsCollection).doc(roomId).snapshots();
  }
}
