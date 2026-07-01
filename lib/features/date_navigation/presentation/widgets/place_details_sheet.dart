import 'package:flutter/material.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../../../../core/services/navigation_service.dart';
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

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.toInt()} м';
    return '${(meters / 1000).toStringAsFixed(1)} км';
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
            place.address ?? 'Адрес не указан',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (startPoint != null)
                _distBox(
                  'Тебе',
                  _formatDistance(
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
                  'Партнеру',
                  _formatDistance(
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
              label: const Text('Маршрут'),
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

  Widget _distBox(String who, String dist, IconData icon) {
    return Expanded(
      child: Semantics(
        label: 'Расстояние: $who, $dist',
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
