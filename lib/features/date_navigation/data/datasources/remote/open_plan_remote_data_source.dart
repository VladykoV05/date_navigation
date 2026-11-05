import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../domain/entities/open_plan.dart';

class OpenPlanRemoteDataSource {
  OpenPlanRemoteDataSource(this._firestore, {this.roomsCollection = 'rooms'});

  final FirebaseFirestore _firestore;
  final String roomsCollection;

  Stream<List<PlaceSuggestion>> watchSuggestions(String roomId) {
    return _firestore
        .collection(roomsCollection)
        .doc(roomId)
        .collection('suggestions')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => _fromDoc(doc.id, doc.data()))
              .whereType<PlaceSuggestion>()
              .toList(growable: false),
        );
  }

  static PlaceSuggestion? _fromDoc(String id, Map<String, dynamic> data) {
    final name = (data['placeName'] as String?)?.trim();
    final lat = (data['lat'] as num?)?.toDouble();
    final lon = (data['lon'] as num?)?.toDouble();
    final proposedBy = data['proposedBy'] as String?;
    if (name == null || name.isEmpty || lat == null || lon == null) return null;
    if (proposedBy == null || proposedBy.isEmpty) return null;
    final address = (data['placeAddress'] as String?)?.trim();
    final createdAt = data['createdAt'];
    return PlaceSuggestion(
      id: id,
      placeName: name,
      placeAddress: address == null || address.isEmpty ? null : address,
      lat: lat,
      lon: lon,
      proposedBy: proposedBy,
      status: SuggestionStatus.fromWireValue(data['status']),
      createdAt: createdAt is Timestamp ? createdAt.toDate() : null,
    );
  }

  Future<Result<void>> suggestPlace({
    required String roomId,
    required String userId,
    required String name,
    String? address,
    required double lat,
    required double lon,
  }) async {
    try {
      final roomRef = _firestore.collection(roomsCollection).doc(roomId);
      final participantRef = roomRef.collection('participants').doc(userId);
      final suggestionRef = roomRef.collection('suggestions').doc();
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(participantRef);
        final data = snap.data() ?? <String, dynamic>{};
        final start = data['suggestionWindowStart'];
        final count = (data['suggestionCount'] as num?)?.toInt() ?? 0;
        final windowActive =
            start is Timestamp &&
            DateTime.now().isBefore(
              start.toDate().add(const Duration(hours: 1)),
            );
        if (windowActive && count >= suggestionsPerHourLimit) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'resource-exhausted',
            message: FailureCodes.suggestionLimit,
          );
        }
        tx.set(suggestionRef, {
          'placeName': name,
          'placeAddress': address,
          'lat': lat,
          'lon': lon,
          'proposedBy': userId,
          'status': SuggestionStatus.suggested.wireValue,
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (windowActive) {
          tx.update(participantRef, {
            'suggestionCount': count + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          tx.update(participantRef, {
            'suggestionWindowStart': FieldValue.serverTimestamp(),
            'suggestionCount': 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
      return const Ok(null);
    } on FirebaseException catch (e) {
      return Err(
        UnknownFailure(
          e.code == 'resource-exhausted'
              ? FailureCodes.suggestionLimit
              : FailureCodes.planSaveFailed,
        ),
      );
    }
  }

  Future<Result<void>> chooseSuggestion({
    required String roomId,
    required String suggestionId,
    required String placeName,
    String? placeAddress,
    required double lat,
    required double lon,
    required String hostUid,
  }) async {
    try {
      final roomRef = _firestore.collection(roomsCollection).doc(roomId);
      final batch = _firestore.batch();
      batch.update(roomRef.collection('suggestions').doc(suggestionId), {
        'status': SuggestionStatus.chosen.wireValue,
        'chosenAt': FieldValue.serverTimestamp(),
      });
      batch.update(roomRef, {
        'nextStep': {
          'name': placeName,
          'address': placeAddress,
          'lat': lat,
          'lon': lon,
          'chosenBy': hostUid,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
      return const Ok(null);
    } on FirebaseException {
      return const Err(UnknownFailure(FailureCodes.planSaveFailed));
    }
  }

  Future<Result<void>> setPlanRadius({
    required String roomId,
    required int meters,
  }) async {
    try {
      await _firestore.collection(roomsCollection).doc(roomId).update({
        'planRadiusMeters': meters,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Ok(null);
    } on FirebaseException {
      return const Err(UnknownFailure(FailureCodes.planSaveFailed));
    }
  }
}
