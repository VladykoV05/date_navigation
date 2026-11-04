import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n_extensions.dart';
import '../../../../../core/theme/ui_tokens.dart';

class OtherAddressesSheetContent extends StatelessWidget {
  const OtherAddressesSheetContent({
    super.key,
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
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.otherAddressesLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onDeleteAll,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: Text(l10n.clearAllAddressesLabel),
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
                      tooltip: l10n.deleteAddressTooltip,
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
