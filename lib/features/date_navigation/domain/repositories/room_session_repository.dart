import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';

abstract interface class RoomSessionRepository {
  Future<Result<void>> createRoom(String code, {String? createdBy});
  Future<Result<void>> joinRoom({
    required String roomId,
    required String userId,
  });

  Future<Result<void>> updateLocation({
    required String roomId,
    required String userId,
    required latlong.LatLng coords,
  });

  Future<Result<void>> completeSession({
    required String roomId,
    required String userId,
  });

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchRoom(String roomId);
}
