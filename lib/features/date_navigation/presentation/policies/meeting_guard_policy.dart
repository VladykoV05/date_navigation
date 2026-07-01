import '../../../../core/error/failure.dart';
import '../state/date_navigation_state.dart';

class MeetingGuardPolicy {
  const MeetingGuardPolicy();

  Failure? ensureSessionActive(DateNavigationState state) {
    if (!state.room.isClosed) return null;
    return const UnknownFailure(
      'Сессия комнаты уже завершена. Создай новую комнату.',
    );
  }

  Failure? ensureMeetingFormatMatched(DateNavigationState state) {
    if (state.meeting.selectedMeetingFormat != null) return null;
    return const UnknownFailure(
      'Сначала выберите финальный формат из общих вариантов с партнером, затем выбирайте место.',
    );
  }
}
