import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../domain/entities/room_snapshot.dart';
import '../providers/date_navigation_provider.dart';
import '../providers/open_sessions_provider.dart';

class OpenSessionsPage extends ConsumerWidget {
  const OpenSessionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sessions = ref.watch(openSessionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.openSessionsTitle),
        actions: [
          IconButton(
            tooltip: l10n.openSessionsRefresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(openSessionsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.openSessionsCreate),
      ),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.openSessionsLoadFailed)),
        data: (rooms) {
          if (rooms.isEmpty) {
            return Center(child: Text(l10n.openSessionsEmpty));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(openSessionsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _OpenSessionCard(room: rooms[index]),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    var capacity = 4;
    final created = await showDialog<int>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.openSessionsCreate),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.openSessionsCapacity),
              const SizedBox(width: 12),
              IconButton(
                onPressed: capacity > 2
                    ? () => setState(() => capacity--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$capacity'),
              IconButton(
                onPressed: capacity < 20
                    ? () => setState(() => capacity++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancelLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(capacity),
              child: Text(l10n.openSessionsCreate),
            ),
          ],
        ),
      ),
    );
    if (created == null) return;
    await ref
        .read(dateNavigationControllerProvider.notifier)
        .createOpenRoom(capacity: created);
    if (context.mounted) Navigator.of(context).maybePop();
  }
}

class _OpenSessionCard extends ConsumerWidget {
  const _OpenSessionCard({required this.room});

  final RoomSnapshot room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isFull = room.participantUids.length >= room.capacity;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(room.event?.title ?? l10n.openSessionNoEvent),
        subtitle: Text(
          l10n.openSessionMembers(room.participantUids.length, room.capacity),
        ),
        trailing: FilledButton(
          onPressed: isFull
              ? null
              : () async {
                  await ref
                      .read(dateNavigationControllerProvider.notifier)
                      .joinOpenRoom(room.id);
                  if (context.mounted) Navigator.of(context).maybePop();
                },
          child: Text(isFull ? l10n.openSessionFull : l10n.openSessionJoin),
        ),
      ),
    );
  }
}
