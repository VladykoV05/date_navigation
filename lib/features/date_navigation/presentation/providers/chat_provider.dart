import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat_message.dart';
import '../../di/date_navigation_di.dart';

final chatMessagesProvider = StreamProvider.autoDispose
    .family<List<ChatMessage>, String>((ref, roomId) {
      return ref.watch(chatRepositoryProvider).watchMessages(roomId);
    });
