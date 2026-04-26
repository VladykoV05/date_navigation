import 'package:flutter/material.dart';

import 'ui_copy.dart';

class ConfirmDialog {
  const ConfirmDialog._();

  static Future<bool?> showBinary(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = UiCopy.noLabel,
    String confirmLabel = UiCopy.yesLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String actionLabel = UiCopy.okLabel,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
