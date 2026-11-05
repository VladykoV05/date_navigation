import 'dart:math';

import 'package:date_navigation/features/date_navigation/data/datasources/remote/room_session_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('open room code has fixed length and no ambiguous characters', () {
    final rnd = Random(42);
    for (var i = 0; i < 500; i++) {
      final code = generateOpenRoomCode(random: rnd);
      expect(code.length, openRoomCodeLength);
      expect(RegExp(r'^[A-HJ-NP-Z2-9]+$').hasMatch(code), isTrue, reason: code);
    }
  });

  test('open room codes vary between calls', () {
    final codes = {for (var i = 0; i < 50; i++) generateOpenRoomCode()};
    expect(codes.length, greaterThan(45));
  });
}
