import '../../state/date_navigation_state.dart';

class SearchRadiusPersistenceCommand {
  const SearchRadiusPersistenceCommand({
    required this.roomId,
    required this.radius,
  });

  final String roomId;
  final int radius;
}

class SearchRadiusPersistenceCoordinator {
  const SearchRadiusPersistenceCoordinator();

  SearchRadiusPersistenceCommand? buildCommand(DateNavigationState state) {
    final roomId = state.roomId;
    if (roomId == null || roomId.isEmpty) return null;
    return SearchRadiusPersistenceCommand(
      roomId: roomId,
      radius: state.searchRadius.round(),
    );
  }
}
