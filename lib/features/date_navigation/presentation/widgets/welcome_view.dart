import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';

class WelcomeView extends StatelessWidget {
  final VoidCallback onCreateRoom;
  final VoidCallback onJoinRoom;
  final VoidCallback onOpenSessions;

  const WelcomeView({
    super.key,
    required this.onCreateRoom,
    required this.onJoinRoom,
    required this.onOpenSessions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          l10n.welcomeTitle,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.welcomeSubtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onCreateRoom,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(l10n.welcomeCreateMeeting),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onJoinRoom, child: Text(l10n.welcomeJoinByCode)),
        TextButton(
          onPressed: onOpenSessions,
          child: Text(l10n.openSessionsTitle),
        ),
      ],
    );
  }
}
