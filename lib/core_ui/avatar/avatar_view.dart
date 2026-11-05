import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'avatar_presets.dart';

/// Аватар по приоритету: галерея → встроенный → Google-фото → инициал.
/// Работает только с примитивами, без доменных сущностей.
class AvatarView extends StatelessWidget {
  const AvatarView({
    super.key,
    required this.name,
    this.photoUrl,
    this.avatarBase64,
    this.avatarPreset,
    this.radius = 16,
  });

  final String? name;
  final String? photoUrl;
  final String? avatarBase64;
  final int? avatarPreset;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = radius * 2;
    final gallery = _decode(avatarBase64);
    if (gallery != null) {
      return ClipOval(
        child: Image.memory(
          gallery,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    final preset = avatarPreset;
    if (preset != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AvatarPresets.colorOf(preset),
        child: Icon(
          AvatarPresets.iconOf(preset),
          color: Colors.white,
          size: radius,
        ),
      );
    }
    final photo = photoUrl;
    if (photo != null) {
      return ClipOval(
        child: Image.network(
          photo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _initial(scheme),
        ),
      );
    }
    return _initial(scheme);
  }

  Widget _initial(ColorScheme scheme) {
    final value = name ?? '';
    final letter = value.isEmpty ? '?' : value.substring(0, 1).toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      child: Text(letter),
    );
  }

  static Uint8List? _decode(String? base64) {
    if (base64 == null || base64.isEmpty) return null;
    try {
      return base64Decode(base64);
    } on FormatException {
      return null;
    }
  }
}
