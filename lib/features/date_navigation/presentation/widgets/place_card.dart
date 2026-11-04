import 'package:flutter/material.dart';

import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../mappers/place_visual_mapper.dart';
import '../view_data/place_view_data.dart';
import './place_visuals.dart';

class PlaceCard extends StatelessWidget {
  final PlaceViewData place;
  final VoidCallback onTap;
  final GeoCoordinate? userLocation;
  final double? score;
  final VoidCallback? onVote;
  final int voteCount;
  final bool isVotedByMe;
  final bool isFavorite;
  final String? selectedTypeContext;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onTap,
    this.userLocation,
    this.score,
    this.onVote,
    this.voteCount = 0,
    this.isVotedByMe = false,
    this.isFavorite = false,
    this.selectedTypeContext,
  });

  String _formatDistance(BuildContext context, double meters) {
    final l10n = context.l10n;
    if (meters < 1000) return l10n.metersShort(meters.toInt());
    return l10n.kilometersShort((meters / 1000).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final visual = PlaceVisualMapper.fromWireType(place.type);
    final typeLabels = _buildTypeLabels(
      context,
      place,
      selectedTypeContext: selectedTypeContext,
    );
    return Card(
      margin: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        label: context.l10n.placeSemanticsLabel(place.name),
        hint: context.l10n.placeSemanticsHint,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isFavorite) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.pinkAccent,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  place.address ?? context.l10n.addressNotSpecified,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                if (userLocation != null)
                  Row(
                    children: [
                      Icon(Icons.person, size: 12, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDistance(
                          context,
                          place.distanceTo(
                            userLocation!.latitude,
                            userLocation!.longitude,
                          ),
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 6),
                if (score != null || onVote != null) ...[
                  Row(
                    children: [
                      if (score != null)
                        Text(
                          'Score: ${score!.toStringAsFixed(2)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.tertiary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (onVote != null) ...[
                        const Spacer(),
                        IconButton(
                          onPressed: onVote,
                          iconSize: 20,
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                          tooltip: isVotedByMe
                              ? context.l10n.removeVote
                              : context.l10n.castVote,
                          icon: Icon(
                            isVotedByMe
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined,
                            color: isVotedByMe
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$voteCount',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                _buildTypeChip(
                  visual: visual,
                  labelText:
                      typeLabels.firstOrNull ?? context.l10n.placeTypeFallback,
                  secondaryText: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _buildTypeLabels(
    BuildContext context,
    PlaceViewData place, {
    String? selectedTypeContext,
  }) {
    final l10n = context.l10n;
    final poolType = PlaceVisualMapper.swimmingPoolWireValue;
    if (selectedTypeContext == poolType && place.types.contains(poolType)) {
      // In "Pool" filter show only pool label.
      return [l10n.placeTypePool];
    }
    final labels = <String>[];
    final primary = l10n.placeTypeLabelFromWire(place.type);
    if (primary.trim().isNotEmpty) {
      labels.add(primary.trim());
    }
    for (final type in place.types) {
      final label = l10n.placeTypeLabelFromWire(type).trim();
      if (label.isEmpty) continue;
      if (!labels.contains(label)) {
        labels.add(label);
      }
    }
    return labels;
  }

  Widget _buildTypeChip({
    required PlaceVisual visual,
    required String labelText,
    String? secondaryText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: visual.chipBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(visual.icon, size: 12, color: visual.color),
          const SizedBox(width: 4),
          Text(
            secondaryText == null ? labelText : '$labelText, $secondaryText',
          ),
        ],
      ),
    );
  }
}
