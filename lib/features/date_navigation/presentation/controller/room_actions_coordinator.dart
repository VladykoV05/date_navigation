import '../../../../core/error/failure.dart';
import '../state/date_navigation_state.dart';

class RoomActionsCoordinator {
  const RoomActionsCoordinator();

  DateNavigationState afterCreateSuccess(
    DateNavigationState state, {
    required String roomId,
  }) {
    return state.copyWith(
      roomId: roomId,
      isCreator: true,
      isLoadingRoomAction: false,
    );
  }

  DateNavigationState afterJoinSuccess(
    DateNavigationState state, {
    required String roomId,
  }) {
    return state.copyWith(
      roomId: roomId,
      isCreator: false,
      isLoadingRoomAction: false,
      errorMessage: null,
      failureOperation: null,
    );
  }

  Failure? validateCompleteSession(DateNavigationState state) {
    if (state.roomId == null || state.roomId!.isEmpty) return null;
    if (!state.isCreator) {
      return const UnknownFailure(
        'Завершить сессию может только создатель комнаты',
      );
    }
    return null;
  }

  DateNavigationState afterLeaveRoom(DateNavigationState state) {
    return DateNavigationState(recentAddresses: state.recentAddresses);
  }
}
