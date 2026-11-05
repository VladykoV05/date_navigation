import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../di/date_navigation_di.dart';

final openSessionsProvider = FutureProvider.autoDispose<List<RoomSnapshot>>((
  ref,
) async {
  final result = await ref.watch(roomSessionRepositoryProvider).listOpenRooms();
  return switch (result) {
    Ok(:final value) =>
      value
          .where(
            (room) =>
                room.expiresAt == null ||
                room.expiresAt!.isAfter(DateTime.now()),
          )
          .toList(growable: false),
    Err(:final failure) => throw failure,
  };
});
