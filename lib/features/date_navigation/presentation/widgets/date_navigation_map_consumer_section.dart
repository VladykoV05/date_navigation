import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../mappers/place_view_mapper.dart';
import '../view_data/place_view_data.dart';
import '../providers/date_navigation_provider.dart';
import '../providers/open_plan_providers.dart';
import './map_section.dart';

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
  final void Function(PlaceViewData) onPlaceTap;
  final LoadingMessageBuilder loadingMessageBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(dateNavigationMapViewProvider);
    final venue = view.event;
    final next = view.nextStep;
    final openRoute =
        view.isOpen && next != null && venue?.lat != null && venue?.lon != null
        ? ref
                  .watch(
                    openPlanWalkingRouteProvider((
                      fromLat: venue!.lat!,
                      fromLon: venue.lon!,
                      toLat: next.lat,
                      toLon: next.lon,
                    )),
                  )
                  .value ??
              const <latlong.LatLng>[]
        : const <latlong.LatLng>[];
    final places = view.filteredPlaces;
    final venueLocked = view.venueLocked;
    final finalChoicePlace = view.finalChoicePlace;
    final mapPlaces = venueLocked
        ? [
            ?finalChoicePlace,
          ].map(PlaceViewMapper.fromPlace).toList(growable: false)
        : PlaceViewMapper.fromPlaces(places);
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
      isOpenRoom: view.isOpen,
      openOwnPoint: view.openOwnPoint,
      openSelfUid: view.openSelfUid,
      openRoute: openRoute,
      openEventPoint: venue?.lat != null && venue?.lon != null
          ? latlong.LatLng(venue!.lat!, venue.lon!)
          : null,
      openNextStepPoint: next == null
          ? null
          : latlong.LatLng(next.lat, next.lon),
      openNextStepName: next?.name,
      openParticipantPoints: view.openParticipantPoints,
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
      event: view.event,
      showMeetingRouteAndRadius: !venueLocked,
    );
  }
}
