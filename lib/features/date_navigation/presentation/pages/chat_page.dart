import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/error/result.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../domain/entities/chat_message.dart';
import '../../di/date_navigation_di.dart';
import '../providers/chat_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.roomId});

  final String roomId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _markRead());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _markRead() async {
    final uid = ref.read(authSessionProvider).currentUserId;
    if (uid == null) return;
    await ref
        .read(chatRepositoryProvider)
        .markRead(roomId: widget.roomId, userId: uid);
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
      case Err():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.chatSendFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentUserId =
        ref.watch(authSessionProvider.select((s) => s.currentUserId)) ?? '';
    final messages = ref.watch(chatMessagesProvider(widget.roomId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatTitle)),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l10n.chatLoadFailed)),
              data: (items) {
                if (items.isEmpty) {
                  return Center(child: Text(l10n.chatEmpty));
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (_, index) => _MessageBubble(
                    message: items[index],
                    isMine: items[index].senderUid == currentUserId,
                  ),
                );
              },
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
