import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/meeting_history_item.dart';
import '../../mappers/meeting_history_mapper.dart';

class UserMeetingHistoryRemoteDataSource {
  const UserMeetingHistoryRemoteDataSource(this._firestore);

  static const _usersCollection = 'users';
  static const _meetingHistoryCollection = 'meeting_history';

  final FirebaseFirestore _firestore;

  Stream<List<MeetingHistoryItem>> watchRecentHistory({
    required String userId,
    int limit = 10,
  }) {
    return _userCollection(userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(MeetingHistoryMapper.fromDoc)
              .where((item) => item.placeName.isNotEmpty)
              .toList(growable: false),
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
  }) async {
    final normalizedPlaceName = placeName.trim();
    if (normalizedPlaceName.isEmpty || participantIds.isEmpty) return;

    final normalizedParticipantIds = participantIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (normalizedParticipantIds.isEmpty) return;

    final batch = _firestore.batch();
    for (final userId in normalizedParticipantIds) {
      final counterpartyUid = normalizedParticipantIds.firstWhere(
        (id) => id != userId,
        orElse: () => '',
      );
      final historyRef = _userCollection(userId).doc(roomId);
      batch.set(historyRef, {
        'roomId': roomId,
        'placeName': normalizedPlaceName,
        if (placeAddress != null && placeAddress.trim().isNotEmpty)
          'placeAddress': placeAddress.trim(),
        if (placeType != null && placeType.trim().isNotEmpty)
          'placeType': placeType.trim(),
        'lat': ?lat,
        'lon': ?lon,
        'createdAt': FieldValue.serverTimestamp(),
        'counterpartyUid': counterpartyUid,
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  CollectionReference<Map<String, dynamic>> _userCollection(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_meetingHistoryCollection);
  }
}
