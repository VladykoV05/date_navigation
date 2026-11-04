import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late String rules;

  setUpAll(() {
    rules = File('firestore.rules').readAsStringSync();
  });

  test('rules protect partner-owned room fields for creator updates', () {
    expect(rules, contains('roleScopedRoomFieldsOk'));
    expect(rules, contains("unchanged('point2')"));
    expect(rules, contains("unchanged('partnerMeetingFormats')"));
    expect(rules, contains("unchanged('partnerSelectedMeetingFormat')"));
    expect(rules, contains("unchanged('partnerUid')"));
  });

  test('rules protect creator-owned room fields for partner updates', () {
    expect(rules, contains("unchanged('point1')"));
    expect(rules, contains("unchanged('creatorMeetingFormats')"));
    expect(rules, contains("unchanged('creatorSelectedMeetingFormat')"));
  });

  test('join flow remains an explicit allowed path', () {
    expect(rules, contains('isJoinUpdate'));
    expect(rules, contains('partnerUid == null'));
  });

  test('invite create requires ownership metadata', () {
    expect(
      rules,
      contains('request.resource.data.createdBy == request.auth.uid'),
    );
    expect(rules, contains('request.resource.data.expiresAt is timestamp'));
  });
}
