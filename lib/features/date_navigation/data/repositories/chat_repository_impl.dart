import '../../../../core/error/result.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._remote);

  final ChatRemoteDataSource _remote;

  @override
  Stream<List<ChatMessage>> watchMessages(String roomId, {int limit = 50}) {
    return _remote.watchMessages(roomId, limit: limit);
  }

  @override
  Future<Result<void>> sendMessage({
    required String roomId,
    required String senderUid,
    required String text,
    required String clientId,
  }) {
    return _remote.sendMessage(
      roomId: roomId,
      senderUid: senderUid,
      text: text,
      clientId: clientId,
    );
  }

  @override
  Future<Result<void>> markRead({
    required String roomId,
    required String userId,
  }) {
    return _remote.markRead(roomId: roomId, userId: userId);
  }
}
