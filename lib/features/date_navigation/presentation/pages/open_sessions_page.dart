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
    // Prefetch events while the screen is open, so the create dialog opens instantly.
    ref.watch(eventsProvider);
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
    RoomEventSnapshot? selectedEvent;
    final created =
        await showDialog<({int capacity, RoomEventSnapshot? event})>(
          context: context,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text(l10n.openSessionsCreate),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.openSessionsEvent),
                    const SizedBox(height: 8),
                    Consumer(
                      builder: (context, ref, _) {
                        final eventsAsync = ref.watch(eventsProvider);
                        final events =
                            eventsAsync.value ?? const <RoomEventSnapshot>[];
                        final loading = eventsAsync.isLoading && events.isEmpty;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<RoomEventSnapshot?>(
                              initialValue: selectedEvent,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(l10n.openSessionsEventNone),
                                ),
                                for (final event in events)
                                  DropdownMenuItem(
                                    value: event,
                                    child: Text(
                                      event.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                              onChanged: (value) =>
                                  setState(() => selectedEvent = value),
                            ),
                            if (loading) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.openSessionsEventsLoading,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ] else if (events.isEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.openSessionsEventsUnavailable,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancelLabel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(
                    dialogContext,
                  ).pop((capacity: capacity, event: selectedEvent)),
                  child: Text(l10n.openSessionsCreate),
                ),
              ],
            ),
          ),
        );
    if (created == null) return;
    await ref
        .read(dateNavigationControllerProvider.notifier)
        .createOpenRoom(capacity: created.capacity, event: created.event);
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
