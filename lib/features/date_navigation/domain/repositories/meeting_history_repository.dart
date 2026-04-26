import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class MeetingHistoryRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchRecentHistory({
    required String userId,
    int limit = 10,
  });
}
