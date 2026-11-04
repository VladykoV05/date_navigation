/// Invite deep-link helpers for share-to-join.
abstract final class InviteLink {
  static const customScheme = 'datenavigation';
  static const hostJoin = 'join';
  static const httpsHost = 'datenavigation.app';

  static String shareUrl(String inviteCode) =>
      'https://$httpsHost/join/${inviteCode.trim()}';

  static String customSchemeUrl(String inviteCode) =>
      '$customScheme://$hostJoin/${inviteCode.trim()}';

  /// Parses 4-digit invite codes from app/universal links.
  static String? parseInviteCode(Uri? uri) {
    if (uri == null) return null;

    if (uri.scheme == customScheme) {
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (uri.host == hostJoin && segments.isNotEmpty) {
        return _normalizeCode(segments.first);
      }
      if (segments.length >= 2 && segments.first == hostJoin) {
        return _normalizeCode(segments[1]);
      }
    }

    if (uri.scheme == 'https' || uri.scheme == 'http') {
      if (uri.host != httpsHost && uri.host != 'www.$httpsHost') return null;
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.length >= 2 && segments[0] == hostJoin) {
        return _normalizeCode(segments[1]);
      }
    }

    final queryCode = uri.queryParameters['code'];
    if (queryCode != null) return _normalizeCode(queryCode);
    return null;
  }

  static String? _normalizeCode(String raw) {
    final code = raw.trim();
    if (RegExp(r'^\d{4}$').hasMatch(code)) return code;
    return null;
  }
}
