import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/meeting_history_item.dart';

class MeetingHistoryMapper {
  const MeetingHistoryMapper._();

  static MeetingHistoryItem fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return MeetingHistoryItem(
      id: doc.id,
      placeName: (data['placeName'] ?? '').toString(),
      placeAddress: data['placeAddress']?.toString(),
      placeType: data['placeType']?.toString(),
      lat: (data['lat'] as num?)?.toDouble(),
      lon: (data['lon'] as num?)?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      roomId: data['roomId']?.toString(),
      counterpartyUid: data['counterpartyUid']?.toString(),
    );
  }
}
