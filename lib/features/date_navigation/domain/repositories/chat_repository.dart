import '../../../../core/error/result.dart';
import '../entities/chat_message.dart';

abstract interface class ChatRepository {
  Stream<List<ChatMessage>> watchMessages(String roomId, {int limit = 50});

  Future<Result<void>> sendMessage({
    required String roomId,
    required String senderUid,
    required String text,
    required String clientId,
  });

  Future<Result<void>> markRead({
    required String roomId,
    required String userId,
  });
}
