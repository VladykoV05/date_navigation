import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n_extensions.dart';
import '../../../config/format_chip_config.dart';
import '../../../application/l10n/app_scenario_copy_catalog.dart';
import '../../utils/place_type_icons.dart';
import '../../view_data/place_view_data.dart';

class PlaceTypeFilterChips extends StatelessWidget {
  static const double chipRowHeight = 50;
  static const double chipSpacing = 8;
  static const double chipIconSize = 16;

  const PlaceTypeFilterChips({
    super.key,
    required this.selectedMeetingFormat,
    required this.selectedType,
    required this.isSessionClosed,
    required this.onTypeChanged,
  });

  final MeetingFormatView? selectedMeetingFormat;
  final String? selectedType;
  final bool isSessionClosed;
  final ValueChanged<String?> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final types = FormatChipConfig.optionsForWire(
      selectedMeetingFormat?.wireValue,
    );
    return SizedBox(
      height: chipRowHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: types
            .map(
              (option) => Padding(
                padding: const EdgeInsets.only(right: chipSpacing),
                child: Builder(
                  builder: (context) {
                    final selected =
                        selectedType == option.placeType?.wireValue;
                    final foregroundColor = selected
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant;
                    return ChoiceChip(
                      avatar: Icon(
                        PlaceTypeIcons.resolve(option.placeType),
                        size: chipIconSize,
                        color: foregroundColor,
                      ),
                      label: Text(
                        l10n.chipLabelFor(option.placeType),
                        style: TextStyle(
                          color: foregroundColor,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                      selected: selected,
                      onSelected: isSessionClosed
                          ? null
                          : (isSelected) => onTypeChanged(
                              isSelected ? option.placeType?.wireValue : null,
                            ),
                      selectedColor: colorScheme.secondaryContainer,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      side: BorderSide(
                        color: selected
                            ? colorScheme.secondaryContainer
                            : colorScheme.outlineVariant,
                      ),
                      showCheckmark: true,
                      checkmarkColor: colorScheme.onSecondaryContainer,
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
