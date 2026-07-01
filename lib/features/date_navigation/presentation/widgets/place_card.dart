import 'package:flutter/material.dart';
import '../../domain/value_objects/geo_coordinate.dart';
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

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.toInt()} м';
    return '${(meters / 1000).toStringAsFixed(1)} км';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final visual = PlaceVisuals.fromType(place.type);
    final typeLabels = _buildTypeLabels(
      place,
      selectedTypeContext: selectedTypeContext,
    );
    return Card(
      margin: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        label: 'Место ${place.name}',
        hint: 'Открывает карточку места с деталями',
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
                  place.address ?? 'Адрес не указан',
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
                              ? 'Убрать голос'
                              : 'Проголосовать',
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
                  labelText: typeLabels.firstOrNull ?? visual.label,
                  secondaryText: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _buildTypeLabels(PlaceViewData place, {String? selectedTypeContext}) {
    if (selectedTypeContext == 'swimming_pool' &&
        place.types.contains('swimming_pool')) {
      // In "Pool" filter show only pool label.
      return const ['Бассейн'];
    }
    final labels = <String>[];
    final primary = PlaceVisuals.fromType(place.type).label;
    if (primary.trim().isNotEmpty) {
      labels.add(primary.trim());
    }
    for (final type in place.types) {
      final label = PlaceVisuals.fromType(type).label.trim();
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
