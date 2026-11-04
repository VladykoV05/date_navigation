import '../../domain/entities/place_type.dart';
import '../widgets/place_visuals.dart';

class PlaceVisualMapper {
  const PlaceVisualMapper._();

  static String get swimmingPoolWireValue => PlaceType.swimmingPool.wireValue;

  static PlaceVisual fromWireType(String? rawType) {
    return fromPlaceType(PlaceType.tryParse(_canonicalize(rawType)));
  }

  static PlaceVisual fromPlaceType(PlaceType? type) {
    return switch (type) {
      PlaceType.bar => PlaceVisuals.bar,
      PlaceType.restaurant || PlaceType.diner => PlaceVisuals.restaurant,
      PlaceType.fastFood => PlaceVisuals.fastFood,
      PlaceType.cafe || PlaceType.coffeeShop => PlaceVisuals.cafe,
      PlaceType.cinema => PlaceVisuals.cinema,
      PlaceType.museum || PlaceType.gallery => PlaceVisuals.culture,
      PlaceType.theatre => PlaceVisuals.theatre,
      PlaceType.park || PlaceType.garden => PlaceVisuals.park,
      PlaceType.viewpoint => PlaceVisuals.viewpoint,
      PlaceType.fitnessCentre ||
      PlaceType.sportsCentre ||
      PlaceType.sport => PlaceVisuals.sport,
      PlaceType.swimmingPool => PlaceVisuals.pool,
      PlaceType.iceRink => PlaceVisuals.iceRink,
      PlaceType.activeRacket ||
      PlaceType.activeTeam ||
      PlaceType.activeClimb ||
      PlaceType.activeDance ||
      PlaceType.activeMindBody => PlaceVisuals.active,
      _ => PlaceVisuals.fallback,
    };
  }

  /// Maps OSM aliases to canonical [PlaceType.wireValue].
  static String _canonicalize(String? rawType) {
    final normalized = (rawType ?? '').trim().toLowerCase().replaceAll(
      ' ',
      '_',
    );
    return switch (normalized) {
      'pub' || 'biergarten' => PlaceType.bar.wireValue,
      'food_court' => PlaceType.fastFood.wireValue,
      _ => normalized,
    };
  }
}
