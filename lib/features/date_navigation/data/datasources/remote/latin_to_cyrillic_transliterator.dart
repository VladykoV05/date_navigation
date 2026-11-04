/// Best-effort reverse transliteration: English/passport latin → Russian Cyrillic.
///
/// Covers common street-name patterns used in Belarus/Russia OSM data.
class LatinToCyrillicTransliterator {
  const LatinToCyrillicTransliterator();

  static final _hasLatin = RegExp(r'[A-Za-z]');
  static final _hasCyrillic = RegExp(r'[А-Яа-яЁё]');

  /// Multi-char replacements applied longest-first (case-insensitive).
  static const _digraphs = <String, String>{
    'shch': 'щ',
    'tsch': 'ч',
    'tskaya': 'цкая',
    'skaya': 'ская',
    'tskaja': 'цкая',
    'skaja': 'ская',
    'naya': 'ная',
    'naja': 'ная',
    'aya': 'ая',
    'aja': 'ая',
    'iya': 'ия',
    'ija': 'ия',
    'yy': 'ый',
    'iy': 'ий',
    'ey': 'ей',
    'oy': 'ой',
    'ay': 'ай',
    'uy': 'уй',
    'zh': 'ж',
    'kh': 'х',
    'ts': 'ц',
    'ch': 'ч',
    'sh': 'ш',
    'yo': 'ё',
    'yu': 'ю',
    'ya': 'я',
    'ye': 'е',
    'je': 'е',
    'ju': 'ю',
    'ja': 'я',
  };

  static const _letters = <String, String>{
    'a': 'а',
    'b': 'б',
    'c': 'к',
    'd': 'д',
    'e': 'е',
    'f': 'ф',
    'g': 'г',
    'h': 'х',
    'i': 'и',
    'j': 'й',
    'k': 'к',
    'l': 'л',
    'm': 'м',
    'n': 'н',
    'o': 'о',
    'p': 'п',
    'q': 'к',
    'r': 'р',
    's': 'с',
    't': 'т',
    'u': 'у',
    'v': 'в',
    'w': 'в',
    'x': 'кс',
    'y': 'ы',
    'z': 'з',
  };

  /// Returns Cyrillic form when [input] is latin-only; otherwise null.
  String? toCyrillic(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    if (!_hasLatin.hasMatch(trimmed) || _hasCyrillic.hasMatch(trimmed)) {
      return null;
    }

    final buffer = StringBuffer();
    var i = 0;
    final lower = trimmed.toLowerCase();
    while (i < lower.length) {
      final ch = lower[i];
      if (!_hasLatin.hasMatch(ch)) {
        buffer.write(trimmed[i]);
        i += 1;
        continue;
      }

      String? matched;
      for (var len = 6; len >= 2; len--) {
        if (i + len > lower.length) continue;
        final slice = lower.substring(i, i + len);
        final repl = _digraphs[slice];
        if (repl == null) continue;
        matched = repl;
        i += len;
        break;
      }
      if (matched != null) {
        buffer.write(matched);
        continue;
      }

      buffer.write(_letters[ch] ?? ch);
      i += 1;
    }

    final result = buffer.toString().trim();
    if (result.isEmpty || result == trimmed.toLowerCase()) return null;
    return result;
  }
}
