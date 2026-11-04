import 'package:flutter/material.dart';

import '../../domain/entities/place_type.dart';

class PlaceTypeIcons {
  const PlaceTypeIcons._();

  static IconData resolve(PlaceType? placeType) {
    return switch (placeType) {
      null => Icons.tune,
      PlaceType.cafe => Icons.local_cafe,
      PlaceType.restaurant => Icons.restaurant,
      PlaceType.cinema => Icons.movie,
      PlaceType.museum => Icons.museum,
      PlaceType.gallery => Icons.brush,
      PlaceType.theatre => Icons.theater_comedy,
      PlaceType.park => Icons.park,
      PlaceType.viewpoint => Icons.landscape,
      PlaceType.fitnessCentre => Icons.fitness_center,
      PlaceType.sportsCentre => Icons.sports,
      PlaceType.swimmingPool => Icons.pool,
      PlaceType.iceRink => Icons.ac_unit,
      PlaceType.activeRacket => Icons.sports_tennis,
      PlaceType.activeTeam => Icons.groups_2,
      PlaceType.activeClimb => Icons.terrain,
      PlaceType.activeDance => Icons.music_note,
      PlaceType.activeMindBody => Icons.self_improvement,
      _ => Icons.place,
    };
  }

  static IconData resolveWire(String? wireValue) =>
      resolve(PlaceType.tryParse(wireValue));
}
