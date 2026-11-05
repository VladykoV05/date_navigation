import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/error/result.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../domain/entities/chat_message.dart';
import '../../di/date_navigation_di.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.roomId});

  final String roomId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  static const int _pageSize = 50;

  final _controller = TextEditingController();
  StreamSubscription<List<ChatMessage>>? _subscription;
  List<ChatMessage> _messages = const [];
  bool _sending = false;
  bool _loadingOlder = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _subscribe();
    WidgetsBinding.instance.addPostFrameCallback((_) => _markRead());
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    _controller.dispose();
    super.dispose();
  }

  void _subscribe() {
    _subscription = ref
        .read(chatRepositoryProvider)
        .watchMessages(widget.roomId, limit: _pageSize)
        .listen((items) {
          if (!mounted) return;
          setState(() {
            _messages = _merge(items, _messages);
            _hasMore = items.length >= _pageSize;
          });
        }, onError: (_) {});
  }

  Future<void> _markRead() async {
    final uid = ref.read(authSessionProvider).currentUserId;
    if (uid == null) return;
    await ref
        .read(chatRepositoryProvider)
        .markRead(roomId: widget.roomId, userId: uid);
  }

  Future<void> _loadOlder() async {
    if (_loadingOlder || !_hasMore || _messages.isEmpty) return;
    final oldest = _messages.last;
    setState(() => _loadingOlder = true);
    final result = await ref
        .read(chatRepositoryProvider)
        .fetchMessages(
          roomId: widget.roomId,
          limit: _pageSize,
          before: oldest.createdAt,
        );
    if (!mounted) return;
    setState(() => _loadingOlder = false);
    switch (result) {
      case Ok(value: final older):
        setState(() {
          _messages = _merge(older, _messages);
          _hasMore = older.length >= _pageSize;
        });
      case Err():
        break;
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    final uid = ref.read(authSessionProvider).currentUserId;
    if (text.isEmpty || uid == null || _sending) return;
    setState(() => _sending = true);
    final result = await ref
        .read(chatRepositoryProvider)
        .sendMessage(
          roomId: widget.roomId,
          senderUid: uid,
          text: text,
          clientId: DateTime.now().microsecondsSinceEpoch.toString(),
        );
    if (!mounted) return;
    setState(() => _sending = false);
    switch (result) {
      case Ok():
        _controller.clear();
        unawaited(_markRead());
      case Err():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.chatSendFailed)));
    }
  }

  List<ChatMessage> _merge(
    List<ChatMessage> incoming,
    List<ChatMessage> current,
  ) {
    final byId = <String, ChatMessage>{
      for (final message in current) message.id: message,
      for (final message in incoming) message.id: message,
    };
    final merged = byId.values.toList(growable: false);
    merged.sort((a, b) {
      final aTime = a.createdAt;
      final bTime = b.createdAt;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });
    return merged;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentUserId =
        ref.watch(authSessionProvider.select((s) => s.currentUserId)) ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatTitle)),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                if (_hasMore)
                  TextButton(
                    onPressed: _loadingOlder ? null : _loadOlder,
                    child: _loadingOlder
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.chatLoadOlder),
                  ),
                Expanded(
                  child: _messages.isEmpty
                      ? Center(child: Text(l10n.chatEmpty))
                      : ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: _messages.length,
                          itemBuilder: (_, index) => _MessageBubble(
                            message: _messages[index],
                            isMine: _messages[index].senderUid == currentUserId,
                          ),
                        ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => unawaited(_send()),
                      decoration: InputDecoration(
                        hintText: l10n.chatInputHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : () => unawaited(_send()),
                    icon: const Icon(Icons.send),
                    tooltip: l10n.chatSend,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine});

  final ChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    if (message.kind == ChatMessageKind.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Center(
          child: Text(
            _systemText(context, message.text),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMine
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(message.text),
      ),
    );
  }
}

String _systemText(BuildContext context, String code) {
  final l10n = context.l10n;
  return switch (code) {
    'system.participant_joined' => l10n.systemParticipantJoined,
    'system.participant_left' => l10n.systemParticipantLeft,
    'system.format_confirmed' => l10n.systemFormatConfirmed,
    'system.place_selected' => l10n.systemPlaceSelected,
    _ => code,
  };
}
