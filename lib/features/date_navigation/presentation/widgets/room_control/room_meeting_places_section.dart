import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n_extensions.dart';
import '../../../../../core/theme/ui_tokens.dart';
import '../../../domain/value_objects/geo_coordinate.dart';
import '../../view_data/place_view_data.dart';
import '../place_card.dart';
import 'date_assistant_section.dart';
import 'meeting_format_status_copy.dart';
import 'place_type_filter_chips.dart';

class RoomMeetingPlacesSection extends StatelessWidget {
  static const double _radiusMin = 200;
  static const double _radiusMax = 3000;
  static const int _radiusDivisions = 14;
  static const double _actionIconSize = 18;
  static const double _emptyStateVerticalPadding = 16;
  static const double _bottomSpacing = 100;

  const RoomMeetingPlacesSection({
    super.key,
    required this.isCalculatingMeeting,
    required this.places,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onPlaceTap,
    required this.myLocation,
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
    required this.isCreator,
    required this.canInteractMeeting,
    required this.canSelectMeetingFormat,
  });

  final bool isCalculatingMeeting;
  final List<PlaceViewData> places;
  final String? selectedType;
  final void Function(String?) onTypeChanged;
  final void Function(PlaceViewData) onPlaceTap;
  final GeoCoordinate? myLocation;
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
  final bool isCreator;
  final bool canInteractMeeting;
  final bool canSelectMeetingFormat;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMeetingFormatMatched = selectedMeetingFormat != null;
    final hasPlacesInSelectedCategory =
        selectedType == null ||
        places.any((place) => place.matchesWireType(selectedType));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.searchRadiusLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: _radiusMin,
                max: _radiusMax,
                divisions: _radiusDivisions,
                value: searchRadius.clamp(_radiusMin, _radiusMax),
                label: l10n.metersShort(searchRadius.round()),
                onChanged: canInteractMeeting ? onSearchRadiusChanged : null,
                onChangeEnd: canInteractMeeting
                    ? (_) => onSearchRadiusChangeEnd()
                    : null,
              ),
            ),
            Text(
              l10n.metersShort(searchRadius.round()),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: UiSpace.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.meetingPlacesTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: canInteractMeeting ? onRetryPlaces : null,
              icon: const Icon(Icons.refresh, size: _actionIconSize),
              label: Text(l10n.retryLabel),
            ),
          ],
        ),
        const SizedBox(height: UiSpace.sm),
        _buildDateAssistantSection(context),
        if (isMeetingFormatMatched)
          PlaceTypeFilterChips(
            selectedMeetingFormat: selectedMeetingFormat,
            selectedType: selectedType,
            isSessionClosed: isSessionClosed,
            onTypeChanged: onTypeChanged,
          ),
        const SizedBox(height: UiSpace.sm),
        _buildPlacesSection(
          context,
          isMeetingFormatMatched: isMeetingFormatMatched,
          hasPlacesInSelectedCategory: hasPlacesInSelectedCategory,
        ),
        const SizedBox(height: _bottomSpacing),
      ],
    );
  }

  Widget _buildPlacesSection(
    BuildContext context, {
    required bool isMeetingFormatMatched,
    required bool hasPlacesInSelectedCategory,
  }) {
    final theme = Theme.of(context);
    if (!isMeetingFormatMatched) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: _emptyStateVerticalPadding,
        ),
        child: Text(
          context.l10n.pickSameFormatFirst,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
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
        itemBuilder: (_, index) {
          final place = places[index];
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
    final l10n = context.l10n;
    if (isCalculatingMeeting) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: _emptyStateVerticalPadding,
        ),
        child: Text(
          l10n.loadingNearbyPlaces,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final categoryEmpty = selectedType != null && !hasPlacesInSelectedCategory;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _emptyStateVerticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryEmpty ? l10n.noResultsInCategory : l10n.noResultsInRadius,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noResultsInRadiusHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (categoryEmpty)
                OutlinedButton(
                  onPressed: canInteractMeeting
                      ? () => onTypeChanged(null)
                      : null,
                  child: Text(l10n.showAllCategoriesLabel),
                ),
              FilledButton.tonal(
                onPressed: canInteractMeeting ? onExpandRadiusAndRetry : null,
                child: Text(l10n.increaseRadiusHint),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateAssistantSection(BuildContext context) {
    final myFormats = isCreator ? creatorMeetingFormats : partnerMeetingFormats;
    final partnerFormats = isCreator
        ? partnerMeetingFormats
        : creatorMeetingFormats;
    return DateAssistantSection(
      myFormats: myFormats,
      selectedMeetingFormat: selectedMeetingFormat,
      mySelectedMeetingFormat: mySelectedMeetingFormat,
      partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
      commonMeetingFormats: commonMeetingFormats,
      canSelectMeetingFormat: canSelectMeetingFormat,
      statusText: MeetingFormatStatusCopy.statusText(
        context: context,
        isCreator: isCreator,
        myFormats: myFormats,
        partnerFormats: partnerFormats,
        commonMeetingFormats: commonMeetingFormats,
        selectedMeetingFormat: selectedMeetingFormat,
        mySelectedMeetingFormat: mySelectedMeetingFormat,
        lastAgreedMeetingFormat: lastAgreedMeetingFormat,
        meetingRevoteRequestByRole: meetingRevoteRequestByRole,
        meetingRevoteRequestStatus: meetingRevoteRequestStatus,
      ),
      confirmationText: MeetingFormatStatusCopy.confirmationLine(
        context: context,
        mySelectedMeetingFormat: mySelectedMeetingFormat,
        partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
      ),
      onToggleMeetingFormat: _toggleMeetingFormat,
      onMeetingFormatConfirmed: onMeetingFormatConfirmed,
    );
  }

  void _toggleMeetingFormat(MeetingFormatView format) {
    final current = isCreator ? creatorMeetingFormats : partnerMeetingFormats;
    final next = <MeetingFormatView>{...current};
    next.contains(format) ? next.remove(format) : next.add(format);
    onMeetingFormatsChanged(next);
  }
}
