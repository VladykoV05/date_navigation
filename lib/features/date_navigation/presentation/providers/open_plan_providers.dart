import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/date_vibe.dart';
import '../view_data/nearby_place_view_data.dart';

import '../../di/date_navigation_di.dart';
import '../../domain/entities/open_plan.dart';
import '../view_data/open_plan_view_data.dart';

/// Предложения мест в открытой сессии (обновляются в реальном времени).
final openPlanSuggestionsProvider = StreamProvider.autoDispose
    .family<List<PlanSuggestionViewData>, String>((ref, roomId) {
      return ref
          .watch(watchPlaceSuggestionsProvider)
          .call(roomId)
          .map((items) => items.map(_toView).toList(growable: false));
    });

PlanSuggestionViewData _toView(PlaceSuggestion s) => PlanSuggestionViewData(
  id: s.id,
  placeName: s.placeName,
  placeAddress: s.placeAddress,
  proposedBy: s.proposedBy,
  isChosen: s.status == SuggestionStatus.chosen,
  isSuggested: s.status == SuggestionStatus.suggested,
  lat: s.lat,
  lon: s.lon,
);

final openPlanSuggestPlaceProvider = Provider(
  (ref) => ref.watch(suggestPlaceProvider),
);
final openPlanChooseSuggestionProvider = Provider(
  (ref) => ref.watch(chooseSuggestionProvider),
);
final openPlanSetRadiusProvider = Provider(
  (ref) => ref.watch(setPlanRadiusProvider),
);
final openPlanGeocodeProvider = Provider(
  (ref) => ref.watch(geocodeAddressProvider),
);

/// Ключи категорий поиска рядом (значения MeetingFormat.wireValue).
const List<String> openPlanSearchFormats = [
  'food',
  'culture',
  'walk_only',
  'active',
];

Future<Result<List<NearbyPlaceViewData>>> openPlanSearchNearby(
  WidgetRef ref, {
  required double lat,
  required double lon,
  required int radiusMeters,
  required String formatKey,
}) async {
  final format = MeetingFormat.values.firstWhere(
    (f) => f.wireValue == formatKey,
    orElse: () => MeetingFormat.food,
  );
  final result = await ref
      .read(searchNearbyPlacesProvider)
      .call(lat: lat, lon: lon, radiusMeters: radiusMeters, format: format);
  return switch (result) {
    Ok(:final value) => Ok(
      value
          .map(
            (p) => NearbyPlaceViewData(
              name: p.name,
              lat: p.lat,
              lon: p.lon,
              address: p.address,
            ),
          )
          .toList(growable: false),
    ),
    Err(:final failure) => Err(failure),
  };
}

Future<Result<void>> openPlanSetNextStep(
  WidgetRef ref, {
  required String roomId,
  required String name,
  String? address,
  required double lat,
  required double lon,
  required String hostUid,
}) {
  return ref
      .read(setNextStepProvider)
      .call(
        roomId: roomId,
        name: name,
        address: address,
        lat: lat,
        lon: lon,
        hostUid: hostUid,
      );
}
