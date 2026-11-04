import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Thin wrapper for Crashlytics breadcrumbs / non-fatal diagnostics.
abstract final class Observability {
  static void breadcrumb(String message, {Map<String, Object?>? data}) {
    final detail = data == null || data.isEmpty
        ? message
        : '$message ${data.entries.map((e) => '${e.key}=${e.value}').join(' ')}';
    AppLogger.d(detail);
    if (kIsWeb) return;
    try {
      FirebaseCrashlytics.instance.log(detail);
    } catch (_) {
      // Crashlytics may be unavailable in tests.
    }
  }

  static Future<void> recordNonFatal(
    Object error,
    StackTrace stack, {
    String? reason,
  }) async {
    AppLogger.e(reason ?? 'non_fatal', error, stack);
    if (kIsWeb) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        fatal: false,
      );
    } catch (_) {}
  }
}
