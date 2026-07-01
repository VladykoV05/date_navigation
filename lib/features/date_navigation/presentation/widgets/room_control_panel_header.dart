import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/ui_tokens.dart';
import './confirm_dialog.dart';
import './ui_copy.dart';

class RoomControlPanelHeader extends StatelessWidget {
  const RoomControlPanelHeader({
    super.key,
    required this.roomId,
    required this.isLoading,
    required this.isGeocoding,
    required this.isCalculatingMeeting,
    required this.isLoadingRoomAction,
    required this.isSessionClosed,
    required this.sessionClosedText,
    required this.onLeaveRoom,
  });

  static const double _loadingIndicatorSize = 20;
  static const double _sessionClosedBannerPadding = 10;
  static const double _actionIconSize = 18;

  final String roomId;
  final bool isLoading;
  final bool isGeocoding;
  final bool isCalculatingMeeting;
  final bool isLoadingRoomAction;
  final bool isSessionClosed;
  final String sessionClosedText;
  final VoidCallback onLeaveRoom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'КОД: $roomId',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: _loadingIndicatorSize,
                height: _loadingIndicatorSize,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        if (isSessionClosed) ...[
          const SizedBox(height: UiSpace.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(_sessionClosedBannerPadding),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(UiRadius.md),
            ),
            child: Text(
              sessionClosedText,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: UiSpace.sm),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: isLoadingRoomAction
                  ? null
                  : () => _confirmLeave(context),
              icon: const Icon(Icons.logout, size: _actionIconSize),
              label: const Text('Покинуть комнату'),
            ),
          ),
        ],
        if (isGeocoding || isCalculatingMeeting || isLoadingRoomAction) ...[
          const SizedBox(height: 8),
          Text(
            _statusText(),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmLeave(BuildContext context) async {
    final shouldLeave = await ConfirmDialog.showBinary(
      context,
      title: UiCopy.leaveRoomTitle,
      message: UiCopy.leaveRoomMessage,
      cancelLabel: UiCopy.noLabel,
      confirmLabel: UiCopy.leaveRoomConfirm,
    );
    if (shouldLeave == true) {
      HapticFeedback.mediumImpact();
      onLeaveRoom();
    }
  }

  String _statusText() {
    if (isGeocoding) return UiCopy.loadingGeocoding;
    if (isCalculatingMeeting) return UiCopy.loadingMeeting;
    if (isLoadingRoomAction) return UiCopy.loadingRoomSync;
    return UiCopy.loadingGeneric;
  }
}
