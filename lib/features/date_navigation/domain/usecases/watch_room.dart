import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/room_session_repository.dart';

class WatchRoom {
  final RoomSessionRepository _repo;
  const WatchRoom(this._repo);

  Stream<DocumentSnapshot<Map<String, dynamic>>> call(String roomId) {
    return _repo.watchRoom(roomId);
  }
}
