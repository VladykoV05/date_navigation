import '../state/date_navigation_state.dart';

class SearchRadiusPersistenceCommand {
  const SearchRadiusPersistenceCommand({
    required this.roomId,
    required this.radius,
  });

  final String roomId;
  final int radius;
}

class SearchRadiusPersistenceCommandBuilder {
  const SearchRadiusPersistenceCommandBuilder();

  SearchRadiusPersistenceCommand? buildCommand(DateNavigationState state) {
    final roomId = state.room.roomId;
    if (roomId == null || roomId.isEmpty) return null;
    return SearchRadiusPersistenceCommand(
      roomId: roomId,
      radius: state.meeting.searchRadius.round(),
    );
  }
}
