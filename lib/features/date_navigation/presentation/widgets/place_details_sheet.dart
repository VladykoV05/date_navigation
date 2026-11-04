import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/services/navigation_service.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../view_data/place_view_data.dart';

class PlaceDetailsSheet extends StatelessWidget {
  final PlaceViewData place;
  final GeoCoordinate? startPoint;
  final GeoCoordinate? partnerPoint;
  final NavigationService navigationService;

  const PlaceDetailsSheet({
    super.key,
    required this.place,
    required this.startPoint,
    required this.navigationService,
    this.partnerPoint,
  });

  String _formatDistance(BuildContext context, double meters) {
    final l10n = context.l10n;
    if (meters < 1000) return l10n.metersShort(meters.toInt());
    return l10n.kilometersShort((meters / 1000).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            place.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            place.address ?? context.l10n.addressNotSpecified,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (startPoint != null)
                _distBox(
                  context,
                  context.l10n.distanceForYou,
                  _formatDistance(
                    context,
                    place.distanceTo(
                      startPoint!.latitude,
                      startPoint!.longitude,
                    ),
                  ),
                  Icons.directions_walk,
                ),
              if (startPoint != null && partnerPoint != null)
                const SizedBox(width: 10),
              if (partnerPoint != null)
                _distBox(
                  context,
                  context.l10n.distanceForPartner,
                  _formatDistance(
                    context,
                    place.distanceTo(
                      partnerPoint!.latitude,
                      partnerPoint!.longitude,
                    ),
                  ),
                  Icons.location_on_outlined,
                ),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _buildRoute(context),
              icon: const Icon(Icons.navigation_outlined),
              label: Text(context.l10n.routeLabel),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _distBox(
    BuildContext context,
    String who,
    String dist,
    IconData icon,
  ) {
    return Expanded(
      child: Semantics(
        label: context.l10n.distanceLine(who, dist),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: Colors.deepPurple),
              const SizedBox(height: 4),
              Text(who),
              Text(dist, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildRoute(BuildContext context) async {
    if (startPoint == null) return;

    await navigationService.openYandexMaps(
      startLat: startPoint!.latitude,
      startLon: startPoint!.longitude,
      endLat: place.lat,
      endLon: place.lon,
    );
    if (context.mounted) Navigator.pop(context);
  }
}
