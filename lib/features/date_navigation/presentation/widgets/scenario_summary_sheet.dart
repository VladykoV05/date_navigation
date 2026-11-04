import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/ui_tokens.dart';
import '../view_data/place_view_data.dart';

class ScenarioSummarySheet extends StatelessWidget {
  const ScenarioSummarySheet({
    super.key,
    required this.roomId,
    required this.scenario,
    required this.onSharePressed,
  });

  final String roomId;
  final ScenarioViewData scenario;
  final VoidCallback onSharePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final anchor = scenario.anchorPlace;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: UiSpace.md),
            Text(
              l10n.scenarioPlanTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: UiSpace.xs),
            Text(
              l10n.scenarioRoomLabel(roomId),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: UiSpace.md),
            Text(
              scenario.title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: UiSpace.xs),
            Text(scenario.description, style: textTheme.bodyMedium),
            const SizedBox(height: UiSpace.xs),
            Text(
              l10n.scenarioDuration(scenario.totalDurationMinutes),
              style: textTheme.labelLarge,
            ),
            if (anchor != null) ...[
              const SizedBox(height: UiSpace.sm),
              Text(
                l10n.scenarioAnchor(anchor.name),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (anchor.address != null && anchor.address!.isNotEmpty)
                Text(
                  anchor.address!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
            if (scenario.steps.isNotEmpty) ...[
              const SizedBox(height: UiSpace.md),
              Text(
                l10n.scenarioSteps,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: UiSpace.xs),
              ...List.generate(scenario.steps.length, (index) {
                final step = scenario.steps[index];
                final isLast = index == scenario.steps.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : UiSpace.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 26,
                        child: Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primaryContainer,
                                border: Border.all(color: colorScheme.primary),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 20,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                color: colorScheme.outlineVariant,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: UiSpace.xs),
                      Icon(
                        _stepIcon(step.title),
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: UiSpace.xs),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${step.title}${step.etaMinutes == null ? '' : ' ${l10n.minutesShort(step.etaMinutes!)}'}',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: UiSpace.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSharePressed,
                icon: const Icon(Icons.share_outlined),
                label: Text(l10n.sharePlan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _stepIcon(String title) {
    final normalized = title.toLowerCase();
    if (normalized.contains('прогул') || normalized.contains('walk')) {
      return Icons.directions_walk;
    }
    if (normalized.contains('кофе') ||
        normalized.contains('coffee') ||
        normalized.contains('food') ||
        normalized.contains('еда') ||
        normalized.contains('ужин') ||
        normalized.contains('dinner')) {
      return Icons.local_cafe;
    }
    if (normalized.contains('встреч') ||
        normalized.contains('meet') ||
        normalized.contains('gather') ||
        normalized.contains('сбор')) {
      return Icons.handshake_outlined;
    }
    if (normalized.contains('актив') || normalized.contains('active')) {
      return Icons.sports;
    }
    return Icons.place_outlined;
  }
}
