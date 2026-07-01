part of 'room_control_panel.dart';

class _DateAssistantSection extends StatelessWidget {
  const _DateAssistantSection({
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
            'Date Assistant',
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
                    label: Text(format.label),
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
              'Общие форматы (выберите один)',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: UiSpace.xs),
            _CommonMeetingFormatViewSelector(
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
              UiCopy.formatNotMatchedPlaceDisabled,
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

class _OtherAddressesSheetContent extends StatelessWidget {
  const _OtherAddressesSheetContent({
    required this.addresses,
    required this.onAddressSelected,
    required this.onDeleteOne,
    required this.onDeleteAll,
  });

  final List<String> addresses;
  final ValueChanged<String> onAddressSelected;
  final Future<void> Function(String address) onDeleteOne;
  final Future<void> Function() onDeleteAll;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              UiCopy.otherAddressesLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onDeleteAll,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text(UiCopy.clearAllAddressesLabel),
              ),
            ),
            const SizedBox(height: UiSpace.sm),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: addresses.length,
                separatorBuilder: (_, _) => const Divider(height: UiSpace.sm),
                itemBuilder: (_, index) {
                  final address = addresses[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => onAddressSelected(address),
                    trailing: IconButton(
                      tooltip: UiCopy.deleteAddressTooltip,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onDeleteOne(address),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceTypeIconResolver {
  const _PlaceTypeIconResolver._();

  static IconData resolve(String? placeType) {
    return switch (placeType) {
      null => Icons.tune,
      'cafe' => Icons.local_cafe,
      'restaurant' => Icons.restaurant,
      'cinema' => Icons.movie,
      'museum' => Icons.museum,
      'gallery' => Icons.brush,
      'theatre' => Icons.theater_comedy,
      'park' => Icons.park,
      'viewpoint' => Icons.landscape,
      'fitness_centre' => Icons.fitness_center,
      'sports_centre' => Icons.sports,
      'swimming_pool' => Icons.pool,
      'ice_rink' => Icons.ac_unit,
      'active_racket' => Icons.sports_tennis,
      'active_team' => Icons.groups_2,
      'active_climb' => Icons.terrain,
      'active_dance' => Icons.music_note,
      'active_mind_body' => Icons.self_improvement,
      _ => Icons.place,
    };
  }
}

class _PlaceTypeFilterChips extends StatelessWidget {
  static const double _chipRowHeight = 50;
  static const double _chipSpacing = 8;
  static const double _chipIconSize = 16;

  const _PlaceTypeFilterChips({
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
    final types = FormatChipConfig.optionsForWire(selectedMeetingFormat?.wireValue);
    return SizedBox(
      height: _chipRowHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: types
            .map(
              (option) => Padding(
                padding: const EdgeInsets.only(right: _chipSpacing),
                child: Builder(
                  builder: (context) {
                    final selected = selectedType == option.placeType;
                    final foregroundColor = selected
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant;
                    return ChoiceChip(
                      avatar: Icon(
                        _PlaceTypeIconResolver.resolve(option.placeType),
                        size: _chipIconSize,
                        color: foregroundColor,
                      ),
                      label: Text(
                        option.label,
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
                              isSelected ? option.placeType : null,
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

class _CommonMeetingFormatViewSelector extends StatefulWidget {
  const _CommonMeetingFormatViewSelector({
    required this.commonMeetingFormats,
    required this.mySelectedMeetingFormat,
    required this.canSelectMeetingFormat,
    required this.onMeetingFormatConfirmed,
  });

  final List<MeetingFormatView> commonMeetingFormats;
  final MeetingFormatView? mySelectedMeetingFormat;
  final bool canSelectMeetingFormat;
  final ValueChanged<MeetingFormatView> onMeetingFormatConfirmed;

  @override
  State<_CommonMeetingFormatViewSelector> createState() =>
      _CommonMeetingFormatViewSelectorState();
}

class _CommonMeetingFormatViewSelectorState
    extends State<_CommonMeetingFormatViewSelector> {
  MeetingFormatView? _draftFormat;
  bool _isResetDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _draftFormat = widget.mySelectedMeetingFormat;
  }

  @override
  void didUpdateWidget(covariant _CommonMeetingFormatViewSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mySelectedMeetingFormat != widget.mySelectedMeetingFormat) {
      _draftFormat = widget.mySelectedMeetingFormat;
    }
    if (_draftFormat != null &&
        !widget.commonMeetingFormats.contains(_draftFormat)) {
      _scheduleResetInvalidDraftPrompt();
    }
  }

  void _scheduleResetInvalidDraftPrompt() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _askBeforeResetInvalidDraft();
    });
  }

  bool get _canConfirmDraftSelection {
    return widget.canSelectMeetingFormat &&
        _draftFormat != null &&
        widget.commonMeetingFormats.contains(_draftFormat) &&
        _draftFormat != widget.mySelectedMeetingFormat;
  }

  void _onFormatSelected(bool isSelected, MeetingFormatView format) {
    setState(() {
      _draftFormat = isSelected ? format : null;
    });
  }

  void _confirmDraftSelection() {
    final format = _draftFormat;
    if (format == null) return;
    HapticFeedback.selectionClick();
    widget.onMeetingFormatConfirmed(format);
  }

  Future<void> _askBeforeResetInvalidDraft() async {
    if (!mounted || _isResetDialogOpen) return;
    _isResetDialogOpen = true;
    final shouldReset = await ConfirmDialog.showBinary(
      context,
      title: 'Выбор формата изменился',
      message: UiCopy.formatDraftResetPrompt,
      cancelLabel: UiCopy.noLabel,
      confirmLabel: UiCopy.yesLabel,
    );
    _isResetDialogOpen = false;
    if (!mounted) return;
    if (shouldReset == true) {
      setState(() {
        _draftFormat = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.commonMeetingFormats
              .map(
                (format) => ChoiceChip(
                  label: Text(format.label),
                  selected: _draftFormat == format,
                  onSelected: widget.canSelectMeetingFormat
                      ? (isSelected) => _onFormatSelected(isSelected, format)
                      : null,
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: UiSpace.xs),
        FilledButton.icon(
          onPressed: _canConfirmDraftSelection ? _confirmDraftSelection : null,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text(UiCopy.confirmMyFormatChoiceLabel),
        ),
      ],
    );
  }
}
