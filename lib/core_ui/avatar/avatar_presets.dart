import 'package:flutter/material.dart';

/// 12 встроенных аватаров: цвет + иконка. Индекс сохраняется в профиле.
class AvatarPresets {
  const AvatarPresets._();

  static const int count = 12;

  static const List<Color> _colors = [
    Color(0xFF5B4BDB),
    Color(0xFFE0457B),
    Color(0xFF2AA198),
    Color(0xFFF08C00),
    Color(0xFF3B82F6),
    Color(0xFF16A34A),
    Color(0xFF9333EA),
    Color(0xFFDC2626),
    Color(0xFF0EA5E9),
    Color(0xFF84CC16),
    Color(0xFFDB2777),
    Color(0xFF64748B),
  ];

  static const List<IconData> _icons = [
    Icons.pets,
    Icons.local_florist,
    Icons.star,
    Icons.favorite,
    Icons.music_note,
    Icons.sports_soccer,
    Icons.coffee,
    Icons.camera_alt,
    Icons.beach_access,
    Icons.wb_sunny,
    Icons.nightlight_round,
    Icons.directions_bike,
  ];

  static Color colorOf(int index) => _colors[_safe(index)];

  static IconData iconOf(int index) => _icons[_safe(index)];

  static int _safe(int index) => index.clamp(0, count - 1);
}
