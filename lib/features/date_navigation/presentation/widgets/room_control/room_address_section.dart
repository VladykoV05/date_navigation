import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/l10n/l10n_extensions.dart';
import '../../../../../core/search/search_region.dart';
import '../../../../../core/search/search_region_preferences.dart';
import '../../../../../core/theme/ui_tokens.dart';
import '../../../../../core_ui/core_ui.dart';
import 'other_addresses_sheet.dart';

class RoomAddressSection extends ConsumerWidget {
  static const int _undoDeletionSeconds = 5;
  static const double _topAddressesHeight = 36;
  static const double _addressChipIconSize = 16;

  const RoomAddressSection({
    super.key,
    required this.addressController,
    required this.canSubmitAddress,
    required this.isLocating,
    required this.recentAddresses,
    required this.onAddressSubmit,
    required this.onUseCurrentLocation,
    required this.onAddressSuggestionSelected,
    required this.onAddressSuggestionDeleted,
    required this.onAddressSuggestionsDeleted,
  });

  final TextEditingController addressController;
  final bool canSubmitAddress;
  final bool isLocating;
  final List<String> recentAddresses;
  final VoidCallback onAddressSubmit;
  final VoidCallback onUseCurrentLocation;
  final ValueChanged<String> onAddressSuggestionSelected;
  final Future<void> Function(String address) onAddressSuggestionDeleted;
  final Future<void> Function(Iterable<String> addresses)
  onAddressSuggestionsDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final topAddresses = recentAddresses.take(5).toList(growable: false);
    final otherAddresses = recentAddresses.skip(5).toList(growable: false);
    final regionAsync = ref.watch(searchRegionControllerProvider);
    final selectedRegion = regionAsync.value ?? SearchRegion.global;
    final selectedPreset = selectedRegion.isGlobal
        ? SearchRegion.global
        : SearchRegion.minsk;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: UiSpace.md),
        Text(
          l10n.searchRegionLabel,
          style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: UiSpace.xs),
        SegmentedButton<SearchRegion>(
          segments: [
            ButtonSegment(
              value: SearchRegion.global,
              label: Text(l10n.searchRegionGlobal),
            ),
            ButtonSegment(
              value: SearchRegion.minsk,
              label: Text(l10n.searchRegionMinsk),
            ),
          ],
          selected: {selectedPreset},
          onSelectionChanged: canSubmitAddress
              ? (next) {
                  final region = next.first;
                  unawaited(
                    ref
                        .read(searchRegionControllerProvider.notifier)
                        .setRegion(region),
                  );
                }
              : null,
        ),
        const SizedBox(height: UiSpace.sm),
        OutlinedButton.icon(
          onPressed: canSubmitAddress ? onUseCurrentLocation : null,
          icon: isLocating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location),
          label: Text(
            isLocating
                ? l10n.useCurrentLocationLoading
                : l10n.useCurrentLocationLabel,
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: UiSpace.sm),
        TextField(
          controller: addressController,
          enabled: canSubmitAddress,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.streetAddress,
          onSubmitted: (_) {
            if (canSubmitAddress) onAddressSubmit();
          },
          decoration: InputDecoration(
            labelText: l10n.addressFieldLabel,
            hintText: l10n.addressFieldHint,
            helperText: l10n.addressFieldHelper,
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
            l10n.frequentAddressesTitle,
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
            TextButton.icon(
              onPressed: canSubmitAddress
                  ? () => _showOtherAddressesSheet(
                      context,
                      addresses: otherAddresses,
                    )
                  : null,
              icon: const Icon(Icons.list_alt),
              label: Text(
                '${l10n.otherAddressesLabel} (${otherAddresses.length})',
              ),
            ),
          ],
        ],
      ],
    );
  }

  Future<void> _showOtherAddressesSheet(
    BuildContext context, {
    required List<String> addresses,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => OtherAddressesSheetContent(
        addresses: addresses,
        onAddressSelected: (address) {
          onAddressSuggestionSelected(address);
          Navigator.of(sheetContext).pop();
        },
        onDeleteOne: (address) async {
          await _deleteWithUndo(
            context: context,
            addresses: [address],
            message: context.l10n.addressDeleteUndoMessage(
              _undoDeletionSeconds,
            ),
          );
          if (sheetContext.mounted) Navigator.of(sheetContext).pop();
        },
        onDeleteAll: () async {
          final sheetL10n = sheetContext.l10n;
          final shouldClear = await ConfirmDialog.showBinary(
            sheetContext,
            title: sheetL10n.clearOtherAddressesTitle,
            message: sheetL10n.clearOtherAddressesMessage,
            cancelLabel: sheetL10n.cancelLabel,
            confirmLabel: sheetL10n.clearLabel,
          );
          if (!sheetContext.mounted || shouldClear != true) return;
          await _deleteWithUndo(
            context: context,
            addresses: addresses,
            message: context.l10n.addressesDeleteUndoMessage(
              _undoDeletionSeconds,
            ),
          );
          if (sheetContext.mounted) Navigator.of(sheetContext).pop();
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
        .map((address) => address.trim())
        .where((address) => address.isNotEmpty)
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
          label: context.l10n.undoLabel,
          onPressed: () => undone = true,
        ),
      ),
    );
    await Future<void>.delayed(const Duration(seconds: _undoDeletionSeconds));
    if (undone) return;
    if (normalized.length == 1) {
      await onAddressSuggestionDeleted(normalized.first);
    } else {
      await onAddressSuggestionsDeleted(normalized);
    }
  }
}
