import 'package:flutter/material.dart';

import '../core/l10n/l10n_extensions.dart';

class ConfirmDialog {
  const ConfirmDialog._();

  static Future<bool?> showBinary(
    BuildContext context, {
    required String title,
    required String message,
    String? cancelLabel,
    String? confirmLabel,
  }) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel ?? l10n.noLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel ?? l10n.yesLabel),
          ),
        ],
      ),
    );
  }

  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
  }) {
    final l10n = context.l10n;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(actionLabel ?? l10n.okLabel),
          ),
        ],
      ),
    );
  }
}
