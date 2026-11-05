import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/ui_tokens.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../view_data/place_view_data.dart';
import '../view_data/room_event_view_data.dart';
import 'room_control/room_address_section.dart';
import 'room_control/room_meeting_places_section.dart';
import 'room_control_panel_header.dart';

class _EventBanner extends StatelessWidget {
  const _EventBanner({required this.event, this.onOpenRoute});

  final RoomEventViewData event;
  final VoidCallback? onOpenRoute;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final subtitle = [
      if (event.venueName != null) event.venueName!,
      if (event.address != null) event.address!,
      if (event.category != null) event.category!,
    ].join(' · ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.openSessionsEvent,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
            if (onOpenRoute != null) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onOpenRoute,
                  icon: const Icon(Icons.directions),
                  label: Text(l10n.openEventRoute),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class RoomControlPanel extends StatelessWidget {
  static const double _waitingParticipantPadding = 30;

  final String roomId;
  final bool isLoading;
  final bool isGeocoding;
  final bool isLocating;
  final bool isCalculatingMeeting;
  final bool isLoadingRoomAction;
  final TextEditingController addressController;
  final VoidCallback onAddressSubmit;
  final VoidCallback onUseCurrentLocation;
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
  final double searchRadius;
  final ValueChanged<double> onSearchRadiusChanged;
  final VoidCallback onSearchRadiusChangeEnd;
  final VoidCallback onRetryPlaces;
  final VoidCallback onExpandRadiusAndRetry;
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
  final RoomEventViewData? event;
  final VoidCallback? onOpenEventRoute;
  final VoidCallback? onOpenChat;
  final int unreadCount;
  final VoidCallback onLeaveRoom;

  const RoomControlPanel({
    super.key,
    required this.roomId,
    required this.isLoading,
    required this.isGeocoding,
    required this.isLocating,
    required this.isCalculatingMeeting,
    required this.isLoadingRoomAction,
    required this.addressController,
    required this.onAddressSubmit,
    required this.onUseCurrentLocation,
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
    required this.onExpandRadiusAndRetry,
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
    required this.event,
    this.onOpenEventRoute,
    this.onOpenChat,
    this.unreadCount = 0,
    required this.onLeaveRoom,
  });

  @override
  Widget build(BuildContext context) {
    final canSubmitAddress =
        !isSessionClosed && !isGeocoding && !isLoadingRoomAction;
    final canSelectMeetingFormat = !isSessionClosed && !isLoadingRoomAction;
    final canInteractMeeting =
        !isSessionClosed && !isLoading && selectedMeetingFormat != null;
    final l10n = context.l10n;
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
          sessionClosedText: sessionStatus.isCompleted
              ? l10n.sessionClosedActionsDisabled
              : l10n.sessionExpiredActionsDisabled,
          onLeaveRoom: onLeaveRoom,
          onOpenChat: onOpenChat,
          unreadCount: unreadCount,
        ),
        if (event != null) ...[
          _EventBanner(event: event!, onOpenRoute: onOpenEventRoute),
          const SizedBox(height: UiSpace.md),
        ],
        RoomAddressSection(
          addressController: addressController,
          canSubmitAddress: canSubmitAddress,
          isLocating: isLocating,
          recentAddresses: recentAddresses,
          onAddressSubmit: onAddressSubmit,
          onUseCurrentLocation: onUseCurrentLocation,
          onAddressSuggestionSelected: onAddressSuggestionSelected,
          onAddressSuggestionDeleted: onAddressSuggestionDeleted,
          onAddressSuggestionsDeleted: onAddressSuggestionsDeleted,
        ),
        const SizedBox(height: UiSpace.lg),
        if (hasPartner)
          RoomMeetingPlacesSection(
            isCalculatingMeeting: isCalculatingMeeting,
            places: places,
            selectedType: selectedType,
            onTypeChanged: onTypeChanged,
            onPlaceTap: onPlaceTap,
            myLocation: myLocation,
            searchRadius: searchRadius,
            onSearchRadiusChanged: onSearchRadiusChanged,
            onSearchRadiusChangeEnd: onSearchRadiusChangeEnd,
            onRetryPlaces: onRetryPlaces,
            onExpandRadiusAndRetry: onExpandRadiusAndRetry,
            onVotePlace: onVotePlace,
            voteCounts: voteCounts,
            myVotePlaceName: myVotePlaceName,
            scoreForPlace: scoreForPlace,
            isFavoritePlace: isFavoritePlace,
            creatorMeetingFormats: creatorMeetingFormats,
            partnerMeetingFormats: partnerMeetingFormats,
            commonMeetingFormats: commonMeetingFormats,
            mySelectedMeetingFormat: mySelectedMeetingFormat,
            partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
            selectedMeetingFormat: selectedMeetingFormat,
            lastAgreedMeetingFormat: lastAgreedMeetingFormat,
            meetingRevoteRequestByRole: meetingRevoteRequestByRole,
            meetingRevoteRequestStatus: meetingRevoteRequestStatus,
            onMeetingFormatsChanged: onMeetingFormatsChanged,
            onMeetingFormatConfirmed: onMeetingFormatConfirmed,
            isSessionClosed: isSessionClosed,
            isCreator: isCreator,
            canInteractMeeting: canInteractMeeting,
            canSelectMeetingFormat: canSelectMeetingFormat,
          )
        else
          Padding(
            padding: const EdgeInsets.all(_waitingParticipantPadding),
            child: Center(
              child: Text(
                l10n.waitSecondParticipant,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
