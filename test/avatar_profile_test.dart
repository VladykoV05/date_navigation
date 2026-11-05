import 'dart:convert';
import 'dart:typed_data';

import 'package:date_navigation/core/profile/avatar_codec.dart';
import 'package:date_navigation/core/profile/public_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  group('AvatarCodec', () {
    test('photo is cropped to 128x128 JPEG within the size limit', () {
      final source = img.Image(width: 800, height: 500);
      img.fill(source, color: img.ColorRgb8(200, 60, 120));
      final bytes = Uint8List.fromList(img.encodeJpg(source));

      final encoded = AvatarCodec.encode(bytes);

      expect(encoded, isNotNull);
      expect(encoded!.length, lessThanOrEqualTo(AvatarCodec.maxBase64Length));
      final decoded = img.decodeJpg(base64Decode(encoded));
      expect(decoded, isNotNull);
      expect(decoded!.width, AvatarCodec.size);
      expect(decoded.height, AvatarCodec.size);
    });

    test('invalid bytes are rejected', () {
      expect(AvatarCodec.encode(Uint8List.fromList([1, 2, 3, 4])), isNull);
    });
  });

  group('PublicProfile.shownName', () {
    test('renamed name wins over Google name', () {
      const profile = PublicProfile(
        uid: 'u1',
        displayName: 'Ивана',
        googleName: 'Ivan Vladyko',
      );
      expect(profile.shownName, 'Ивана');
    });

    test('falls back to Google name when not renamed', () {
      const profile = PublicProfile(uid: 'u1', googleName: 'Ivan Vladyko');
      expect(profile.shownName, 'Ivan Vladyko');
    });

    test('blank names are treated as missing', () {
      const profile = PublicProfile(
        uid: 'u1',
        displayName: '  ',
        googleName: '',
      );
      expect(profile.shownName, isNull);
    });
  });
}
