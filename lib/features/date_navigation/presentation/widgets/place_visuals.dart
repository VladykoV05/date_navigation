import 'package:flutter/material.dart';

class PlaceVisual {
  const PlaceVisual({
    required this.icon,
    required this.color,
    required this.chipBackground,
  });

  final IconData icon;
  final Color color;
  final Color chipBackground;
}

/// Visual tokens for place types.
class PlaceVisuals {
  const PlaceVisuals._();

  static const bar = PlaceVisual(
    icon: Icons.local_bar,
    color: Color(0xFFB37A2B),
    chipBackground: Color(0xFFF8EEDC),
  );
  static const restaurant = PlaceVisual(
    icon: Icons.restaurant,
    color: Color(0xFFB86A3A),
    chipBackground: Color(0xFFF7E8DE),
  );
  static const fastFood = PlaceVisual(
    icon: Icons.fastfood,
    color: Color(0xFFBA5C5C),
    chipBackground: Color(0xFFF8E6E6),
  );
  static const cafe = PlaceVisual(
    icon: Icons.local_cafe,
    color: Color(0xFF4D7B62),
    chipBackground: Color(0xFFE7F1EA),
  );
  static const cinema = PlaceVisual(
    icon: Icons.movie,
    color: Color(0xFF4F5E90),
    chipBackground: Color(0xFFE9EDF8),
  );
  static const culture = PlaceVisual(
    icon: Icons.museum,
    color: Color(0xFF6757B2),
    chipBackground: Color(0xFFEEEAFB),
  );
  static const theatre = PlaceVisual(
    icon: Icons.theater_comedy,
    color: Color(0xFFA05A84),
    chipBackground: Color(0xFFF6E7EF),
  );
  static const park = PlaceVisual(
    icon: Icons.park,
    color: Color(0xFF5A8A5A),
    chipBackground: Color(0xFFEAF4E8),
  );
  static const viewpoint = PlaceVisual(
    icon: Icons.landscape,
    color: Color(0xFF4E7F82),
    chipBackground: Color(0xFFE4F0F1),
  );
  static const sport = PlaceVisual(
    icon: Icons.fitness_center,
    color: Color(0xFF4E7397),
    chipBackground: Color(0xFFE7EFF8),
  );
  static const pool = PlaceVisual(
    icon: Icons.pool,
    color: Color(0xFF4A8195),
    chipBackground: Color(0xFFE5F2F6),
  );
  static const iceRink = PlaceVisual(
    icon: Icons.ac_unit,
    color: Color(0xFF5F8BA5),
    chipBackground: Color(0xFFE8F1F7),
  );
  static const active = PlaceVisual(
    icon: Icons.sports,
    color: Color(0xFFB06649),
    chipBackground: Color(0xFFF7ECE7),
  );
  static const fallback = PlaceVisual(
    icon: Icons.place,
    color: Color(0xFF657286),
    chipBackground: Color(0xFFEAEFF3),
  );
}
