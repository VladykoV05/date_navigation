import '../../../../core/error/failure.dart';
import '../../domain/entities/date_vibe.dart';

class MeetingGuardPolicy {
  const MeetingGuardPolicy();

  Failure? ensureSessionActive({required bool isSessionClosed}) {
    if (!isSessionClosed) return null;
    return const UnknownFailure(
      'Сессия комнаты уже завершена. Создай новую комнату.',
    );
  }

  Failure? ensureMeetingFormatMatched({
    required MeetingFormat? selectedMeetingFormat,
  }) {
    if (selectedMeetingFormat != null) return null;
    return const UnknownFailure(
      'Сначала выберите финальный формат из общих вариантов с партнером, затем выбирайте место.',
    );
  }
}
