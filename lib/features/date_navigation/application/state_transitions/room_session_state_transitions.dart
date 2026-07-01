import '../../../../core/error/failure.dart';
import '../state/date_navigation_state.dart';

class RoomSessionStateTransitions {
  const RoomSessionStateTransitions();

  DateNavigationState afterCreateSuccess(
    DateNavigationState state, {
    required String roomId,
    required String inviteCode,
  }) {
    return state.copyWith(
      room: state.room.copyWith(
        roomId: roomId,
        inviteCode: inviteCode,
        isCreator: true,
      ),
      ui: state.ui.copyWith(isLoadingRoomAction: false),
    );
  }

  DateNavigationState afterJoinSuccess(
    DateNavigationState state, {
    required String roomId,
    required String inviteCode,
  }) {
    return state.copyWith(
      room: state.room.copyWith(
        roomId: roomId,
        inviteCode: inviteCode,
        isCreator: false,
      ),
      ui: state.ui.copyWith(
        isLoadingRoomAction: false,
        lastFailure: null,
        failureOperation: null,
      ),
    );
  }

  Failure? validateCompleteSession(DateNavigationState state) {
    if (state.room.roomId == null || state.room.roomId!.isEmpty) return null;
    if (!state.room.isCreator) {
      return const UnknownFailure(
        'Завершить сессию может только создатель комнаты',
      );
    }
    return null;
  }

  DateNavigationState afterLeaveRoom(DateNavigationState state) {
    return DateNavigationState(addressMemory: state.addressMemory);
  }
}
