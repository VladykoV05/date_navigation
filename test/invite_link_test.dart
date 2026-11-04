import 'package:date_navigation/core/deep_links/invite_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses custom scheme join links', () {
    expect(
      InviteLink.parseInviteCode(Uri.parse('datenavigation://join/4321')),
      '4321',
    );
  });

  test('parses https join links', () {
    expect(
      InviteLink.parseInviteCode(
        Uri.parse('https://datenavigation.app/join/9876'),
      ),
      '9876',
    );
  });

  test('rejects non 4-digit codes', () {
    expect(
      InviteLink.parseInviteCode(Uri.parse('datenavigation://join/12')),
      isNull,
    );
  });

  test('shareUrl embeds code', () {
    expect(InviteLink.shareUrl('1234'), contains('/join/1234'));
  });
}
