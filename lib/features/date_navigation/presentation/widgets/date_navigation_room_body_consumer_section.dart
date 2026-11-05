import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/app_services_di.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core_ui/core_ui.dart';
import '../mappers/place_view_mapper.dart';
import '../view_data/place_view_data.dart';
import '../controllers/date_navigation_controller.dart';
import '../providers/date_navigation_provider.dart';
import '../providers/meeting_favorites_provider.dart';
import './place_card.dart';
import './room_control_panel.dart';
import './scenario_summary_sheet.dart';
import './welcome_view.dart';
import '../pages/chat_page.dart';
import '../providers/chat_provider.dart';
import '../pages/open_sessions_page.dart';
import 'open_session/open_session_panel.dart';

class DateNavigationRoomBodyConsumerSection extends ConsumerWidget {
  const DateNavigationRoomBodyConsumerSection({
    super.key,
    required this.controller,
    required this.addressController,
    required this.onSubmitAddress,
    required this.onAddressSuggestionSelected,
    required this.onShowJoinDialog,
    required this.onPlaceTap,
  });

  final DateNavigationController controller;
  final TextEditingController addressController;
  final VoidCallback onSubmitAddress;
  final ValueChanged<String> onAddressSuggestionSelected;
  final VoidCallback onShowJoinDialog;
  final void Function(PlaceViewData) onPlaceTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final view = ref.watch(dateNavigationRoomBodyViewProvider);
    final favoriteState = ref.watch(meetingFavoritesControllerProvider);
    final roomId = view.roomId;
    if (roomId == null) {
      return WelcomeView(
        onCreateRoom: controller.createRoom,
        onJoinRoom: onShowJoinDialog,
        onOpenSessions: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const OpenSessionsPage()),
        ),
      );
    }
    final displayCode = (view.inviteCode?.isNotEmpty ?? false)
        ? view.inviteCode!
        : roomId;
    if (view.isOpen) {
      final unread = ref.watch(chatUnreadCountProvider(roomId));
      return OpenSessionPanel(
        displayCode: displayCode,
        participants: view.openParticipants,
        selfUid: view.selfUid,
        hasOwnPoint: view.openOwnPoint != null,
        canSubmitAddress:
            !view.isSessionClosed &&
            !view.isGeocoding &&
            !view.isLoadingRoomAction,
        addressController: addressController,
        onAddressSubmit: onSubmitAddress,
        onOpenChat: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                ChatPage(roomId: roomId, readOnly: view.isSessionClosed),
          ),
        ),
        onLeaveRoom: () {
          controller.leaveRoom();
          addressController.clear();
        },
        unreadCount: unread,
        event: view.event,
        canLeave:
            !view.isCreator ||
            view.isSessionClosed ||
            view.openParticipants.length >= 2,
        isClosed: view.isSessionClosed,
        canComplete: view.isCreator && !view.isSessionClosed,
        onCompleteSession: () => unawaited(controller.completeSession()),
      );
    }
    final venueLocked = view.venueLocked;
    final isSessionClosed = view.isSessionClosed;
    final isSessionCompleted = view.sessionStatus.isCompleted;
    final l10n = context.l10n;
    final sessionClosedLabel = isSessionCompleted
        ? l10n.sessionCompletedHint
        : l10n.sessionExpiredHint;
    if (venueLocked) {
      final name = view.finalChoiceName;
      final place = view.finalChoicePlace == null
          ? null
          : PlaceViewMapper.fromPlace(view.finalChoicePlace!);
      final isCreator = view.isCreator;
      final point1 = view.point1;
      final point2 = view.point2;
      final myPoint = isCreator ? point1 : point2;
      final selectedScenario = view.selectedScenario == null
          ? null
          : PlaceViewMapper.fromScenario(view.selectedScenario!);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.roomCodeLabel(displayCode),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.venueAgreedTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (place != null)
            PlaceCard(
              place: place,
              onTap: () => onPlaceTap(place),
              userLocation: myPoint,
              score: null,
              onVote: null,
              voteCount: 0,
              isVotedByMe: false,
              isFavorite: favoriteState.containsPlace(
                placeName: place.name,
                lat: place.lat,
                lon: place.lon,
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  name ?? '',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          if (selectedScenario != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                showDragHandle: false,
                builder: (sheetContext) => ScenarioSummarySheet(
                  roomId: displayCode,
                  scenario: selectedScenario,
                  onSharePressed: () {
                    Navigator.of(sheetContext).pop();
                    SharePlus.instance.share(
                      ShareParams(
                        text: _shareScenarioText(
                          context: context,
                          roomId: displayCode,
                          scenario: selectedScenario,
                        ),
                      ),
                    );
                  },
                ),
              ),
              icon: const Icon(Icons.receipt_long_outlined),
              label: Text(l10n.openFinalPlan),
            ),
          ],
          const SizedBox(height: 16),
          if (isSessionClosed)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Text(
                sessionClosedLabel,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final shouldLeave = await ConfirmDialog.showBinary(
                context,
                title: l10n.leaveRoomTitle,
                message: l10n.leaveRoomMessage,
                cancelLabel: l10n.noLabel,
                confirmLabel: l10n.leaveRoomConfirm,
              );
              if (shouldLeave == true) {
                HapticFeedback.mediumImpact();
                controller.leaveRoom();
                addressController.clear();
              }
            },
            icon: const Icon(Icons.logout),
            label: Text(l10n.leaveRoomButton),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 80),
        ],
      );
    }
    final panelView = ref.watch(roomControlPanelViewProvider);
    final unreadCount = ref.watch(chatUnreadCountProvider(roomId));

    return RoomControlPanel(
      roomId: panelView.roomId,
      isLoading: panelView.isLoading,
      isGeocoding: panelView.isGeocoding,
      isLocating: panelView.isGeocoding,
      isCalculatingMeeting: panelView.isCalculatingMeeting,
      isLoadingRoomAction: panelView.isLoadingRoomAction,
      addressController: addressController,
      onAddressSubmit: onSubmitAddress,
      onUseCurrentLocation: () => unawaited(controller.submitMyLocation()),
      recentAddresses: panelView.recentAddresses,
      onAddressSuggestionSelected: onAddressSuggestionSelected,
      onAddressSuggestionDeleted: controller.removeRememberedAddress,
      onAddressSuggestionsDeleted: controller.removeRememberedAddresses,
      places: panelView.places,
      selectedType: panelView.selectedType,
      onTypeChanged: controller.setSelectedType,
      onPlaceTap: onPlaceTap,
      myLocation: panelView.myLocation,
      hasPartner: panelView.hasPartner,
      searchRadius: panelView.searchRadius,
      onSearchRadiusChanged: controller.setSearchRadius,
      onSearchRadiusChangeEnd: controller.recalculateForRadius,
      onRetryPlaces: controller.recalculateForRadius,
      onExpandRadiusAndRetry: controller.expandSearchRadiusAndRetry,
      onVotePlace: (place) =>
          controller.voteForPlace(PlaceViewMapper.toPlace(place)),
      voteCounts: panelView.voteCounts,
      myVotePlaceName: panelView.myVotePlaceName,
      scoreForPlace: (place) =>
          controller.scorePlace(PlaceViewMapper.toPlace(place)),
      isFavoritePlace: (place) => favoriteState.containsPlace(
        placeName: place.name,
        lat: place.lat,
        lon: place.lon,
      ),
      isCreator: panelView.isCreator,
      event: panelView.event,
      unreadCount: unreadCount,
      onOpenChat: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => ChatPage(roomId: roomId))),
      onOpenEventRoute:
          panelView.event?.lat != null && panelView.event?.lon != null
          ? () {
              final my = panelView.myLocation;
              if (my == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.focusPointMissing)),
                );
                return;
              }
              unawaited(
                ref
                    .read(navigationServiceProvider)
                    .openYandexMaps(
                      startLat: my.latitude,
                      startLon: my.longitude,
                      endLat: panelView.event!.lat!,
                      endLon: panelView.event!.lon!,
                    ),
              );
            }
          : null,
      creatorMeetingFormats: panelView.creatorMeetingFormats,
      partnerMeetingFormats: panelView.partnerMeetingFormats,
      commonMeetingFormats: panelView.commonMeetingFormats,
      mySelectedMeetingFormat: panelView.mySelectedMeetingFormat,
      partnerSelectedMeetingFormat: panelView.partnerSelectedMeetingFormat,
      selectedMeetingFormat: panelView.selectedMeetingFormat,
      lastAgreedMeetingFormat: panelView.lastAgreedMeetingFormat,
      meetingRevoteRequestByRole: panelView.meetingRevoteRequestByRole,
      meetingRevoteRequestStatus: panelView.meetingRevoteRequestStatus,
      onMeetingFormatsChanged: (formats) => controller.setMeetingFormats(
        PlaceViewMapper.toMeetingFormats(formats),
      ),
      onMeetingFormatConfirmed: (format) => controller.confirmMeetingFormat(
        PlaceViewMapper.toMeetingFormat(format),
      ),
      onLeaveRoom: () {
        controller.leaveRoom();
        addressController.clear();
      },
      isSessionClosed: panelView.isSessionClosed,
      sessionStatus: panelView.sessionStatus,
    );
  }

  String _shareScenarioText({
    required BuildContext context,
    required String roomId,
    required ScenarioViewData scenario,
  }) {
    final l10n = context.l10n;
    final buffer = StringBuffer()
      ..writeln(l10n.sharePlanHeader(roomId))
      ..writeln()
      ..writeln(scenario.title)
      ..writeln(scenario.description)
      ..writeln(l10n.sharePlanDuration(scenario.totalDurationMinutes));
    if (scenario.anchorPlace != null) {
      buffer.writeln(l10n.sharePlanPlace(scenario.anchorPlace!.name));
      final address = scenario.anchorPlace!.address;
      if (address != null && address.isNotEmpty) {
        buffer.writeln(l10n.sharePlanAddress(address));
      }
    }
    if (scenario.steps.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(l10n.sharePlanSteps);
      for (final step in scenario.steps) {
        final eta = step.etaMinutes == null
            ? ''
            : ' ${l10n.minutesShort(step.etaMinutes!)}';
        buffer.writeln('- ${step.title}$eta');
      }
    }
    buffer.writeln();
    buffer.write(l10n.sharePlanFooter);
    return buffer.toString();
  }
}
