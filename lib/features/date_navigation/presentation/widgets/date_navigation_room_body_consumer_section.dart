import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/place.dart';
import '../controller/date_navigation_controller.dart';
import '../controller/providers/date_navigation_provider.dart';
import '../controller/favorites_controller.dart';
import 'confirm_dialog.dart';
import 'place_card.dart';
import 'room_control_panel.dart';
import 'scenario_summary_sheet.dart';
import 'ui_copy.dart';
import 'welcome_view.dart';

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
  final void Function(Place) onPlaceTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final view = ref.watch(dateNavigationRoomBodyViewProvider);
    final favoriteNames = ref.watch(favoritesControllerProvider).toSet();
    final roomId = view.roomId;
    if (roomId == null) {
      return WelcomeView(
        onCreateRoom: controller.createRoom,
        onJoinRoom: onShowJoinDialog,
      );
    }
    final displayCode = view.inviteCode ?? roomId;
    final venueLocked = view.venueLocked;
    final isSessionClosed = view.isSessionClosed;
    final isSessionCompleted = view.sessionStatus == 'completed';
    final sessionClosedLabel = isSessionCompleted
        ? UiCopy.sessionCompletedHint
        : UiCopy.sessionExpiredHint;
    if (venueLocked) {
      final name = view.finalChoiceName;
      final place = view.finalChoicePlace;
      final isCreator = view.isCreator;
      final point1 = view.point1;
      final point2 = view.point2;
      final myPoint = isCreator ? point1 : point2;
      final selectedScenario = view.selectedScenario;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'КОД: $displayCode',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Место согласовано',
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
              isFavorite: favoriteNames.contains(place.name),
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
                          roomId: displayCode,
                          scenario: selectedScenario,
                        ),
                      ),
                    );
                  },
                ),
              ),
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Открыть итоговый план'),
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
                title: 'Покинуть комнату?',
                message:
                    'Вы выйдете из текущей комнаты на этом устройстве и вернетесь на стартовый экран.',
                cancelLabel: UiCopy.noLabel,
                confirmLabel: UiCopy.leaveRoomConfirm,
              );
              if (shouldLeave == true) {
                HapticFeedback.mediumImpact();
                controller.leaveRoom();
                addressController.clear();
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Покинуть комнату'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 80),
        ],
      );
    }
    final panelView = ref.watch(roomControlPanelViewProvider);

    return RoomControlPanel(
      roomId: panelView.roomId,
      isLoading: panelView.isLoading,
      isGeocoding: panelView.isGeocoding,
      isCalculatingMeeting: panelView.isCalculatingMeeting,
      isLoadingRoomAction: panelView.isLoadingRoomAction,
      addressController: addressController,
      onAddressSubmit: onSubmitAddress,
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
      onVotePlace: controller.voteForPlace,
      voteCounts: panelView.voteCounts,
      myVotePlaceName: panelView.myVotePlaceName,
      scoreForPlace: controller.scorePlace,
      favoritePlaceNames: favoriteNames,
      isCreator: panelView.isCreator,
      creatorMeetingFormats: panelView.creatorMeetingFormats,
      partnerMeetingFormats: panelView.partnerMeetingFormats,
      commonMeetingFormats: panelView.commonMeetingFormats,
      mySelectedMeetingFormat: panelView.mySelectedMeetingFormat,
      partnerSelectedMeetingFormat: panelView.partnerSelectedMeetingFormat,
      selectedMeetingFormat: panelView.selectedMeetingFormat,
      lastAgreedMeetingFormat: panelView.lastAgreedMeetingFormat,
      meetingRevoteRequestByRole: panelView.meetingRevoteRequestByRole,
      meetingRevoteRequestStatus: panelView.meetingRevoteRequestStatus,
      onMeetingFormatsChanged: controller.setMeetingFormats,
      onMeetingFormatConfirmed: controller.confirmMeetingFormat,
      onLeaveRoom: () {
        controller.leaveRoom();
        addressController.clear();
      },
      isSessionClosed: panelView.isSessionClosed,
      sessionStatus: panelView.sessionStatus,
      isSliverMode: true,
    );
  }

  String _shareScenarioText({
    required String roomId,
    required DateScenario scenario,
  }) {
    final buffer = StringBuffer()
      ..writeln('План встречи в комнате #$roomId')
      ..writeln()
      ..writeln(scenario.title)
      ..writeln(scenario.description)
      ..writeln('Длительность: ${scenario.totalDurationMinutes} мин');
    if (scenario.anchorPlace != null) {
      buffer.writeln('Место: ${scenario.anchorPlace!.name}');
      final address = scenario.anchorPlace!.address;
      if (address != null && address.isNotEmpty) {
        buffer.writeln('Адрес: $address');
      }
    }
    if (scenario.steps.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Шаги:');
      for (final step in scenario.steps) {
        final eta = step.etaMinutes == null ? '' : ' (${step.etaMinutes} мин)';
        buffer.writeln('- ${step.title}$eta');
      }
    }
    buffer.writeln();
    buffer.write('Собрано в приложении для встречи');
    return buffer.toString();
  }
}
