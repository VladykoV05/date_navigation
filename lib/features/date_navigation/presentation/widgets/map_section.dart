import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../domain/entities/place.dart';
import 'place_visuals.dart';

class MapSection extends StatefulWidget {
  final MapController mapController;
  final bool isCreator;
  final latlong.LatLng? centerPoint;
  final latlong.LatLng? point1;
  final latlong.LatLng? point2;
  final List<Place> foundPlaces;
  final void Function(Place) onPlaceTap;
  final bool isSearching;
  final String? loadingMessage;
  final double searchRadius;
  final List<latlong.LatLng> routePoints;
  final bool showMeetingRouteAndRadius;

  const MapSection({
    super.key,
    required this.mapController,
    required this.isCreator,
    required this.centerPoint,
    required this.point1,
    required this.point2,
    required this.foundPlaces,
    required this.onPlaceTap,
    required this.isSearching,
    this.loadingMessage,
    required this.searchRadius,
    required this.routePoints,
    this.showMeetingRouteAndRadius = true,
  });

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileUrl = isDark
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    return Stack(
      children: [
        FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            initialCenter:
                widget.centerPoint ?? const latlong.LatLng(53.9, 27.5667),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: tileUrl,
              userAgentPackageName: 'com.example.date_navigation',
            ),
            if (widget.showMeetingRouteAndRadius &&
                widget.routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.routePoints,
                    strokeWidth: 4.0,
                    color: colorScheme.primary.withValues(alpha: 0.8),
                    borderStrokeWidth: 2.0,
                    borderColor: colorScheme.surface,
                  ),
                ],
              ),
            if (widget.showMeetingRouteAndRadius && widget.centerPoint != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: widget.centerPoint!,
                    radius: widget.searchRadius,
                    useRadiusInMeter: true,
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderColor: colorScheme.primary.withValues(alpha: 0.35),
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
            MarkerLayer(markers: _buildMarkers(context)),
          ],
        ),
        if (widget.isSearching) _buildLoadingOverlay(context),
      ],
    );
  }

  List<Marker> _buildMarkers(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final markers = <Marker>[];
    final myPoint = widget.isCreator ? widget.point1 : widget.point2;
    final partnerPoint = widget.isCreator ? widget.point2 : widget.point1;
    if (myPoint != null) {
      markers.add(_marker(myPoint, Icons.my_location, colorScheme.primary));
    }
    if (partnerPoint != null) {
      markers.add(_marker(partnerPoint, Icons.location_on, colorScheme.error));
    }
    if (widget.showMeetingRouteAndRadius && widget.centerPoint != null) {
      markers.add(_buildCenterMarker(context, widget.centerPoint!));
    }
    for (final place in widget.foundPlaces) {
      markers.add(_buildPlaceMarker(place));
    }
    return markers;
  }

  Marker _marker(latlong.LatLng point, IconData icon, Color color) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: Icon(icon, color: color, size: 40),
    );
  }

  Marker _buildPlaceMarker(Place place) {
    final visual = PlaceVisuals.fromType(place.type);
    return Marker(
      point: latlong.LatLng(place.lat, place.lon),
      width: 35,
      height: 35,
      child: GestureDetector(
        onTap: () => widget.onPlaceTap(place),
        child: Icon(visual.icon, color: visual.color, size: 28),
      ),
    );
  }

  Marker _buildCenterMarker(BuildContext context, latlong.LatLng point) {
    final colorScheme = Theme.of(context).colorScheme;
    return Marker(
      point: point,
      width: 44,
      height: 44,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(color: colorScheme.surface, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(Icons.adjust, color: colorScheme.onPrimary, size: 24),
      ),
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: Colors.black.withValues(alpha: 0.34),
      child: Center(
        child: Card(
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(widget.loadingMessage ?? 'Ищем лучшие места...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
