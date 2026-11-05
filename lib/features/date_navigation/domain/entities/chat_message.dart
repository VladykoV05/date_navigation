enum ChatMessageKind {
  text('text'),
  system('system');

  const ChatMessageKind(this.wireValue);

  final String wireValue;

  static ChatMessageKind fromWireValue(Object? value) {
    return value?.toString().trim().toLowerCase() == 'system'
        ? ChatMessageKind.system
        : ChatMessageKind.text;
  }
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderUid,
    required this.text,
    this.kind = ChatMessageKind.text,
    this.createdAt,
    this.clientId,
  });

  final String id;
  final String senderUid;
  final String text;
  final ChatMessageKind kind;
  final DateTime? createdAt;
  final String? clientId;
}
