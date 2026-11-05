import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n_extensions.dart';
import '../../view_data/open_participant_view_data.dart';
import '../../view_data/room_event_view_data.dart';

enum OpenSessionTab { participants, plan, chat }

/// Экран открытой сессии: вкладки «Участники | План | Чат», кнопка ввода адреса.
/// Отдельная логика от приватной комнаты (см. docs/diploma/03_design.md, раздел 9).
class OpenSessionPanel extends StatefulWidget {
  const OpenSessionPanel({
    super.key,
    required this.displayCode,
    required this.participants,
    required this.selfUid,
    required this.hasOwnPoint,
    required this.canSubmitAddress,
    required this.addressController,
    required this.onAddressSubmit,
    required this.onOpenChat,
    required this.onLeaveRoom,
    required this.unreadCount,
    required this.event,
  });

  final String displayCode;
  final List<OpenParticipantViewData> participants;
  final String? selfUid;
  final bool hasOwnPoint;
  final bool canSubmitAddress;
  final TextEditingController addressController;
  final VoidCallback onAddressSubmit;
  final VoidCallback onOpenChat;
  final VoidCallback onLeaveRoom;
  final int unreadCount;
  final RoomEventViewData? event;

  @override
  State<OpenSessionPanel> createState() => _OpenSessionPanelState();
}

class _OpenSessionPanelState extends State<OpenSessionPanel> {
  OpenSessionTab _tab = OpenSessionTab.participants;

  void _onTabSelected(Set<OpenSessionTab> selection) {
    final tab = selection.first;
    if (tab == OpenSessionTab.chat) {
      widget.onOpenChat();
      return;
    }
    setState(() => _tab = tab);
  }

  Future<void> _openAddressSheet() async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.openSessionAddressSheetTitle,
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.openSessionAddressSheetHint,
                style: Theme.of(sheetContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: widget.addressController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  Navigator.of(sheetContext).pop();
                  widget.onAddressSubmit();
                },
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: widget.canSubmitAddress
                    ? () {
                        Navigator.of(sheetContext).pop();
                        widget.onAddressSubmit();
                      }
                    : null,
                child: Text(l10n.openSessionEnterAddress),
              ),
            ],
          ),
        );
      },
    );
  }

  String _participantName(
    BuildContext context,
    int index,
    OpenParticipantViewData p,
  ) {
    final l10n = context.l10n;
    if (p.uid == widget.selfUid) return l10n.openSessionParticipantSelf;
    if (p.isHost) return l10n.openSessionParticipantHost;
    return l10n.openSessionParticipantNumber(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.roomCodeLabel(widget.displayCode),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: scheme.primary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: widget.onLeaveRoom,
              icon: const Icon(Icons.logout),
              label: Text(l10n.openSessionLeave),
            ),
          ],
        ),
        if (!widget.hasOwnPoint) ...[
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: widget.canSubmitAddress ? _openAddressSheet : null,
            icon: const Icon(Icons.place_outlined),
            label: Text(l10n.openSessionEnterAddress),
          ),
        ],
        const SizedBox(height: 12),
        SegmentedButton<OpenSessionTab>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: OpenSessionTab.participants,
              label: Text(l10n.openSessionTabParticipants),
            ),
            ButtonSegment(
              value: OpenSessionTab.plan,
              label: Text(l10n.openSessionTabPlan),
            ),
            ButtonSegment(
              value: OpenSessionTab.chat,
              label: Text(
                widget.unreadCount > 0
                    ? '${l10n.openSessionTabChat} (${widget.unreadCount})'
                    : l10n.openSessionTabChat,
              ),
            ),
          ],
          selected: {_tab},
          onSelectionChanged: _onTabSelected,
        ),
        const SizedBox(height: 12),
        if (_tab == OpenSessionTab.participants)
          if (widget.participants.isEmpty)
            Text(
              l10n.openSessionEmptyParticipants,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.openSessionTabParticipants}: '
                  '${widget.participants.length}',
                  style: textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                for (var i = 0; i < widget.participants.length; i++)
                  _ParticipantRow(
                    name: _participantName(context, i, widget.participants[i]),
                    initial: _initialOf(
                      _participantName(context, i, widget.participants[i]),
                    ),
                    hasAddress: widget.participants[i].hasAddress,
                    isHost: widget.participants[i].isHost,
                    onTap: () => _openParticipantCard(
                      context,
                      _participantName(context, i, widget.participants[i]),
                      widget.participants[i],
                    ),
                  ),
              ],
            ),
        if (_tab == OpenSessionTab.plan) _PlanTab(event: widget.event),
      ],
    );
  }

  String _initialOf(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }

  void _openParticipantCard(
    BuildContext context,
    String name,
    OpenParticipantViewData participant,
  ) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final scheme = Theme.of(sheetContext).colorScheme;
        final textTheme = Theme.of(sheetContext).textTheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: scheme.primaryContainer,
                      child: Text(_initialOf(name)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: textTheme.titleMedium),
                          Text(
                            participant.isHost
                                ? l10n.openSessionParticipantHost
                                : l10n.openSessionParticipantMember,
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      participant.hasAddress
                          ? Icons.place
                          : Icons.place_outlined,
                      size: 18,
                      color: participant.hasAddress
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      participant.hasAddress
                          ? l10n.openSessionAddressSet
                          : l10n.openSessionAddressNotSet,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  const _ParticipantRow({
    required this.name,
    required this.initial,
    required this.hasAddress,
    required this.isHost,
    required this.onTap,
  });

  final String name;
  final String initial;
  final bool hasAddress;
  final bool isHost;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primaryContainer,
              child: Text(initial),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    hasAddress
                        ? l10n.openSessionAddressSet
                        : l10n.openSessionAddressNotSet,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanTab extends StatelessWidget {
  const _PlanTab({required this.event});

  final RoomEventViewData? event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final e = event;
    if (e == null) {
      return Text(l10n.openSessionNoEvent);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.openSessionPlanFromEvent,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          e.title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (e.venueName != null) Text(e.venueName!),
        if (e.address != null) Text(e.address!),
      ],
    );
  }
}
