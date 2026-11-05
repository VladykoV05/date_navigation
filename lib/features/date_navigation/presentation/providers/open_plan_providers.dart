import 'package:flutter_riverpod/flutter_riverpod.dart';

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
