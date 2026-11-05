abstract interface class LocalNotificationService {
  Future<void> init();

  Future<void> showChatMessage({
    required String roomId,
    required String title,
    required String body,
  });
}
