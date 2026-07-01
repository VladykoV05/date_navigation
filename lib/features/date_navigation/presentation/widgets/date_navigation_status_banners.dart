import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../controller/providers/date_navigation_provider.dart';
import 'ui_copy.dart';

class DateNavigationStatusBanners extends StatelessWidget {
  const DateNavigationStatusBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SessionStatusBanner(),
        _SyncSuggestionsBanner(),
        _ErrorBanner(),
        _CachedDataBanner(),
      ],
    );
  }
}

class _StatusBannerContainer extends StatelessWidget {
  const _StatusBannerContainer({
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class _SyncSuggestionsBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(
      dateNavigationControllerProvider.select(
        (s) => (isSessionClosed: s.roomSession.isClosed),
      ),
    );
    if (view.isSessionClosed) return const SizedBox.shrink();
    return const SizedBox.shrink();
  }
}

class _SessionStatusBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final view = ref.watch(
      dateNavigationControllerProvider.select(
        (s) => (
          sessionStatus: s.roomSession.sessionStatus,
          isLoadingRoomAction: s.loading.isLoadingRoomAction,
        ),
      ),
    );
    final sessionStatus = view.sessionStatus;
    if (sessionStatus.isActive) return const SizedBox.shrink();
    final controller = ref.read(dateNavigationControllerProvider.notifier);
    final text = sessionStatus.isCompleted
        ? UiCopy.sessionCompletedBanner
        : UiCopy.sessionExpiredBanner;
    return _StatusBannerContainer(
      backgroundColor: colorScheme.surfaceContainerHighest,
      borderColor: colorScheme.outlineVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(text)),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: view.isLoadingRoomAction
                  ? null
                  : controller.startNewRoom,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Создать новую комнату'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(
      dateNavigationControllerProvider.select(
        (s) => (
          lastFailure: s.failure.lastFailure,
          failureOperation: s.failure.failureOperation,
          point1: s.roomSession.point1,
          point2: s.roomSession.point2,
        ),
      ),
    );
    final failure = state.lastFailure;
    if (failure == null) return const SizedBox.shrink();

    final canRetry = _canRetryFailure(
      failure: failure,
      failureOperation: state.failureOperation,
      point1: state.point1,
      point2: state.point2,
    );
    final isActionableError = canRetry || failure is ParseFailure;
    final backgroundColor = isActionableError
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final borderColor = isActionableError
        ? colorScheme.error.withValues(alpha: 0.4)
        : colorScheme.outlineVariant;
    return _StatusBannerContainer(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _humanizeFailure(failure),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isActionableError
                  ? colorScheme.onErrorContainer
                  : colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (canRetry)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref
                          .read(dateNavigationControllerProvider.notifier)
                          .recalculateForRadius();
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Повторить'),
                  ),
                ),
              if (canRetry) const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref
                      .read(dateNavigationControllerProvider.notifier)
                      .clearError(),
                  child: const Text('Скрыть'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CachedDataBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(
      dateNavigationControllerProvider.select(
        (s) => (
          lastFailure: s.failure.lastFailure,
          filteredPlaces: s.meeting.filteredPlaces,
        ),
      ),
    );
    final failure = state.lastFailure;
    final hasPlaces = state.filteredPlaces.isNotEmpty;
    final networkRelated =
        failure is TimeoutFailure ||
        failure is RateLimitFailure ||
        failure is NetworkFailure;
    if (!hasPlaces || !networkRelated) return const SizedBox.shrink();

    return _StatusBannerContainer(
      backgroundColor: colorScheme.secondaryContainer.withValues(alpha: 0.55),
      borderColor: colorScheme.secondary.withValues(alpha: 0.35),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              UiCopy.unstableNetworkShowingCached,
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

String _humanizeFailure(Failure failure) {
  return switch (failure) {
    TimeoutFailure() =>
      'Сервер долго отвечает. Попробуй ещё раз через пару секунд.',
    RateLimitFailure() => 'Слишком много запросов. Подожди немного и повтори.',
    NetworkFailure() =>
      'Проблема с сетью или доступом. Проверь интернет и попробуй снова.',
    ParseFailure() => 'Получили неожиданный ответ сервера. Попробуй повторить.',
    UnknownFailure() => failure.message,
  };
}

bool _canRetryFailure({
  required Failure failure,
  required String? failureOperation,
  required Object? point1,
  required Object? point2,
}) {
  final retryable =
      failure is TimeoutFailure ||
      failure is RateLimitFailure ||
      failure is NetworkFailure;
  final hasPoints = point1 != null && point2 != null;
  final op = failureOperation;
  if (!retryable) return false;
  if (op == 'meeting') return hasPoints;
  if (op == 'geocode') return true;
  return false;
}
