import 'package:flutter/material.dart';

class PlaceVisual {
  const PlaceVisual({
    required this.label,
    required this.icon,
    required this.color,
    required this.chipBackground,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color chipBackground;
}

class PlaceVisuals {
  const PlaceVisuals._();

  static PlaceVisual fromType(String? rawType) {
    final type = _normalize(rawType);
    return switch (type) {
      'bar' || 'pub' || 'biergarten' => const PlaceVisual(
        label: 'Бар',
        icon: Icons.local_bar,
        color: Color(0xFFB37A2B),
        chipBackground: Color(0xFFF8EEDC),
      ),
      'restaurant' || 'diner' => const PlaceVisual(
        label: 'Ресторан',
        icon: Icons.restaurant,
        color: Color(0xFFB86A3A),
        chipBackground: Color(0xFFF7E8DE),
      ),
      'fast_food' || 'food_court' => const PlaceVisual(
        label: 'Фастфуд',
        icon: Icons.fastfood,
        color: Color(0xFFBA5C5C),
        chipBackground: Color(0xFFF8E6E6),
      ),
      'cafe' || 'coffee_shop' => const PlaceVisual(
        label: 'Кафе',
        icon: Icons.local_cafe,
        color: Color(0xFF4D7B62),
        chipBackground: Color(0xFFE7F1EA),
      ),
      'cinema' => const PlaceVisual(
        label: 'Кино',
        icon: Icons.movie,
        color: Color(0xFF4F5E90),
        chipBackground: Color(0xFFE9EDF8),
      ),
      'museum' || 'gallery' => const PlaceVisual(
        label: 'Культура',
        icon: Icons.museum,
        color: Color(0xFF6757B2),
        chipBackground: Color(0xFFEEEAFB),
      ),
      'theatre' => const PlaceVisual(
        label: 'Театр',
        icon: Icons.theater_comedy,
        color: Color(0xFFA05A84),
        chipBackground: Color(0xFFF6E7EF),
      ),
      'park' => const PlaceVisual(
        label: 'Парк',
        icon: Icons.park,
        color: Color(0xFF5A8A5A),
        chipBackground: Color(0xFFEAF4E8),
      ),
      'viewpoint' => const PlaceVisual(
        label: 'Видовое место',
        icon: Icons.landscape,
        color: Color(0xFF4E7F82),
        chipBackground: Color(0xFFE4F0F1),
      ),
      'fitness_centre' || 'sports_centre' => const PlaceVisual(
        label: 'Спорт',
        icon: Icons.fitness_center,
        color: Color(0xFF4E7397),
        chipBackground: Color(0xFFE7EFF8),
      ),
      'swimming_pool' => const PlaceVisual(
        label: 'Бассейн',
        icon: Icons.pool,
        color: Color(0xFF4A8195),
        chipBackground: Color(0xFFE5F2F6),
      ),
      'ice_rink' => const PlaceVisual(
        label: 'Каток',
        icon: Icons.ac_unit,
        color: Color(0xFF5F8BA5),
        chipBackground: Color(0xFFE8F1F7),
      ),
      'active_racket' ||
      'active_team' ||
      'active_climb' ||
      'active_dance' ||
      'active_mind_body' => const PlaceVisual(
        label: 'Активность',
        icon: Icons.sports,
        color: Color(0xFFB06649),
        chipBackground: Color(0xFFF7ECE7),
      ),
      _ => const PlaceVisual(
        label: 'Место',
        icon: Icons.place,
        color: Color(0xFF657286),
        chipBackground: Color(0xFFEAEFF3),
      ),
    };
  }

  static String _normalize(String? rawType) {
    return (rawType ?? '').trim().toLowerCase().replaceAll(' ', '_');
  }
}
