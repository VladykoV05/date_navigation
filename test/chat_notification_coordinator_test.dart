import 'dart:async';

import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/core/notifications/local_notification_service.dart';
import 'package:date_navigation/features/date_navigation/application/services/chat_notification_coordinator.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/chat_message.dart';
import 'package:date_navigation/features/date_navigation/domain/repositories/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeChatRepository implements ChatRepository {
  final controller = StreamController<List<ChatMessage>>.broadcast();

  @override
  Stream<List<ChatMessage>> watchMessages(String roomId, {int limit = 50}) {
    return controller.stream;
  }

  @override
  Future<Result<List<ChatMessage>>> fetchMessages({
    required String roomId,
    required int limit,
    DateTime? before,
  }) async {
    return const Ok([]);
  }

  @override
  Stream<DateTime?> watchLastRead({
    required String roomId,
    required String userId,
  }) {
    return Stream.value(null);
  }

  @override
  Future<Result<void>> sendMessage({
    required String roomId,
    required String senderUid,
    required String text,
    required String clientId,
  }) async {
    return const Ok(null);
  }

  @override
  Future<Result<void>> sendSystemMessage({
    required String roomId,
    required String senderUid,
    required String code,
  }) async {
    return const Ok(null);
  }

  @override
  Future<Result<void>> markRead({
    required String roomId,
    required String userId,
  }) async {
    return const Ok(null);
  }
}

class _FakeNotificationService implements LocalNotificationService {
  final messages = <String>[];

  @override
  Future<void> init() async {}

  @override
  Future<void> showChatMessage({
    required String roomId,
    required String title,
    required String body,
  }) async {
    messages.add(body);
  }
}

ChatMessage _message(String id, String sender) {
  return ChatMessage(id: id, senderUid: sender, text: 'text-$id');
}

void main() {
  test(
    'notifies only for new messages from others while app is inactive',
    () async {
      final repository = _FakeChatRepository();
      final notifications = _FakeNotificationService();
      var active = false;
      final coordinator = ChatNotificationCoordinator(
        chatRepository: repository,
        notifications: notifications,
        isAppActive: () => active,
      );
      coordinator.start(roomId: 'room-1', userId: 'me');

      repository.controller.add([_message('m1', 'partner')]);
      await Future<void>.delayed(Duration.zero);
      expect(notifications.messages, isEmpty);

      repository.controller.add([
        _message('m2', 'partner'),
        _message('m1', 'partner'),
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(notifications.messages, ['text-m2']);

      repository.controller.add([
        _message('m3', 'me'),
        _message('m2', 'partner'),
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(notifications.messages, ['text-m2']);

      active = true;
      repository.controller.add([
        _message('m4', 'partner'),
        _message('m3', 'me'),
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(notifications.messages, ['text-m2']);

      coordinator.stop();
      await repository.controller.close();
    },
  );
}
