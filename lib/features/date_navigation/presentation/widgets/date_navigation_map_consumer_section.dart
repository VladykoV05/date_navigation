import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/place.dart';
import '../controller/providers/date_navigation_provider.dart';
import 'map_section.dart';

typedef LoadingMessageBuilder =
    String Function({
      required bool isGeocoding,
      required bool isCalculatingMeeting,
      required bool isLoadingRoomAction,
    });

class DateNavigationMapConsumerSection extends ConsumerWidget {
  const DateNavigationMapConsumerSection({
    super.key,
    required this.mapController,
    required this.onPlaceTap,
    required this.loadingMessageBuilder,
  });

  final MapController mapController;
  final void Function(Place) onPlaceTap;
  final LoadingMessageBuilder loadingMessageBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(dateNavigationMapViewProvider);
    final places = view.filteredPlaces;
    final venueLocked = view.venueLocked;
    final finalChoicePlace = view.finalChoicePlace;
    final mapPlaces = venueLocked ? [?finalChoicePlace] : places;
    final isLoading = view.isLoading;
    final isCalculatingMeeting = view.isCalculatingMeeting;
    final searchRadius = view.searchRadius;
    final routePoints = view.routePoints;
    final isGeocoding = view.isGeocoding;
    final isLoadingRoomAction = view.isLoadingRoomAction;
    final showBlockingLoading =
        !venueLocked &&
        (isGeocoding ||
            isLoadingRoomAction ||
            (isCalculatingMeeting && places.isEmpty));

    return MapSection(
      mapController: mapController,
      isCreator: view.isCreator,
      centerPoint: view.centerPoint,
      point1: view.point1,
      point2: view.point2,
      foundPlaces: mapPlaces,
      onPlaceTap: onPlaceTap,
      isSearching: showBlockingLoading && isLoading,
      loadingMessage: loadingMessageBuilder(
        isGeocoding: isGeocoding,
        isCalculatingMeeting: isCalculatingMeeting,
        isLoadingRoomAction: isLoadingRoomAction,
      ),
      searchRadius: searchRadius,
      routePoints: routePoints,
      showMeetingRouteAndRadius: !venueLocked,
    );
  }
}
