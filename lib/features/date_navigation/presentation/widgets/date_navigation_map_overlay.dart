import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/providers/date_navigation_provider.dart';

class DateNavigationMapOverlay extends ConsumerWidget {
  const DateNavigationMapOverlay({
    super.key,
    required this.onFitAllPoints,
    required this.onResetMapOrientation,
    required this.onFocusMyPoint,
  });

  final VoidCallback onFitAllPoints;
  final VoidCallback onResetMapOrientation;
  final VoidCallback onFocusMyPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(dateNavigationMapOverlayViewProvider);

    final myPoint = view.isCreator ? view.point1 : view.point2;
    final hasPlacesOnMap = view.venueLocked
        ? view.finalChoicePlace != null
        : view.filteredPlaces.isNotEmpty;
    final meetingMarkers = view.venueLocked && view.finalChoicePlace != null
        ? 1
        : (view.centerPoint != null ? 1 : 0) +
              (view.routePoints.isNotEmpty ? view.routePoints.length : 0);
    final pointsCount =
        (view.point1 != null ? 1 : 0) +
        (view.point2 != null ? 1 : 0) +
        meetingMarkers;

    return Stack(
      children: [
        Positioned(
          top: 14,
          left: 14,
          child: _MapActions(
            canFocusMyPoint: myPoint != null,
            canFitAllPoints: pointsCount >= 2,
            onFitAllPoints: onFitAllPoints,
            onResetMapOrientation: onResetMapOrientation,
            onFocusMyPoint: onFocusMyPoint,
          ),
        ),
        Positioned(
          left: 14,
          right: 14,
          bottom: 150,
          child: _MapLegend(
            hasMyPoint: myPoint != null,
            hasPartnerPoint:
                (view.isCreator ? view.point2 : view.point1) != null,
            hasCenterPoint: !view.venueLocked && view.centerPoint != null,
            hasPlaces: hasPlacesOnMap,
          ),
        ),
      ],
    );
  }
}

class _MapOverlaySurface extends StatelessWidget {
  const _MapOverlaySurface({
    required this.child,
    this.padding = const EdgeInsets.all(8),
    this.elevation = 3,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface,
      elevation: elevation,
      borderRadius: BorderRadius.circular(12),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _MapActions extends StatelessWidget {
  const _MapActions({
    required this.canFocusMyPoint,
    required this.canFitAllPoints,
    required this.onFitAllPoints,
    required this.onResetMapOrientation,
    required this.onFocusMyPoint,
  });

  final bool canFocusMyPoint;
  final bool canFitAllPoints;
  final VoidCallback onFitAllPoints;
  final VoidCallback onResetMapOrientation;
  final VoidCallback onFocusMyPoint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Действия карты',
      child: SafeArea(
        child: _MapOverlaySurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Показать всех',
                onPressed: canFitAllPoints ? onFitAllPoints : null,
                icon: const Icon(Icons.fit_screen),
              ),
              const SizedBox(height: 4),
              IconButton(
                tooltip: 'Сбросить поворот',
                onPressed: onResetMapOrientation,
                icon: const Icon(Icons.explore),
              ),
              const SizedBox(height: 4),
              IconButton(
                tooltip: 'Ко мне',
                onPressed: canFocusMyPoint ? onFocusMyPoint : null,
                icon: const Icon(Icons.my_location),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapLegend extends StatelessWidget {
  const _MapLegend({
    required this.hasMyPoint,
    required this.hasPartnerPoint,
    required this.hasCenterPoint,
    required this.hasPlaces,
  });

  final bool hasMyPoint;
  final bool hasPartnerPoint;
  final bool hasCenterPoint;
  final bool hasPlaces;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = <Widget>[
      if (hasMyPoint)
        _LegendItem(
          icon: Icons.my_location,
          color: colorScheme.primary,
          label: 'Я',
        ),
      if (hasPartnerPoint)
        const _LegendItem(
          icon: Icons.location_on,
          color: Colors.red,
          label: 'Партнер',
        ),
      if (hasCenterPoint)
        _LegendItem(
          icon: Icons.adjust,
          color: colorScheme.primary,
          label: 'Центр',
        ),
      if (hasPlaces)
        const _LegendItem(
          icon: Icons.place_outlined,
          color: Colors.green,
          label: 'Места',
        ),
    ];
    if (items.isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _MapOverlaySurface(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 1,
            child: Wrap(
              spacing: 12,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: items,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
