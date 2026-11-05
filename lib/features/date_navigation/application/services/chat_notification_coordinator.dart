import 'dart:async';

import '../../../../core/notifications/local_notification_service.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatNotificationCoordinator {
  ChatNotificationCoordinator({
    required ChatRepository chatRepository,
    required LocalNotificationService notifications,
    required bool Function() isAppActive,
  }) : _chatRepository = chatRepository,
       _notifications = notifications,
       _isAppActive = isAppActive;

  final ChatRepository _chatRepository;
  final LocalNotificationService _notifications;
  final bool Function() _isAppActive;

  StreamSubscription<List<ChatMessage>>? _subscription;
  String? _roomId;
  String? _userId;
  String? _lastMessageId;

  void start({required String roomId, required String userId}) {
    if (_roomId == roomId && _userId == userId && _subscription != null) {
      return;
    }
    stop();
    _roomId = roomId;
    _userId = userId;
    _lastMessageId = null;
    _subscription = _chatRepository
        .watchMessages(roomId, limit: 20)
        .listen(_onMessages, onError: (_) {});
  }

  void stop() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    _roomId = null;
    _userId = null;
    _lastMessageId = null;
  }

  void _onMessages(List<ChatMessage> messages) {
    if (messages.isEmpty) return;
    final newest = messages.first;
    final previousId = _lastMessageId;
    _lastMessageId = newest.id;
    if (previousId == null || newest.id == previousId) return;
    if (newest.senderUid == _userId) return;
    if (_isAppActive()) return;
    final roomId = _roomId;
    if (roomId == null) return;
    unawaited(
      _notifications.showChatMessage(
        roomId: roomId,
        title: 'Sbor',
        body: newest.kind == ChatMessageKind.system
            ? 'Room update'
            : newest.text,
      ),
    );
  }
}
