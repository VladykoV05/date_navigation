import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'avatar_view.dart';
import '../../core/profile/profile_providers.dart';

/// Аватар пользователя из публичного профиля.
class PublicAvatar extends ConsumerWidget {
  const PublicAvatar({super.key, required this.uid, this.radius = 16});

  final String uid;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(publicProfileViewProvider(uid)).value;
    return AvatarView(
      name: profile?.shownName,
      photoUrl: profile?.photoUrl,
      avatarBase64: profile?.avatarBase64,
      avatarPreset: profile?.avatarPreset,
      radius: radius,
    );
  }
}
