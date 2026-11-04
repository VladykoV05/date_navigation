import '../../../../core/error/result.dart';
import '../repositories/room_meeting_format_repository.dart';

class SaveSearchRadius {
  const SaveSearchRadius(this._repository);

  final RoomMeetingFormatRepository _repository;

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required int radius,
  }) {
    return _repository.saveSearchRadius(
      roomId: roomId,
      userId: userId,
      radius: radius,
    );
  }
}
