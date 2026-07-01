import '../../../../core/error/result.dart';
import '../repositories/meeting_history_repository.dart';

class RecordMeetingHistory {
  const RecordMeetingHistory(this._repo);

  final MeetingHistoryRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required String placeName,
    required List<String> participantIds,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    return _repo.recordMeetingHistory(
      roomId: roomId,
      placeName: placeName,
      participantIds: participantIds,
      placeAddress: placeAddress,
      placeType: placeType,
      lat: lat,
      lon: lon,
    );
  }
}
