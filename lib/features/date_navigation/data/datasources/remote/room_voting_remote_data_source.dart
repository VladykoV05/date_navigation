import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/result.dart';
import '../../../domain/entities/voting_decisions.dart';
import 'firestore_error_guard.dart';

class RoomVotingRemoteDataSource {
  const RoomVotingRemoteDataSource(
    this._firestore,
    this._mapFirestoreFailure, {
    required List<String> Function({
      required String creatorUid,
      required String partnerUid,
      required List<String> participants,
      required String actedByUserId,
    })
    normalizeParticipants,
  }) : _normalizeParticipants = normalizeParticipants;

  final FirebaseFirestore _firestore;
  final Failure Function(FirebaseException e, {required String fallback})
  _mapFirestoreFailure;
  final List<String> Function({
    required String creatorUid,
    required String partnerUid,
    required List<String> participants,
    required String actedByUserId,
  })
  _normalizeParticipants;

  Future<Result<void>> voteForPlace({
    required String roomsCollection,
    required String roomId,
    required String userId,
    required String placeName,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
      final roomRef = _firestore.collection(roomsCollection).doc(roomId);
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(roomRef);
        final data = snap.data() ?? <String, dynamic>{};
        final finalChoice = (data['finalChoice'] ?? '').toString();
        if (finalChoice.isNotEmpty) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: 'Голосование закрыто после финального выбора',
          );
        }
        final participants = List<String>.from(
          data['participants'] ?? const <String>[],
        );
        if (!participants.contains(userId)) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message: 'Только участники комнаты могут голосовать',
          );
        }
        tx.update(roomRef, {'votes.$userId': placeName});
      });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось проголосовать',
    );
  }

  Future<Result<void>> proposePlace({
    required String roomsCollection,
    required String roomId,
    required String placeName,
    required ProposalAuthorRole authorRole,
    required double lat,
    required double lon,
    String? placeAddress,
    String? placeType,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
      final roomRef = _firestore.collection(roomsCollection).doc(roomId);
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(roomRef);
        final data = snap.data() ?? <String, dynamic>{};
        if ((data['finalChoice'] ?? '').toString().isNotEmpty) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: 'Финальное место уже выбрано',
          );
        }
        tx.update(roomRef, {
          'proposal': {
            'placeName': placeName,
            'lat': lat,
            'lon': lon,
            if (placeAddress != null && placeAddress.isNotEmpty)
              'placeAddress': placeAddress,
            if (placeType != null && placeType.isNotEmpty)
              'placeType': placeType,
            'proposedBy': authorRole.wireValue,
            'status': 'pending',
          },
        });
      });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось предложить место',
    );
  }

  Future<Result<void>> respondToProposal({
    required String roomsCollection,
    required String usersCollection,
    required String roomId,
    required ProposalResponseDecision decision,
    required String actedByUserId,
  }) async {
    final isAccepted = decision.isAccepted;
    final roomRef = _firestore.collection(roomsCollection).doc(roomId);
    String? acceptedPlaceName;
    List<String> acceptedParticipantIds = const [];
    String? acceptedPlaceAddress;
    String? acceptedPlaceType;
    double? acceptedLat;
    double? acceptedLon;
    return FirestoreErrorGuard.runVoid(
      () async {
        await _firestore.runTransaction((tx) async {
          final snap = await tx.get(roomRef);
          final data = snap.data() ?? <String, dynamic>{};
          final proposal = Map<String, dynamic>.from(data['proposal'] ?? {});
          final placeName = (proposal['placeName'] ?? '').toString();
          if (placeName.isEmpty) return;
          final proposalStatus = (proposal['status'] ?? 'pending').toString();
          final currentFinalChoice = (data['finalChoice'] ?? '').toString();
          if (currentFinalChoice.isNotEmpty || proposalStatus != 'pending') {
            return;
          }

          if (isAccepted) {
            final creatorUid = ((data['creatorUid'] ?? data['createdBy']) ?? '')
                .toString();
            final partnerUid = (data['partnerUid'] ?? '').toString();
            final participants = List<String>.from(
              data['participants'] ?? const <String>[],
            );
            final participantIds = _normalizeParticipants(
              creatorUid: creatorUid,
              partnerUid: partnerUid,
              participants: participants,
              actedByUserId: actedByUserId,
            );

            final pLat = (proposal['lat'] as num?)?.toDouble();
            final pLon = (proposal['lon'] as num?)?.toDouble();
            final pAddr = proposal['placeAddress']?.toString();
            final pType = proposal['placeType']?.toString();

            final update = <String, dynamic>{
              'finalChoice': placeName,
              'proposal.status': 'accepted',
            };
            if (pLat != null && pLon != null) {
              update['finalChoiceLat'] = pLat;
              update['finalChoiceLon'] = pLon;
            }
            if (pAddr != null && pAddr.isNotEmpty) {
              update['finalChoiceAddress'] = pAddr;
            }
            if (pType != null && pType.isNotEmpty) {
              update['finalChoiceType'] = pType;
            }

            tx.update(roomRef, update);
            acceptedPlaceName = placeName;
            acceptedParticipantIds = participantIds;
            acceptedPlaceAddress = pAddr;
            acceptedPlaceType = pType;
            acceptedLat = pLat;
            acceptedLon = pLon;
          } else {
            tx.update(roomRef, {'proposal.status': 'rejected'});
          }
        });

        if (isAccepted &&
            acceptedPlaceName != null &&
            acceptedPlaceName!.isNotEmpty &&
            acceptedParticipantIds.isNotEmpty) {
          await _appendMeetingHistoryEntries(
            usersCollection: usersCollection,
            roomId: roomId,
            placeName: acceptedPlaceName!,
            participantIds: acceptedParticipantIds,
            placeAddress: acceptedPlaceAddress,
            placeType: acceptedPlaceType,
            lat: acceptedLat,
            lon: acceptedLon,
          );
        }
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось ответить на предложение',
    );
  }

  Future<void> _appendMeetingHistoryEntries({
    required String usersCollection,
    required String roomId,
    required String placeName,
    required List<String> participantIds,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) async {
    final batch = _firestore.batch();
    for (final userId in participantIds) {
      final counterpartyUid = participantIds.firstWhere(
        (id) => id != userId,
        orElse: () => '',
      );
      final historyRef = _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('meeting_history')
          .doc(roomId);
      batch.set(historyRef, {
        'roomId': roomId,
        'placeName': placeName,
        if (placeAddress != null && placeAddress.trim().isNotEmpty)
          'placeAddress': placeAddress.trim(),
        if (placeType != null && placeType.trim().isNotEmpty)
          'placeType': placeType.trim(),
        if (lat != null) 'lat': lat,
        if (lon != null) 'lon': lon,
        'createdAt': FieldValue.serverTimestamp(),
        'counterpartyUid': counterpartyUid,
      }, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<Result<void>> saveMeetingSnapshot({
    required String roomsCollection,
    required String roomId,
    required latlong.LatLng centerPoint,
    required List<latlong.LatLng> routePoints,
    required List<Map<String, dynamic>> places,
    required int searchRadius,
    required String meetingFormat,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
      final normalizedRoutePoints = routePoints
          .map((p) => {'lat': p.latitude, 'lng': p.longitude})
          .toList(growable: false);
      final normalizedPlaces = List<Map<String, dynamic>>.from(places)
        ..sort((a, b) {
          final byName = (a['name'] ?? '').toString().compareTo(
            (b['name'] ?? '').toString(),
          );
          if (byName != 0) return byName;
          final byLat = ((a['lat'] as num?)?.toDouble() ?? 0.0).compareTo(
            (b['lat'] as num?)?.toDouble() ?? 0.0,
          );
          if (byLat != 0) return byLat;
          return ((a['lon'] as num?)?.toDouble() ?? 0.0).compareTo(
            (b['lon'] as num?)?.toDouble() ?? 0.0,
          );
        });
      await _firestore.collection(roomsCollection).doc(roomId).update({
        'meetingSnapshot': {
          'center': {'lat': centerPoint.latitude, 'lng': centerPoint.longitude},
          'routePoints': normalizedRoutePoints,
          'places': normalizedPlaces,
          'searchRadius': searchRadius,
          'meetingFormat': meetingFormat,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось синхронизировать результаты',
    );
  }

  Future<Result<void>> saveSelectedScenario({
    required String roomsCollection,
    required String roomId,
    required Map<String, dynamic> scenario,
    required String selectedByUserId,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
      await _firestore.collection(roomsCollection).doc(roomId).update({
        'selectedScenario': {
          ...scenario,
          'selectedByUserId': selectedByUserId,
          'selectedAt': FieldValue.serverTimestamp(),
        },
      });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось сохранить сценарий встречи',
    );
  }

  Future<Result<void>> saveMeetingFormats({
    required String roomsCollection,
    required String roomId,
    required String userId,
    required List<String> formats,
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
            ? 'creatorMeetingFormat'
            : (userId == partnerUid ? 'partnerMeetingFormat' : null);
        if (field == null) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message: 'Только участники комнаты могут выбрать формат встречи',
          );
        }
        final updatedAtField = userId == creatorUid
            ? 'creatorMeetingFormatUpdatedAt'
            : 'partnerMeetingFormatUpdatedAt';
        final selectedField = userId == creatorUid
            ? 'creatorSelectedMeetingFormat'
            : 'partnerSelectedMeetingFormat';
        final uniqueFormats = <String>{
          for (final value in formats)
            value.trim().toLowerCase().replaceAll(' ', '_'),
        }.where((value) => value.isNotEmpty).toList(growable: false)
          ..sort();
        final currentSelected = (data[selectedField] ?? '')
            .toString()
            .trim()
            .toLowerCase()
            .replaceAll(' ', '_');
        tx.update(roomRef, {
          field: uniqueFormats.isEmpty ? null : uniqueFormats.first,
          '${field}s': uniqueFormats,
          updatedAtField: FieldValue.serverTimestamp(),
          if (currentSelected.isNotEmpty && !uniqueFormats.contains(currentSelected))
            selectedField: FieldValue.delete(),
          'selectedMeetingFormat': FieldValue.delete(), // legacy field
        });
      });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось сохранить формат встречи',
    );
  }

  Future<Result<void>> requestMeetingRevote({
    required String roomsCollection,
    required String roomId,
    required String userId,
    required List<String> formats,
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
        final requestByRole = userId == creatorUid
            ? 'creator'
            : (userId == partnerUid ? 'partner' : null);
        if (requestByRole == null) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message:
                'Только участники комнаты могут запрашивать пересогласование',
          );
        }
        final currentRequest = Map<String, dynamic>.from(
          data['meetingRevoteRequest'] ?? const <String, dynamic>{},
        );
        final requestStatus = (currentRequest['status'] ?? '').toString();
        if (requestStatus == 'pending') {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: 'Запрос на пересогласование уже отправлен',
          );
        }
        final uniqueFormats = <String>{
          for (final value in formats)
            value.trim().toLowerCase().replaceAll(' ', '_'),
        }.where((value) => value.isNotEmpty).toList(growable: false)
          ..sort();
        final creatorFormats = requestByRole == 'creator'
            ? uniqueFormats
            : List<String>.from(data['creatorMeetingFormats'] ?? const <String>[]);
        final partnerFormats = requestByRole == 'partner'
            ? uniqueFormats
            : List<String>.from(data['partnerMeetingFormats'] ?? const <String>[]);
        tx.update(roomRef, {
          'meetingRevoteRequest': {
            'status': 'pending',
            'requestedBy': requestByRole,
            'creatorFormats': creatorFormats,
            'partnerFormats': partnerFormats,
            'requestedAt': FieldValue.serverTimestamp(),
          },
        });
      });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось запросить пересогласование',
    );
  }

  Future<Result<void>> respondMeetingRevote({
    required String roomsCollection,
    required String roomId,
    required String userId,
    required MeetingRevoteResponseDecision decision,
  }) async {
    final isAccepted = decision.isAccepted;
    return FirestoreErrorGuard.runVoid(
      () async {
      final roomRef = _firestore.collection(roomsCollection).doc(roomId);
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(roomRef);
        final data = snap.data() ?? <String, dynamic>{};
        final creatorUid = ((data['creatorUid'] ?? data['createdBy']) ?? '')
            .toString();
        final partnerUid = (data['partnerUid'] ?? '').toString();
        final myRole = userId == creatorUid
            ? 'creator'
            : (userId == partnerUid ? 'partner' : null);
        if (myRole == null) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message:
                'Только участники комнаты могут отвечать на пересогласование',
          );
        }
        final request = Map<String, dynamic>.from(
          data['meetingRevoteRequest'] ?? const <String, dynamic>{},
        );
        final status = (request['status'] ?? '').toString();
        final requestedBy = (request['requestedBy'] ?? '').toString();
        if (status != 'pending' || requestedBy.isEmpty) return;
        if (requestedBy == myRole) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'failed-precondition',
            message: 'Нельзя подтвердить собственный запрос',
          );
        }
        if (!isAccepted) {
          tx.update(roomRef, {'meetingRevoteRequest': FieldValue.delete()});
          return;
        }
        final creatorFormats = List<String>.from(
          request['creatorFormats'] ?? const <String>[],
        );
        final partnerFormats = List<String>.from(
          request['partnerFormats'] ?? const <String>[],
        );
        tx.update(roomRef, {
          'creatorMeetingFormats': creatorFormats,
          'creatorMeetingFormat': creatorFormats.isEmpty ? null : creatorFormats.first,
          'partnerMeetingFormats': partnerFormats,
          'partnerMeetingFormat': partnerFormats.isEmpty ? null : partnerFormats.first,
          'creatorMeetingFormatUpdatedAt': FieldValue.serverTimestamp(),
          'partnerMeetingFormatUpdatedAt': FieldValue.serverTimestamp(),
          'creatorSelectedMeetingFormat': FieldValue.delete(),
          'partnerSelectedMeetingFormat': FieldValue.delete(),
          'selectedMeetingFormat': FieldValue.delete(),
          'meetingRevoteRequest': FieldValue.delete(),
        });
      });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось обработать запрос пересогласования',
    );
  }

  Future<Result<void>> saveSelectedMeetingFormat({
    required String roomsCollection,
    required String roomId,
    required String userId,
    required String format,
  }) async {
    final normalized = format.trim();
    if (normalized.isEmpty) {
      return const Err(UnknownFailure('Не выбран финальный формат встречи'));
    }
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
              ? 'creatorSelectedMeetingFormat'
              : (userId == partnerUid ? 'partnerSelectedMeetingFormat' : null);
          if (field == null) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
              message: 'Только участники комнаты могут подтвердить формат',
            );
          }
          tx.update(roomRef, {
            field: normalized,
            'selectedMeetingFormat': FieldValue.delete(), // legacy field
          });
        });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось подтвердить формат встречи',
    );
  }

  Future<Result<void>> saveSearchRadius({
    required String roomsCollection,
    required String roomId,
    required String userId,
    required int radius,
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
            ? 'creatorSearchRadius'
            : (userId == partnerUid ? 'partnerSearchRadius' : null);
        if (field == null) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message: 'Только участники комнаты могут менять радиус',
          );
        }
        final updatedAtField = userId == creatorUid
            ? 'creatorSearchRadiusUpdatedAt'
            : 'partnerSearchRadiusUpdatedAt';
        tx.update(roomRef, {
          field: radius,
          updatedAtField: FieldValue.serverTimestamp(),
        });
      });
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось сохранить радиус поиска',
    );
  }
}
