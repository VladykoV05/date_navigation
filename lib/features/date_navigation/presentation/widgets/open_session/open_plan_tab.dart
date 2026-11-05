import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/l10n/l10n_extensions.dart';
import '../../../../../core/profile/profile_providers.dart';
import '../../../domain/value_objects/geo_distance.dart';
import '../../providers/open_plan_providers.dart';
import '../../view_data/open_plan_view_data.dart';
import '../../view_data/room_event_view_data.dart';

/// Вкладка «План» открытой сессии: событие → следующее место → предложения (design 11).
class OpenPlanTab extends ConsumerWidget {
  const OpenPlanTab({
    super.key,
    required this.roomId,
    required this.selfUid,
    required this.isCreator,
    required this.isClosed,
    required this.event,
    required this.nextStep,
    required this.planRadiusMeters,
  });

  final String roomId;
  final String? selfUid;
  final bool isCreator;
  final bool isClosed;
  final RoomEventViewData? event;
  final NextStepViewData? nextStep;
  final int planRadiusMeters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final suggestions =
        ref.watch(openPlanSuggestionsProvider(roomId)).value ?? const [];
    final hostAndActive = isCreator && !isClosed;
    final memberAndActive = !isClosed && selfUid != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Section(
          title: l10n.openSessionPlanFromEvent,
          child: event == null
              ? Text(l10n.openSessionNoEvent)
              : Text(
                  [
                    event!.title,
                    if (event!.venueName != null) event!.venueName!,
                  ].join(' · '),
                ),
        ),
        const SizedBox(height: 12),
        _Section(
          title: l10n.planNextStepTitle,
          child: nextStep == null
              ? Text(
                  l10n.planNotChosen,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextStep!.name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (nextStep!.address != null) Text(nextStep!.address!),
                  ],
                ),
        ),
        if (hostAndActive) ...[
          const SizedBox(height: 12),
          _Section(
            title: l10n.planRadiusLabel,
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                for (final meters in const [500, 1000, 2000])
                  ButtonSegment(
                    value: meters,
                    label: Text(l10n.planRadiusOption(meters)),
                  ),
              ],
              selected: {planRadiusMeters},
              onSelectionChanged: (selection) =>
                  _setRadius(context, ref, selection.first),
            ),
          ),
        ],
        if (memberAndActive) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _openSuggestDialog(context, ref),
            icon: const Icon(Icons.add_location_alt_outlined),
            label: Text(l10n.planSuggestButton),
          ),
        ],
        const SizedBox(height: 12),
        _Section(
          title: l10n.planSuggestionsTitle,
          child: suggestions.isEmpty
              ? Text(
                  l10n.planEmptySuggestions,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                )
              : Column(
                  children: [
                    for (final item in suggestions)
                      _SuggestionRow(
                        item: item,
                        canChoose: hostAndActive && item.isSuggested,
                        onChoose: () => _choose(context, ref, item),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Future<void> _setRadius(
    BuildContext context,
    WidgetRef ref,
    int meters,
  ) async {
    final result = await ref
        .read(openPlanSetRadiusProvider)
        .call(roomId: roomId, meters: meters);
    if (!context.mounted) return;
    if (result case Err()) _showError(context, context.l10n.planSaveFailed);
  }

  Future<void> _choose(
    BuildContext context,
    WidgetRef ref,
    PlanSuggestionViewData item,
  ) async {
    final uid = selfUid;
    if (uid == null) return;
    final result = await ref
        .read(openPlanChooseSuggestionProvider)
        .call(
          roomId: roomId,
          suggestionId: item.id,
          placeName: item.placeName,
          placeAddress: item.placeAddress,
          lat: item.lat,
          lon: item.lon,
          hostUid: uid,
        );
    if (!context.mounted) return;
    if (result case Err()) _showError(context, context.l10n.planSaveFailed);
  }

  Future<void> _openSuggestDialog(BuildContext context, WidgetRef ref) async {
    final draft = await showDialog<({String name, String address})>(
      context: context,
      builder: (_) => const _SuggestDialog(),
    );
    if (draft == null || !context.mounted) return;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    final geo = await ref.read(openPlanGeocodeProvider).call(draft.address);
    if (!context.mounted) return;
    final coords = switch (geo) {
      Ok(:final value) => value,
      Err() => null,
    };
    if (coords == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.planAddressNotFound)));
      return;
    }
    final venue = event;
    if (venue?.lat != null && venue?.lon != null) {
      final distance = distanceMeters(
        venue!.lat!,
        venue.lon!,
        coords.lat,
        coords.lon,
      );
      if (distance > planRadiusMeters) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.planTooFar(planRadiusMeters))),
        );
        return;
      }
    }
    final uid = selfUid;
    if (uid == null) return;
    final result = await ref
        .read(openPlanSuggestPlaceProvider)
        .call(
          roomId: roomId,
          userId: uid,
          name: draft.name,
          address: draft.address,
          lat: coords.lat,
          lon: coords.lon,
        );
    if (!context.mounted) return;
    switch (result) {
      case Ok():
        break;
      case Err(:final failure):
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              failure.message == FailureCodes.suggestionLimit
                  ? l10n.planSuggestLimit
                  : l10n.planSaveFailed,
            ),
          ),
        );
    }
  }

  void _showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _SuggestionRow extends ConsumerWidget {
  const _SuggestionRow({
    required this.item,
    required this.canChoose,
    required this.onChoose,
  });

  final PlanSuggestionViewData item;
  final bool canChoose;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final proposer = ref
        .watch(publicProfileViewProvider(item.proposedBy))
        .value
        ?.shownName;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.placeName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  [
                    if (item.placeAddress != null) item.placeAddress!,
                    if (proposer != null) l10n.planProposedBy(proposer),
                  ].join(' · '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (item.isChosen)
            Text(l10n.planChosenLabel, style: TextStyle(color: scheme.primary))
          else if (canChoose)
            TextButton(onPressed: onChoose, child: Text(l10n.planChooseButton)),
        ],
      ),
    );
  }
}

class _SuggestDialog extends StatefulWidget {
  const _SuggestDialog();

  @override
  State<_SuggestDialog> createState() => _SuggestDialogState();
}

class _SuggestDialogState extends State<_SuggestDialog> {
  final _name = TextEditingController();
  final _address = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.planSuggestButton),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            maxLength: 120,
            decoration: InputDecoration(labelText: l10n.planSuggestNameLabel),
          ),
          TextField(
            controller: _address,
            decoration: InputDecoration(
              labelText: l10n.planSuggestAddressLabel,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.profileCancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            final address = _address.text.trim();
            if (name.isEmpty || address.isEmpty) return;
            Navigator.of(context).pop((name: name, address: address));
          },
          child: Text(l10n.planSuggestSubmit),
        ),
      ],
    );
  }
}
