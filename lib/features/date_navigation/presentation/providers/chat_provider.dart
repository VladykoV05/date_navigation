import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';

import '../../domain/entities/chat_message.dart';
import '../../di/date_navigation_di.dart';

final chatMessagesProvider = StreamProvider.autoDispose
    .family<List<ChatMessage>, String>((ref, roomId) {
      return ref.watch(chatRepositoryProvider).watchMessages(roomId);
    });

final chatLastReadProvider = StreamProvider.autoDispose
    .family<DateTime?, ({String roomId, String userId})>((ref, key) {
      return ref
          .watch(chatRepositoryProvider)
          .watchLastRead(roomId: key.roomId, userId: key.userId);
    });

final chatUnreadCountProvider = Provider.autoDispose.family<int, String>((
  ref,
  roomId,
) {
  final userId = ref.watch(authSessionProvider).currentUserId;
  if (userId == null) return 0;
  final messages = ref.watch(chatMessagesProvider(roomId)).value ?? const [];
  final lastRead = ref
      .watch(chatLastReadProvider((roomId: roomId, userId: userId)))
      .value;
  return messages
      .where(
        (message) =>
            message.senderUid != userId &&
            (lastRead == null ||
                (message.createdAt?.isAfter(lastRead) ?? false)),
      )
      .length;
});
