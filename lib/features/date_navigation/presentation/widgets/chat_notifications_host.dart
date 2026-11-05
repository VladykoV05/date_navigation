import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_services_di.dart';
import '../../../../core/di/auth_di.dart';
import '../../application/services/chat_notification_coordinator.dart';
import '../../di/date_navigation_di.dart';
import '../providers/date_navigation_provider.dart';

class ChatNotificationsHost extends ConsumerStatefulWidget {
  const ChatNotificationsHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ChatNotificationsHost> createState() =>
      _ChatNotificationsHostState();
}

class _ChatNotificationsHostState extends ConsumerState<ChatNotificationsHost> {
  late final ChatNotificationCoordinator _coordinator;
  String? _currentKey;

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(localNotificationServiceProvider).init());
    _coordinator = ChatNotificationCoordinator(
      chatRepository: ref.read(chatRepositoryProvider),
      notifications: ref.read(localNotificationServiceProvider),
      isAppActive: () =>
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _sync(
        ref.read(dateNavigationControllerProvider).room.roomId,
        ref.read(currentUserProvider).value?.uid,
      );
    });
  }

  @override
  void dispose() {
    _coordinator.stop();
    super.dispose();
  }

  void _sync(String? roomId, String? userId) {
    if (roomId == null || userId == null) {
      _currentKey = null;
      _coordinator.stop();
      return;
    }
    final key = '$roomId:$userId';
    if (key == _currentKey) return;
    _currentKey = key;
    _coordinator.start(roomId: roomId, userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      dateNavigationControllerProvider.select((state) => state.room.roomId),
      (_, next) => _sync(next, ref.read(currentUserProvider).value?.uid),
    );
    ref.listen<String?>(
      currentUserProvider.select((state) => state.value?.uid),
      (_, next) =>
          _sync(ref.read(dateNavigationControllerProvider).room.roomId, next),
    );
    return widget.child;
  }
}
