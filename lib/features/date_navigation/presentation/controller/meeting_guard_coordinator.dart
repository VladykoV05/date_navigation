import '../../../../core/error/failure.dart';
import '../state/date_navigation_state.dart';

class MeetingGuardCoordinator {
  const MeetingGuardCoordinator();

  Failure? ensureSessionActive(DateNavigationState state) {
    if (!state.roomSession.isClosed) return null;
    return const UnknownFailure(
      'Сессия комнаты уже завершена. Создай новую комнату.',
    );
  }

  Failure? ensureMeetingFormatMatched(DateNavigationState state) {
    if (state.selectedMeetingFormat != null) return null;
    return const UnknownFailure(
      'Сначала выберите финальный формат из общих вариантов с партнером, затем выбирайте место.',
    );
  }
}
