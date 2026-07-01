import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/ui_tokens.dart';
import '../../config/format_chip_config.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../view_data/place_view_data.dart';
import './confirm_dialog.dart';
import './place_card.dart';
import './room_control_panel_header.dart';
import './ui_copy.dart';

part 'room_control_panel_parts.dart';

class RoomControlPanel extends StatelessWidget {
  static const double _radiusMin = 200;
  static const double _radiusMax = 3000;
  static const int _radiusDivisions = 14;
  static const int _undoDeletionSeconds = 5;
  static const double _waitingParticipantPadding = 30;
  static const double _actionIconSize = 18;
  static const double _topAddressesHeight = 36;
  static const double _addressChipIconSize = 16;
  static const double _emptyStateVerticalPadding = 16;
  static const double _partnerPlacesBottomSpacing = 100;

  final String roomId;
  final bool isLoading;
  final bool isGeocoding;
  final bool isCalculatingMeeting;
  final bool isLoadingRoomAction;
  final TextEditingController addressController;
  final VoidCallback onAddressSubmit;
  final List<String> recentAddresses;
  final ValueChanged<String> onAddressSuggestionSelected;
  final Future<void> Function(String address) onAddressSuggestionDeleted;
  final Future<void> Function(Iterable<String> addresses)
  onAddressSuggestionsDeleted;
  final List<PlaceViewData> places;
  final String? selectedType;
  final void Function(String?) onTypeChanged;
  final void Function(PlaceViewData) onPlaceTap;
  final GeoCoordinate? myLocation;
  final bool hasPartner;
  final bool isSliverMode;
  final double searchRadius;
  final ValueChanged<double> onSearchRadiusChanged;
  final VoidCallback onSearchRadiusChangeEnd;
  final VoidCallback onRetryPlaces;
  final void Function(PlaceViewData) onVotePlace;
  final Map<String, int> voteCounts;
  final String? myVotePlaceName;
  final double Function(PlaceViewData) scoreForPlace;
  final bool Function(PlaceViewData place) isFavoritePlace;
  final List<MeetingFormatView> creatorMeetingFormats;
  final List<MeetingFormatView> partnerMeetingFormats;
  final List<MeetingFormatView> commonMeetingFormats;
  final MeetingFormatView? mySelectedMeetingFormat;
  final MeetingFormatView? partnerSelectedMeetingFormat;
  final MeetingFormatView? selectedMeetingFormat;
  final MeetingFormatView? lastAgreedMeetingFormat;
  final String? meetingRevoteRequestByRole;
  final RevoteRequestStatusView? meetingRevoteRequestStatus;
  final ValueChanged<Set<MeetingFormatView>> onMeetingFormatsChanged;
  final ValueChanged<MeetingFormatView> onMeetingFormatConfirmed;
  final bool isSessionClosed;
  final SessionStatusView sessionStatus;
  final bool isCreator;
  final VoidCallback onLeaveRoom;

  const RoomControlPanel({
    super.key,
    required this.roomId,
    required this.isLoading,
    required this.isGeocoding,
    required this.isCalculatingMeeting,
    required this.isLoadingRoomAction,
    required this.addressController,
    required this.onAddressSubmit,
    required this.recentAddresses,
    required this.onAddressSuggestionSelected,
    required this.onAddressSuggestionDeleted,
    required this.onAddressSuggestionsDeleted,
    required this.places,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onPlaceTap,
    required this.myLocation,
    required this.hasPartner,
    required this.searchRadius,
    required this.onSearchRadiusChanged,
    required this.onSearchRadiusChangeEnd,
    required this.onRetryPlaces,
    required this.onVotePlace,
    required this.voteCounts,
    required this.myVotePlaceName,
    required this.scoreForPlace,
    required this.isFavoritePlace,
    required this.creatorMeetingFormats,
    required this.partnerMeetingFormats,
    required this.commonMeetingFormats,
    required this.mySelectedMeetingFormat,
    required this.partnerSelectedMeetingFormat,
    required this.selectedMeetingFormat,
    required this.lastAgreedMeetingFormat,
    required this.meetingRevoteRequestByRole,
    required this.meetingRevoteRequestStatus,
    required this.onMeetingFormatsChanged,
    required this.onMeetingFormatConfirmed,
    required this.isSessionClosed,
    required this.sessionStatus,
    required this.isCreator,
    required this.onLeaveRoom,
    this.isSliverMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final canSubmitAddress =
        !isSessionClosed && !isGeocoding && !isLoadingRoomAction;
    final isMeetingFormatMatched = selectedMeetingFormat != null;
    final canSelectMeetingFormat = !isSessionClosed && !isLoadingRoomAction;
    final canInteractMeeting =
        !isSessionClosed && !isLoading && isMeetingFormatMatched;
    final hasPlacesInSelectedCategory =
        selectedType == null ||
        places.any((place) => place.matchesType(selectedType));
    final topAddresses = recentAddresses.take(5).toList(growable: false);
    final otherAddresses = recentAddresses.skip(5).toList(growable: false);
    final sessionClosedText = sessionStatus.isCompleted
        ? UiCopy.sessionClosedActionsDisabled
        : UiCopy.sessionExpiredActionsDisabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoomControlPanelHeader(
          roomId: roomId,
          isLoading: isLoading,
          isGeocoding: isGeocoding,
          isCalculatingMeeting: isCalculatingMeeting,
          isLoadingRoomAction: isLoadingRoomAction,
          isSessionClosed: isSessionClosed,
          sessionClosedText: sessionClosedText,
          onLeaveRoom: onLeaveRoom,
        ),
        _buildAddressSection(
          context,
          canSubmitAddress: canSubmitAddress,
          topAddresses: topAddresses,
          otherAddresses: otherAddresses,
        ),
        const SizedBox(height: UiSpace.lg),
        if (hasPartner)
          _buildPartnerMeetingSection(
            context,
            canInteractMeeting: canInteractMeeting,
            canSelectMeetingFormat: canSelectMeetingFormat,
            isMeetingFormatMatched: isMeetingFormatMatched,
            hasPlacesInSelectedCategory: hasPlacesInSelectedCategory,
          )
        else
          Center(
            child: Padding(
              padding: const EdgeInsets.all(_waitingParticipantPadding),
              child: Text(
                UiCopy.waitSecondParticipant,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPartnerMeetingSection(
    BuildContext context, {
    required bool canInteractMeeting,
    required bool canSelectMeetingFormat,
    required bool isMeetingFormatMatched,
    required bool hasPlacesInSelectedCategory,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Радиус поиска',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: _radiusMin,
                max: _radiusMax,
                divisions: _radiusDivisions,
                value: searchRadius.clamp(_radiusMin, _radiusMax),
                label: '${searchRadius.round()} м',
                onChanged: canInteractMeeting ? onSearchRadiusChanged : null,
                onChangeEnd: canInteractMeeting
                    ? (_) => onSearchRadiusChangeEnd()
                    : null,
              ),
            ),
            Text(
              '${searchRadius.round()} м',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: UiSpace.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Места для встречи',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: canInteractMeeting ? onRetryPlaces : null,
              icon: const Icon(Icons.refresh, size: _actionIconSize),
              label: const Text('Повторить'),
            ),
          ],
        ),
        const SizedBox(height: UiSpace.sm),
        _buildDateAssistantSection(
          context,
          canSelectMeetingFormat: canSelectMeetingFormat,
        ),
        if (isMeetingFormatMatched)
          _PlaceTypeFilterChips(
            selectedMeetingFormat: selectedMeetingFormat,
            selectedType: selectedType,
            isSessionClosed: isSessionClosed,
            onTypeChanged: onTypeChanged,
          ),
        const SizedBox(height: UiSpace.sm),
        _buildPlacesSection(
          context,
          isMeetingFormatMatched: isMeetingFormatMatched,
          canInteractMeeting: canInteractMeeting,
          hasPlacesInSelectedCategory: hasPlacesInSelectedCategory,
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: _partnerPlacesBottomSpacing),
      ],
    );
  }

  Widget _buildPlacesSection(
    BuildContext context, {
    required bool isMeetingFormatMatched,
    required bool canInteractMeeting,
    required bool hasPlacesInSelectedCategory,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    if (!isMeetingFormatMatched) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: _emptyStateVerticalPadding,
        ),
        child: Text(
          UiCopy.pickSameFormatFirst,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
    if (places.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: places.length,
        separatorBuilder: (_, _) => const SizedBox(height: UiSpace.sm),
        itemBuilder: (_, i) {
          final place = places[i];
          return PlaceCard(
            place: place,
            onTap: () => onPlaceTap(place),
            userLocation: myLocation,
            score: scoreForPlace(place),
            onVote: canInteractMeeting ? () => onVotePlace(place) : null,
            voteCount: voteCounts[place.name] ?? 0,
            isVotedByMe: myVotePlaceName == place.name,
            isFavorite: isFavoritePlace(place),
            selectedTypeContext: selectedType,
          );
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _emptyStateVerticalPadding),
      child: Text(
        isCalculatingMeeting
            ? UiCopy.loadingNearbyPlaces
            : selectedType != null && !hasPlacesInSelectedCategory
            ? UiCopy.noResultsInCategory
            : UiCopy.noResultsInRadius,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildAddressSection(
    BuildContext context, {
    required bool canSubmitAddress,
    required List<String> topAddresses,
    required List<String> otherAddresses,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: UiSpace.md),
        TextField(
          controller: addressController,
          enabled: canSubmitAddress,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.streetAddress,
          onSubmitted: (_) {
            if (canSubmitAddress) onAddressSubmit();
          },
          decoration: InputDecoration(
            labelText: 'Адрес',
            hintText: 'Например: Минск, ул. Ленина 10',
            helperText:
                'Введите ваш точный адрес, чтобы найти общую точку встречи',
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UiRadius.md),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.send, color: colorScheme.primary),
              onPressed: canSubmitAddress ? onAddressSubmit : null,
            ),
          ),
        ),
        if (topAddresses.isNotEmpty) ...[
          const SizedBox(height: UiSpace.sm),
          Text(
            'Частые адреса',
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: UiSpace.xs),
          SizedBox(
            height: _topAddressesHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: topAddresses.length,
              separatorBuilder: (_, _) => const SizedBox(width: UiSpace.xs),
              itemBuilder: (_, index) {
                final address = topAddresses[index];
                return ActionChip(
                  avatar: Icon(
                    Icons.history,
                    size: _addressChipIconSize,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  label: Text(address, overflow: TextOverflow.ellipsis),
                  onPressed: canSubmitAddress
                      ? () => onAddressSuggestionSelected(address)
                      : null,
                );
              },
            ),
          ),
          if (otherAddresses.isNotEmpty) ...[
            const SizedBox(height: UiSpace.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: canSubmitAddress
                    ? () => _showOtherAddressesSheet(
                        context,
                        addresses: otherAddresses,
                      )
                    : null,
                icon: const Icon(Icons.list_alt),
                label: Text(
                  '${UiCopy.otherAddressesLabel} (${otherAddresses.length})',
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildDateAssistantSection(
    BuildContext context, {
    required bool canSelectMeetingFormat,
  }) {
    final myFormats = isCreator ? creatorMeetingFormats : partnerMeetingFormats;
    final partnerFormats = isCreator
        ? partnerMeetingFormats
        : creatorMeetingFormats;
    return _DateAssistantSection(
      myFormats: myFormats,
      selectedMeetingFormat: selectedMeetingFormat,
      mySelectedMeetingFormat: mySelectedMeetingFormat,
      partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
      commonMeetingFormats: commonMeetingFormats,
      canSelectMeetingFormat: canSelectMeetingFormat,
      statusText: _formatStatusText(
        myFormats: myFormats,
        partnerFormats: partnerFormats,
        myConfirmedFormat: mySelectedMeetingFormat,
        lastAgreedFormat: lastAgreedMeetingFormat,
        meetingRevoteRequestByRole: meetingRevoteRequestByRole,
        meetingRevoteRequestStatus: meetingRevoteRequestStatus,
      ),
      confirmationText: _compactConfirmationLine(
        myConfirmed: mySelectedMeetingFormat,
        partnerConfirmed: partnerSelectedMeetingFormat,
      ),
      onToggleMeetingFormat: _toggleMeetingFormat,
      onMeetingFormatConfirmed: onMeetingFormatConfirmed,
    );
  }

  void _toggleMeetingFormat(MeetingFormatView format) {
    final current = isCreator ? creatorMeetingFormats : partnerMeetingFormats;
    final next = <MeetingFormatView>{...current};
    if (next.contains(format)) {
      next.remove(format);
    } else {
      next.add(format);
    }
    onMeetingFormatsChanged(next);
  }

  Future<void> _showOtherAddressesSheet(
    BuildContext context, {
    required List<String> addresses,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _OtherAddressesSheetContent(
        addresses: addresses,
        onAddressSelected: (address) {
          onAddressSuggestionSelected(address);
          Navigator.of(sheetContext).pop();
        },
        onDeleteOne: (address) async {
          await _deleteWithUndo(
            context: context,
            addresses: [address],
            message: 'Адрес будет удален через $_undoDeletionSeconds секунд',
          );
          if (sheetContext.mounted) {
            Navigator.of(sheetContext).pop();
          }
        },
        onDeleteAll: () async {
          final shouldClear = await ConfirmDialog.showBinary(
            sheetContext,
            title: UiCopy.clearOtherAddressesTitle,
            message: UiCopy.clearOtherAddressesMessage,
            cancelLabel: UiCopy.cancelLabel,
            confirmLabel: UiCopy.clearLabel,
          );
          if (!sheetContext.mounted || shouldClear != true) return;
          await _deleteWithUndo(
            context: context,
            addresses: addresses,
            message: 'Адреса будут удалены через $_undoDeletionSeconds секунд',
          );
          if (sheetContext.mounted) {
            Navigator.of(sheetContext).pop();
          }
        },
      ),
    );
  }

  Future<void> _deleteWithUndo({
    required BuildContext context,
    required Iterable<String> addresses,
    required String message,
  }) async {
    final normalized = addresses
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
    if (normalized.isEmpty) return;
    var undone = false;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: _undoDeletionSeconds),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            undone = true;
          },
        ),
      ),
    );
    await Future<void>.delayed(const Duration(seconds: _undoDeletionSeconds));
    if (undone) return;
    if (normalized.length == 1) {
      await onAddressSuggestionDeleted(normalized.first);
      return;
    }
    await onAddressSuggestionsDeleted(normalized);
  }

  String _formatStatusText({
    required List<MeetingFormatView> myFormats,
    required List<MeetingFormatView> partnerFormats,
    required MeetingFormatView? myConfirmedFormat,
    required MeetingFormatView? lastAgreedFormat,
    required String? meetingRevoteRequestByRole,
    required RevoteRequestStatusView? meetingRevoteRequestStatus,
  }) {
    if (meetingRevoteRequestStatus?.isPending ?? false) {
      final requestedByMe =
          (isCreator && meetingRevoteRequestByRole == 'creator') ||
          (!isCreator && meetingRevoteRequestByRole == 'partner');
      return requestedByMe
          ? UiCopy.formatStatusRevoteRequestedByMe
          : UiCopy.formatStatusRevoteRequestedByPartner;
    }
    if (myFormats.isEmpty || partnerFormats.isEmpty) {
      return UiCopy.formatStatusSelectBoth;
    }
    if (selectedMeetingFormat != null) {
      return UiCopy.formatStatusAgreed.replaceAll(
        '{format}',
        selectedMeetingFormat!.label,
      );
    }
    if (myConfirmedFormat != null) {
      return UiCopy.formatStatusConfirmedByMe.replaceAll(
        '{format}',
        myConfirmedFormat.label,
      );
    }
    if (commonMeetingFormats.isEmpty) {
      return UiCopy.formatStatusNoCommon;
    }
    if (selectedMeetingFormat == null && lastAgreedFormat != null) {
      return UiCopy.formatStatusRevotingNow.replaceAll(
        '{format}',
        lastAgreedFormat.label,
      );
    }
    return UiCopy.formatStatusReadyToConfirm;
  }

  String _compactConfirmationLine({
    required MeetingFormatView? myConfirmed,
    required MeetingFormatView? partnerConfirmed,
  }) {
    final myText = myConfirmed == null
        ? UiCopy.formatConfirmationMissing
        : myConfirmed.label;
    final partnerText = partnerConfirmed == null
        ? UiCopy.formatConfirmationMissing
        : partnerConfirmed.label;
    return UiCopy.formatConfirmationLine
        .replaceAll('{my}', myText)
        .replaceAll('{partner}', partnerText);
  }
}
