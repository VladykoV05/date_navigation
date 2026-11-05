import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/deep_links/invite_link.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/ui_tokens.dart';
import '../../../../core_ui/core_ui.dart';

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
    this.onOpenChat,
    this.unreadCount = 0,
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
  final VoidCallback? onOpenChat;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.roomCodeLabel(roomId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ),
            if (onOpenChat != null)
              IconButton(
                tooltip: l10n.chatOpen,
                onPressed: onOpenChat,
                icon: Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text('$unreadCount'),
                  child: const Icon(Icons.chat_bubble_outline),
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoadingRoomAction
                      ? null
                      : () => _shareInvite(context),
                  icon: const Icon(Icons.ios_share, size: _actionIconSize),
                  label: Text(l10n.shareInviteLabel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoadingRoomAction
                      ? null
                      : () => _confirmLeave(context),
                  icon: const Icon(Icons.logout, size: _actionIconSize),
                  label: Text(l10n.leaveRoomButton),
                ),
              ),
            ],
          ),
        ],
        if (isGeocoding || isCalculatingMeeting || isLoadingRoomAction) ...[
          const SizedBox(height: 8),
          Text(
            _statusText(context),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _shareInvite(BuildContext context) async {
    final l10n = context.l10n;
    final link = InviteLink.shareUrl(roomId);
    await SharePlus.instance.share(
      ShareParams(text: l10n.shareInviteMessage(roomId, link)),
    );
  }

  Future<void> _confirmLeave(BuildContext context) async {
    final l10n = context.l10n;
    final shouldLeave = await ConfirmDialog.showBinary(
      context,
      title: l10n.leaveRoomTitle,
      message: l10n.leaveRoomMessage,
      cancelLabel: l10n.noLabel,
      confirmLabel: l10n.leaveRoomConfirm,
    );
    if (shouldLeave == true) {
      HapticFeedback.mediumImpact();
      onLeaveRoom();
    }
  }

  String _statusText(BuildContext context) {
    final l10n = context.l10n;
    if (isGeocoding) return l10n.loadingGeocoding;
    if (isCalculatingMeeting) return l10n.loadingMeeting;
    if (isLoadingRoomAction) return l10n.loadingRoomSync;
    return l10n.loadingGeneric;
  }
}
