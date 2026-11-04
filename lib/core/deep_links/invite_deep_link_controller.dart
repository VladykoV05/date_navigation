import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'invite_link.dart';

/// Holds a pending invite code from a cold/warm deep link until UI consumes it.
class InviteDeepLinkController extends Notifier<String?> {
  StreamSubscription<Uri>? _sub;
  final AppLinks _appLinks = AppLinks();

  @override
  String? build() {
    ref.onDispose(() {
      unawaited(_sub?.cancel());
    });
    unawaited(_bootstrap());
    return null;
  }

  Future<void> _bootstrap() async {
    try {
      final initial = await _appLinks.getInitialLink();
      _accept(InviteLink.parseInviteCode(initial));
    } catch (_) {
      // Ignore platform channel failures in tests / unsupported platforms.
    }
    _sub = _appLinks.uriLinkStream.listen((uri) {
      _accept(InviteLink.parseInviteCode(uri));
    });
  }

  void _accept(String? code) {
    if (code == null || code.isEmpty) return;
    state = code;
  }

  /// Consumes the pending code (returns it once).
  String? takePendingCode() {
    final code = state;
    state = null;
    return code;
  }

  void setPendingCode(String code) {
    final normalized = InviteLink.parseInviteCode(
      Uri(
        scheme: InviteLink.customScheme,
        host: InviteLink.hostJoin,
        path: '/$code',
      ),
    );
    if (normalized != null) state = normalized;
  }
}

final inviteDeepLinkControllerProvider =
    NotifierProvider<InviteDeepLinkController, String?>(
      InviteDeepLinkController.new,
    );
