import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Сжимает фото из галереи до квадрата 128×128 и JPEG; возвращает base64.
/// Качество снижается, пока результат не уложится в [maxBase64Length].
class AvatarCodec {
  const AvatarCodec._();

  static const int size = 128;
  static const int maxBase64Length = 45000;

  /// Возвращает null, если изображение не декодируется или не влезает в лимит.
  static String? encode(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    final square = img.copyResizeCropSquare(decoded, size: size);
    for (final quality in const [85, 70, 55, 40]) {
      final encoded = base64Encode(img.encodeJpg(square, quality: quality));
      if (encoded.length <= maxBase64Length) return encoded;
    }
    return null;
  }
}
