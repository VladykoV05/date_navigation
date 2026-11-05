import '../../../../core/error/result.dart';
import '../entities/room_snapshot.dart';

abstract interface class EventSource {
  Future<Result<List<RoomEventSnapshot>>> searchEvents({
    String? category,
    int limit = 10,
  });
}
