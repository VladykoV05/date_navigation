import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/l10n/l10n_extensions.dart';
import '../../../../../core/theme/ui_tokens.dart';
import '../../../../../core_ui/core_ui.dart';
import '../../view_data/place_view_data.dart';

class CommonMeetingFormatSelector extends StatefulWidget {
  const CommonMeetingFormatSelector({
    super.key,
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
  State<CommonMeetingFormatSelector> createState() =>
      _CommonMeetingFormatSelectorState();
}

class _CommonMeetingFormatSelectorState
    extends State<CommonMeetingFormatSelector> {
  MeetingFormatView? _draftFormat;
  bool _isResetDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _draftFormat = widget.mySelectedMeetingFormat;
  }

  @override
  void didUpdateWidget(covariant CommonMeetingFormatSelector oldWidget) {
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
    final l10n = context.l10n;
    final shouldReset = await ConfirmDialog.showBinary(
      context,
      title: l10n.formatChangedTitle,
      message: l10n.formatDraftResetPrompt,
      cancelLabel: l10n.noLabel,
      confirmLabel: l10n.yesLabel,
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
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.commonMeetingFormats
              .map(
                (format) => ChoiceChip(
                  label: Text(format.localizedLabel(l10n)),
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
          label: Text(l10n.confirmMyFormatChoiceLabel),
        ),
      ],
    );
  }
}
