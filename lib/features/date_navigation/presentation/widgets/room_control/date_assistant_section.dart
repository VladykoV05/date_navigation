import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n_extensions.dart';
import '../../../../../core/theme/ui_tokens.dart';
import '../../view_data/place_view_data.dart';
import 'common_meeting_format_selector.dart';

class DateAssistantSection extends StatelessWidget {
  const DateAssistantSection({
    super.key,
    required this.myFormats,
    required this.selectedMeetingFormat,
    required this.mySelectedMeetingFormat,
    required this.partnerSelectedMeetingFormat,
    required this.commonMeetingFormats,
    required this.canSelectMeetingFormat,
    required this.statusText,
    required this.confirmationText,
    required this.onToggleMeetingFormat,
    required this.onMeetingFormatConfirmed,
  });

  final List<MeetingFormatView> myFormats;
  final MeetingFormatView? selectedMeetingFormat;
  final MeetingFormatView? mySelectedMeetingFormat;
  final MeetingFormatView? partnerSelectedMeetingFormat;
  final List<MeetingFormatView> commonMeetingFormats;
  final bool canSelectMeetingFormat;
  final String statusText;
  final String confirmationText;
  final ValueChanged<MeetingFormatView> onToggleMeetingFormat;
  final ValueChanged<MeetingFormatView> onMeetingFormatConfirmed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isMeetingFormatMatched = selectedMeetingFormat != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(UiRadius.md),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dateAssistantTitle,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: UiSpace.xs),
          Text(
            statusText,
            style: textTheme.bodySmall?.copyWith(
              color: selectedMeetingFormat != null
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MeetingFormatView.values
                .map((format) {
                  final selected = myFormats.contains(format);
                  return ChoiceChip(
                    label: Text(format.localizedLabel(l10n)),
                    selected: selected,
                    onSelected: canSelectMeetingFormat
                        ? (_) => onToggleMeetingFormat(format)
                        : null,
                  );
                })
                .toList(growable: false),
          ),
          const SizedBox(height: 10),
          if (commonMeetingFormats.isNotEmpty) ...[
            Text(
              l10n.commonFormatsTitle,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: UiSpace.xs),
            CommonMeetingFormatSelector(
              commonMeetingFormats: commonMeetingFormats,
              mySelectedMeetingFormat: mySelectedMeetingFormat,
              canSelectMeetingFormat: canSelectMeetingFormat,
              onMeetingFormatConfirmed: onMeetingFormatConfirmed,
            ),
          ],
          Text(
            confirmationText,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!isMeetingFormatMatched) ...[
            const SizedBox(height: UiSpace.xs),
            Text(
              l10n.formatNotMatchedPlaceDisabled,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
