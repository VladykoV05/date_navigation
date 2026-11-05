import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/l10n/l10n_extensions.dart';
import '../../../../../core/profile/profile_providers.dart';
import '../../../domain/value_objects/geo_distance.dart';
import '../../providers/open_plan_providers.dart';
import '../../view_data/nearby_place_view_data.dart';
import '../../view_data/open_plan_view_data.dart';
import '../../view_data/room_event_view_data.dart';

/// Вкладка «План» открытой сессии: событие → следующее место → поиск рядом → предложения (design 11).
class OpenPlanTab extends ConsumerStatefulWidget {
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
  ConsumerState<OpenPlanTab> createState() => _OpenPlanTabState();
}

class _OpenPlanTabState extends ConsumerState<OpenPlanTab> {
  String _formatKey = openPlanSearchFormats.first;
  bool _searching = false;
  List<NearbyPlaceViewData>? _results;

  String _categoryLabel(BuildContext context, String key) {
    final l10n = context.l10n;
    return switch (key) {
      'culture' => l10n.planCategoryCulture,
      'walk_only' => l10n.planCategoryWalk,
      'active' => l10n.planCategoryActive,
      _ => l10n.planCategoryFood,
    };
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _search() async {
    final l10n = context.l10n;
    final venue = widget.event;
    if (venue?.lat == null || venue?.lon == null) {
      _showMessage(l10n.planSearchNoCoords);
      return;
    }
    setState(() => _searching = true);
    final result = await openPlanSearchNearby(
      ref,
      lat: venue!.lat!,
      lon: venue.lon!,
      radiusMeters: widget.planRadiusMeters,
      formatKey: _formatKey,
    );
    if (!mounted) return;
    setState(() {
      _searching = false;
      _results = switch (result) {
        Ok(:final value) => value,
        Err() => null,
      };
    });
    if (result case Err()) _showMessage(l10n.planSearchFailed);
  }

  Future<void> _chooseNow(NearbyPlaceViewData place) async {
    final uid = widget.selfUid;
    if (uid == null) return;
    final result = await openPlanSetNextStep(
      ref,
      roomId: widget.roomId,
      name: place.name,
      address: place.address,
      lat: place.lat,
      lon: place.lon,
      hostUid: uid,
    );
    if (!mounted) return;
    if (result case Err()) _showMessage(context.l10n.planSaveFailed);
  }

  Future<void> _suggest(NearbyPlaceViewData place) async {
    final uid = widget.selfUid;
    if (uid == null) return;
    final result = await ref
        .read(openPlanSuggestPlaceProvider)
        .call(
          roomId: widget.roomId,
          userId: uid,
          name: place.name,
          address: place.address,
          lat: place.lat,
          lon: place.lon,
        );
    if (!mounted) return;
    switch (result) {
      case Ok():
        break;
      case Err(:final failure):
        _showMessage(
          failure.message == FailureCodes.suggestionLimit
              ? context.l10n.planSuggestLimit
              : context.l10n.planSaveFailed,
        );
    }
  }

  Future<void> _setRadius(int meters) async {
    final result = await ref
        .read(openPlanSetRadiusProvider)
        .call(roomId: widget.roomId, meters: meters);
    if (!mounted) return;
    if (result case Err()) _showMessage(context.l10n.planSaveFailed);
  }

  Future<void> _choose(PlanSuggestionViewData item) async {
    final uid = widget.selfUid;
    if (uid == null) return;
    final result = await ref
        .read(openPlanChooseSuggestionProvider)
        .call(
          roomId: widget.roomId,
          suggestionId: item.id,
          placeName: item.placeName,
          placeAddress: item.placeAddress,
          lat: item.lat,
          lon: item.lon,
          hostUid: uid,
        );
    if (!mounted) return;
    if (result case Err()) _showMessage(context.l10n.planSaveFailed);
  }

  Future<void> _openSuggestDialog() async {
    final draft = await showDialog<({String name, String address})>(
      context: context,
      builder: (_) => const _SuggestDialog(),
    );
    if (draft == null || !mounted) return;
    final l10n = context.l10n;

    final geo = await ref.read(openPlanGeocodeProvider).call(draft.address);
    if (!mounted) return;
    final coords = switch (geo) {
      Ok(:final value) => value,
      Err() => null,
    };
    if (coords == null) {
      _showMessage(l10n.planAddressNotFound);
      return;
    }
    final venue = widget.event;
    if (venue?.lat != null && venue?.lon != null) {
      final distance = distanceMeters(
        venue!.lat!,
        venue.lon!,
        coords.lat,
        coords.lon,
      );
      if (distance > widget.planRadiusMeters) {
        _showMessage(l10n.planTooFar(widget.planRadiusMeters));
        return;
      }
    }
    await _suggest(
      NearbyPlaceViewData(
        name: draft.name,
        lat: coords.lat,
        lon: coords.lon,
        address: draft.address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final suggestions =
        ref.watch(openPlanSuggestionsProvider(widget.roomId)).value ?? const [];
    final hostAndActive = widget.isCreator && !widget.isClosed;
    final memberAndActive = !widget.isClosed && widget.selfUid != null;
    final venue = widget.event;
    final next = widget.nextStep;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Section(
          title: l10n.openSessionPlanFromEvent,
          child: venue == null
              ? Text(l10n.openSessionNoEvent)
              : Text(
                  [
                    venue.title,
                    if (venue.venueName != null) venue.venueName!,
                  ].join(' · '),
                ),
        ),
        const SizedBox(height: 12),
        _Section(
          title: l10n.planNextStepTitle,
          child: next == null
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
                      next.name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (next.address != null) Text(next.address!),
                    if (venue != null &&
                        venue.lat != null &&
                        venue.lon != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        l10n.planWalkTime(
                          _walkMinutes(
                            distanceMeters(
                              venue.lat!,
                              venue.lon!,
                              next.lat,
                              next.lon,
                            ),
                          ),
                          distanceMeters(
                            venue.lat!,
                            venue.lon!,
                            next.lat,
                            next.lon,
                          ).round(),
                        ),
                        style: textTheme.bodySmall,
                      ),
                    ],
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
              selected: {widget.planRadiusMeters},
              onSelectionChanged: (selection) => _setRadius(selection.first),
            ),
          ),
        ],
        if (memberAndActive) ...[
          const SizedBox(height: 12),
          _Section(
            title: l10n.planSearchTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (final key in openPlanSearchFormats)
                      ChoiceChip(
                        label: Text(_categoryLabel(context, key)),
                        selected: _formatKey == key,
                        onSelected: (_) => setState(() {
                          _formatKey = key;
                          _results = null;
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _searching ? null : _search,
                  icon: _searching
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(l10n.planSearchButton),
                ),
                if (_results != null) ...[
                  const SizedBox(height: 8),
                  if (_results!.isEmpty)
                    Text(
                      l10n.planSearchEmpty,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  else
                    for (final place in _results!)
                      _NearbyRow(
                        place: place,
                        primaryLabel: hostAndActive
                            ? l10n.planChooseNow
                            : l10n.planSuggestFromSearch,
                        onPressed: () =>
                            hostAndActive ? _chooseNow(place) : _suggest(place),
                      ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _openSuggestDialog,
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
                        onChoose: () => _choose(item),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  /// Пешком ≈ 5 км/ч; минимум одна минута.
  int _walkMinutes(double meters) {
    final minutes = (meters / 1000 / 5 * 60).round();
    return minutes < 1 ? 1 : minutes;
  }
}

class _NearbyRow extends StatelessWidget {
  const _NearbyRow({
    required this.place,
    required this.primaryLabel,
    required this.onPressed,
  });

  final NearbyPlaceViewData place;
  final String primaryLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (place.address != null)
                  Text(
                    place.address!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(onPressed: onPressed, child: Text(primaryLabel)),
        ],
      ),
    );
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
