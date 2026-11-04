import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../application/policies/failure_retry_policy.dart';
import '../providers/date_navigation_provider.dart';

class DateNavigationStatusBanners extends StatelessWidget {
  const DateNavigationStatusBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SessionStatusBanner(),
        _PresenceStatusBanner(),
        _RoutingDegradedBanner(),
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

class _PresenceStatusBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final view = ref.watch(
      dateNavigationControllerProvider.select(
        (s) => (
          roomId: s.room.roomId,
          isClosed: s.room.isClosed,
          isCreator: s.room.isCreator,
          partnerJoined: s.room.partnerJoined,
          myPoint: s.room.myPoint(),
          partnerPoint: s.room.partnerPoint(),
          myFormats: s.room.isCreator
              ? s.meeting.creatorMeetingFormats
              : s.meeting.partnerMeetingFormats,
          partnerFormats: s.room.isCreator
              ? s.meeting.partnerMeetingFormats
              : s.meeting.creatorMeetingFormats,
          mySelected: s.meeting.mySelectedMeetingFormat(s.room.isCreator),
          partnerSelected: s.room.isCreator
              ? s.meeting.partnerSelectedMeetingFormat
              : s.meeting.creatorSelectedMeetingFormat,
          selectedMeetingFormat: s.meeting.selectedMeetingFormat,
        ),
      ),
    );
    if (view.roomId == null || view.isClosed) return const SizedBox.shrink();

    final l10n = context.l10n;
    String? text;
    if (!view.partnerJoined && view.isCreator) {
      text = l10n.presenceWaitingPartnerJoin;
    } else if (view.partnerJoined && view.partnerPoint == null) {
      text = l10n.presenceWaitingPartnerAddress;
    } else if (view.myPoint == null) {
      text = l10n.presenceWaitingYourAddress;
    } else if (view.myFormats.isEmpty) {
      text = l10n.presenceWaitingYourFormats;
    } else if (view.partnerFormats.isEmpty) {
      text = l10n.presenceWaitingPartnerFormats;
    } else if (view.selectedMeetingFormat == null && view.mySelected == null) {
      text = l10n.presenceWaitingYourFormatConfirm;
    } else if (view.selectedMeetingFormat == null &&
        view.partnerSelected == null) {
      text = l10n.presenceWaitingPartnerFormatConfirm;
    }

    if (text == null) return const SizedBox.shrink();

    return _StatusBannerContainer(
      backgroundColor: colorScheme.secondaryContainer.withValues(alpha: 0.55),
      borderColor: colorScheme.secondary.withValues(alpha: 0.35),
      child: Row(
        children: [
          Icon(Icons.people_outline, size: 18, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutingDegradedBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final degraded = ref.watch(
      dateNavigationControllerProvider.select(
        (s) => s.meeting.isRoutingDegraded && s.meeting.centerPoint != null,
      ),
    );
    if (!degraded) return const SizedBox.shrink();

    return _StatusBannerContainer(
      backgroundColor: colorScheme.tertiaryContainer.withValues(alpha: 0.7),
      borderColor: colorScheme.tertiary.withValues(alpha: 0.4),
      child: Row(
        children: [
          Icon(Icons.alt_route, size: 18, color: colorScheme.tertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.routingDegradedBanner,
              style: TextStyle(color: colorScheme.onTertiaryContainer),
            ),
          ),
          TextButton(
            onPressed: () => ref
                .read(dateNavigationControllerProvider.notifier)
                .recalculateForRadius(),
            child: Text(context.l10n.retryLabel),
          ),
        ],
      ),
    );
  }
}

class _SessionStatusBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final view = ref.watch(
      dateNavigationControllerProvider.select(
        (s) => (
          sessionStatus: s.room.sessionStatus,
          isLoadingRoomAction: s.ui.isLoadingRoomAction,
        ),
      ),
    );
    final sessionStatus = view.sessionStatus;
    if (sessionStatus.isActive) return const SizedBox.shrink();
    final controller = ref.read(dateNavigationControllerProvider.notifier);
    final l10n = context.l10n;
    final text = sessionStatus.isCompleted
        ? l10n.sessionCompletedBanner
        : l10n.sessionExpiredBanner;
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
              label: Text(l10n.createNewRoom),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends ConsumerWidget {
  static const _retryPolicy = FailureRetryPolicy();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(
      dateNavigationControllerProvider.select(
        (s) => (
          lastFailure: s.ui.lastFailure,
          failureOperation: s.ui.failureOperation,
          point1: s.room.point1,
          point2: s.room.point2,
        ),
      ),
    );
    final failure = state.lastFailure;
    if (failure == null) return const SizedBox.shrink();

    final retryAction = _retryPolicy.actionFor(
      failure: failure,
      failureOperation: state.failureOperation,
      hasBothPoints: state.point1 != null && state.point2 != null,
    );
    final canRetry = retryAction != FailureRetryAction.none;
    final isActionableError = canRetry || failure is ParseFailure;
    final backgroundColor = isActionableError
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final borderColor = isActionableError
        ? colorScheme.error.withValues(alpha: 0.4)
        : colorScheme.outlineVariant;
    final hint = switch (state.failureOperation) {
      'geocode' => context.l10n.failureActionEditAddress,
      'room_stream' => context.l10n.failureActionResubscribeRoom,
      'meeting' => context.l10n.failureActionRetryMeeting,
      'join' => context.l10n.inviteInvalidMessage,
      _ => null,
    };
    return _StatusBannerContainer(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.localizeFailure(failure),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isActionableError
                  ? colorScheme.onErrorContainer
                  : colorScheme.onSurface,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(
              hint,
              style: TextStyle(
                color: isActionableError
                    ? colorScheme.onErrorContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              if (canRetry)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => ref
                        .read(dateNavigationControllerProvider.notifier)
                        .retryLastFailure(),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(context.l10n.retryLabel),
                  ),
                ),
              if (canRetry) const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref
                      .read(dateNavigationControllerProvider.notifier)
                      .clearError(),
                  child: Text(context.l10n.dismissLabel),
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
          lastFailure: s.ui.lastFailure,
          filteredPlaces: s.meeting.filteredPlaces,
        ),
      ),
    );
    final failure = state.lastFailure;
    final hasPlaces = state.filteredPlaces.isNotEmpty;
    final networkRelated = failure?.isRetryable ?? false;
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
              context.l10n.unstableNetworkShowingCached,
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
