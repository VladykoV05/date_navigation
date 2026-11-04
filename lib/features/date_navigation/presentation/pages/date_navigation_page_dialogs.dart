part of 'date_navigation_page.dart';

extension _DateNavigationPageDialogs on _DateNavigationPageState {
  Future<void> _showPeerRadiusSuggestionDialog(int suggestedRadius) async {
    await _runWithDialogLock(_DialogType.peerRadiusSuggestion, () async {
      final controller = ref.read(dateNavigationControllerProvider.notifier);
      final shouldApply = await _showBinaryDecisionDialog(
        title: context.l10n.partnerRadiusSuggestTitle,
        message: context.l10n.partnerRadiusSuggestPrompt(suggestedRadius),
        confirmLabel: context.l10n.partnerRadiusAcceptLabel,
      );
      await _handleBinaryDecision(
        shouldApply,
        onAccept: () async {
          _radiusSuggestionReminderTimer?.cancel();
          await controller.applyPartnerRadiusSuggestion();
        },
        onReject: () => _scheduleRadiusSuggestionReminder(suggestedRadius),
      );
    });
  }

  void _scheduleRadiusSuggestionReminder(int suggestedRadius) {
    _radiusSuggestionReminderTimer?.cancel();
    _radiusSuggestionReminderTimer = Timer(
      const Duration(
        seconds: _DateNavigationPageState._radiusSuggestionReminderSeconds,
      ),
      () {
        if (!mounted) return;
        final currentSuggested = ref.read(
          dateNavigationControllerProvider.select(
            (s) => s.meeting.peerSuggestedRadius,
          ),
        );
        if (currentSuggested == null || currentSuggested != suggestedRadius) {
          return;
        }
        _showActionSnackBar(
          message: context.l10n.partnerRadiusReminder(suggestedRadius),
          actionLabel: context.l10n.openLabel,
          onActionPressed: () {
            unawaited(_showPeerRadiusSuggestionDialog(suggestedRadius));
          },
        );
      },
    );
  }

  Future<void> _showProposalDecisionDialog({
    required String placeName,
    String? placeAddress,
    String? placeType,
  }) async {
    await _runWithDialogLock(_DialogType.partnerPlaceProposal, () async {
      final controller = ref.read(dateNavigationControllerProvider.notifier);
      final decision = await _showBinaryDecisionDialog(
        title: context.l10n.partnerPlaceSuggestTitle,
        message: _buildProposalDialogText(
          placeName: placeName,
          placeAddress: placeAddress,
          placeType: placeType,
        ),
        cancelLabel: context.l10n.rejectLabel,
        confirmLabel: context.l10n.acceptLabel,
      );
      await _handleBinaryDecision(
        decision,
        onAccept: () =>
            controller.respondToProposal(ProposalResponseDecision.accept),
        onReject: () =>
            controller.respondToProposal(ProposalResponseDecision.reject),
      );
    });
  }

  String _buildProposalDialogText({
    required String placeName,
    String? placeAddress,
    String? placeType,
  }) {
    final address = placeAddress?.trim();
    final hasRawType = placeType?.trim().isNotEmpty ?? false;
    final l10n = context.l10n;
    final type = hasRawType ? l10n.placeTypeLabelFromWire(placeType) : null;
    final lines = <String>[
      l10n.proposalPlaceLabel(placeName),
      if (type != null && type.isNotEmpty) l10n.proposalTypeLabel(type),
      if (address != null && address.isNotEmpty)
        l10n.proposalAddressLabel(address),
      '',
      l10n.proposalAcceptQuestion,
    ];
    return lines.join('\n');
  }

  Future<void> _showMeetingRevoteDecisionDialog() async {
    await _runWithDialogLock(_DialogType.meetingRevote, () async {
      final controller = ref.read(dateNavigationControllerProvider.notifier);
      final decision = await _showBinaryDecisionDialog(
        title: context.l10n.meetingRevoteRequestTitle,
        message: context.l10n.meetingRevoteRequestPrompt,
        confirmLabel: context.l10n.yesLabel,
      );
      await _handleBinaryDecision(
        decision,
        onAccept: () => controller.respondMeetingRevote(
          MeetingRevoteResponseDecision.accept,
        ),
        onReject: () => controller.respondMeetingRevote(
          MeetingRevoteResponseDecision.reject,
        ),
      );
    });
  }

  Future<bool?> _showBinaryDecisionDialog({
    required String title,
    required String message,
    String? cancelLabel,
    String? confirmLabel,
  }) {
    return ConfirmDialog.showBinary(
      context,
      title: title,
      message: message,
      cancelLabel: cancelLabel,
      confirmLabel: confirmLabel,
    );
  }

  Future<void> _runWithDialogLock(
    _DialogType dialogType,
    Future<void> Function() action,
  ) async {
    if (!mounted || _activeDialogs.contains(dialogType)) return;
    _activeDialogs.add(dialogType);
    try {
      await action();
    } finally {
      _activeDialogs.remove(dialogType);
    }
  }

  Future<void> _handleBinaryDecision(
    bool? decision, {
    required FutureOr<void> Function() onAccept,
    required FutureOr<void> Function() onReject,
  }) async {
    if (decision == true) {
      HapticFeedback.mediumImpact();
      await Future<void>.sync(onAccept);
      return;
    }
    if (decision == false) {
      HapticFeedback.selectionClick();
      await Future<void>.sync(onReject);
    }
  }

  void _showInfoSnackBar(String message) {
    ShowNotification.showSnackBar(context, message);
  }

  void _showActionSnackBar({
    required String message,
    required String actionLabel,
    required VoidCallback onActionPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: actionLabel, onPressed: onActionPressed),
      ),
    );
  }
}
