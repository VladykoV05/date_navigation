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

  test('open room join is a single guarded transaction path', () {
    expect(rules, contains('isOpenJoinUpdate'));
    expect(rules, contains("resource.data.type == 'open'"));
    expect(
      rules,
      contains('resource.data.participants.size() < resource.data.capacity'),
    );
    expect(
      rules,
      contains("hasOnly(['participants', 'participantCount', 'updatedAt'])"),
    );
  });

  test('open room fields cannot be changed by members', () {
    expect(rules, contains("unchanged('type')"));
    expect(rules, contains("unchanged('capacity')"));
    expect(rules, contains("unchanged('hostUid')"));
    expect(rules, contains("unchanged('participants')"));
  });

  test('participant docs are created only by their owner', () {
    expect(rules, contains('match /participants/{uid}'));
    expect(rules, contains('allow update, delete: if false;'));
  });

  test('open rooms have a composite index for discovery', () {
    final indexes = File('firestore.indexes.json').readAsStringSync();
    expect(indexes, contains('"sessionStatus"'));
    expect(indexes, contains('"visibility"'));
  });
}
