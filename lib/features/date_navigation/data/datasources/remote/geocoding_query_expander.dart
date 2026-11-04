import 'package:date_navigation/features/date_navigation/data/datasources/remote/latin_to_cyrillic_transliterator.dart';

/// Builds alternative geocoding queries for OSM/Nominatim naming quirks.
///
/// Covers typical failure modes for Belarus (and similar) addresses:
/// - translated English names (Independence Avenue → Независимости)
/// - latin street names vs Cyrillic OSM tags
/// - Street/Avenue/ул./пр. suffix noise
/// - house-number / apt / office precision failures
/// - BY latin endings (skaya → skaja) and reverse transliteration to Cyrillic
class GeocodingQueryExpander {
  const GeocodingQueryExpander();

  // Static to stay hot-reload safe (no instance field that can be null on old objects).
  static const _transliterator = LatinToCyrillicTransliterator();

  static final _whitespace = RegExp(r'\s+');
  static final _commaSpaces = RegExp(r'\s*,\s*');
  static final _trailingComma = RegExp(r',\s*$');
  static final _hasLatin = RegExp(r'[A-Za-z]');
  static final _hasCyrillic = RegExp(r'[А-Яа-яЁёІіЎў]');
  static final _hasDigit = RegExp(r'\d');
  static final _houseNumberTail = RegExp(
    r'[,\s]+(?:д\.?\s*)?\d+[A-Za-zА-Яа-я]?$',
  );
  static final _houseNumberBeforeComma = RegExp(
    r'\s+(?:д\.?\s*)?\d+[A-Za-zА-Яа-я]?(?=\s*,)',
  );
  static final _leadingHouseNumber = RegExp(r'^\d+[A-Za-zА-Яа-я]?[,\s]+');
  static final _unitNoise = RegExp(
    r'[,\s]+(?:apt\.?|apartment|flat|unit|suite|ste\.?|office|of\.?|room|rm\.?|'
    r'кв\.?|квартира|офис|каб\.?)\s*\d+[A-Za-zА-Яа-я]?',
    caseSensitive: false,
  );
  static final _streetSuffixEn = RegExp(
    r'\b(street|st\.?|avenue|ave\.?|boulevard|blvd\.?|road|rd\.?|lane|ln\.?|'
    r'drive|dr\.?|highway|hwy\.?|prospect|prospekt|praspiekt)\b',
    caseSensitive: false,
  );
  static final _streetPrefixRu = RegExp(
    r'^(ул\.?|улица|вул\.?|вуліца|пр\.?|проспект|пр-т|бул\.?|бульвар)\s+',
    caseSensitive: false,
  );
  static final _streetSuffixRu = RegExp(
    r'\s+(ул\.?|улица|вул\.?|вуліца|пр\.?|проспект|пр-т|бул\.?|бульвар)$',
    caseSensitive: false,
  );

  /// Curated English → local name aliases (Minsk / common BY landmarks).
  static const _exactAliases = <String, List<String>>{
    'independence avenue': [
      'проспект Независимости',
      'пр. Независимости',
      'Независимости',
      'praspiekt Niezaliežnasci',
      'Niezavisimosti',
      'Nezavisimosti',
    ],
    'independence ave': [
      'проспект Независимости',
      'пр. Независимости',
      'Независимости',
      'Niezavisimosti',
      'Nezavisimosti',
    ],
    'prospect nezavisimosti': [
      'проспект Независимости',
      'пр. Независимости',
      'Независимости',
    ],
    'prospekt nezavisimosti': [
      'проспект Независимости',
      'пр. Независимости',
      'Независимости',
    ],
    'zybitskaya': ['Зыбицкая', 'Зыбіцкая', 'Zybickaja', 'Zybitskaya'],
    'zybitskaya street': ['улица Зыбицкая', 'Зыбицкая', 'Zybickaja'],
    'zybickaya': ['Зыбицкая', 'Зыбіцкая', 'Zybickaja'],
    'surganova': ['Сурганова', 'Surhanava', 'Surganova'],
    'surganova street': ['улица Сурганова', 'Сурганова', 'Surhanava'],
    'pobediteley': ['Победителей', 'Пераможцаў', 'Peramozhcau'],
    'pobediteley avenue': [
      'проспект Победителей',
      'пр. Победителей',
      'Победителей',
    ],
    'nemiga': ['Немига', 'Няміга', 'Niamiha', 'Nemiga'],
    'nemiga street': ['улица Немига', 'Немига', 'Niamiha'],
    'yakub kolas': ['Якуба Коласа', 'плошча Якуба Коласа', 'Jakuba Kolasa'],
    'yakub kolas square': ['площадь Якуба Коласа', 'плошча Якуба Коласа'],
    'victory square': ['площадь Победы', 'плошча Перамогі', 'Pobedy'],
    'pobedy square': ['площадь Победы', 'плошча Перамогі'],
    'oktyabrskaya': ['Октябрьская', 'Кастрычніцкая', 'Kastrychnickaja'],
    'kastrychnitskaya': ['Кастрычніцкая', 'Октябрьская'],
  };

  /// Returns distinct query variants, original first.
  List<String> expand(String address, {bool allowMinskAliases = true}) {
    final original = address.trim();
    if (original.isEmpty) return const <String>[];

    final variants = <String>[];
    void add(String? value) {
      final normalized = _normalizeQuery(value);
      if (normalized == null) return;
      if (variants.any((v) => v.toLowerCase() == normalized.toLowerCase())) {
        return;
      }
      variants.add(normalized);
    }

    add(original);

    final withoutUnit = original
        .replaceAll(_unitNoise, '')
        .replaceAll(_whitespace, ' ')
        .trim();
    add(withoutUnit);

    // Prefer unit-stripped form for further expansion.
    final seed = withoutUnit.isNotEmpty ? withoutUnit : original;
    final lower = seed.toLowerCase();
    if (allowMinskAliases) {
      for (final entry in _exactAliases.entries) {
        if (lower.contains(entry.key)) {
          for (final alias in entry.value) {
            final rewritten = _rewriteContaining(seed, entry.key, alias);
            add(rewritten);
            add(_stripHouseNoise(rewritten));
            add(alias);
            if (_mentionsMinsk(seed) && !_mentionsMinsk(alias)) {
              add('$alias, Минск');
              add('$alias, Minsk');
            }
          }
        }
      }
    }

    final withoutEnSuffix = seed.replaceAll(_streetSuffixEn, '').trim();
    add(withoutEnSuffix);
    add(withoutEnSuffix.replaceFirst(_leadingHouseNumber, '').trim());

    final withoutRuPrefix = seed.replaceFirst(_streetPrefixRu, '').trim();
    add(withoutRuPrefix);

    final withoutRuSuffix = seed.replaceFirst(_streetSuffixRu, '').trim();
    add(withoutRuSuffix);

    final withoutHouse = _stripHouseNoise(seed);
    add(withoutHouse);
    if (withoutEnSuffix != seed) {
      add(_stripHouseNoise(withoutEnSuffix));
    }

    // BY latin orthography heuristics (Russian-looking → Belarusian latin).
    if (_hasLatin.hasMatch(seed) && !_hasCyrillic.hasMatch(seed)) {
      add(_applyByLatinHeuristics(seed));
      add(_applyByLatinHeuristics(withoutEnSuffix));
      add(_applyByLatinHeuristics(withoutHouse));

      // Reverse transliteration → Cyrillic (OSM primary names).
      // Only the street core — never full "19 Name Avenue, City".
      final core = _streetCore(
        withoutEnSuffix.isNotEmpty ? withoutEnSuffix : seed,
      );
      final cyrillicCore = _capitalize(_transliterator.toCyrillic(core));
      if (cyrillicCore != null) {
        add(cyrillicCore);
        add('улица $cyrillicCore');
        add('вуліца $cyrillicCore');
        add('пр. $cyrillicCore');
        add('проспект $cyrillicCore');
        if (allowMinskAliases) {
          add('$cyrillicCore, Минск');
          add('улица $cyrillicCore, Минск');
          if (_mentionsMinsk(seed)) {
            add('проспект $cyrillicCore, Минск');
          }
        }
      }
    }

    // City language swap: Minsk ↔ Минск.
    if (_mentionsMinsk(seed)) {
      add(seed.replaceAll(RegExp(r'\bMinsk\b', caseSensitive: false), 'Минск'));
      add(seed.replaceAll(RegExp(r'\bМинск\b', caseSensitive: false), 'Minsk'));
      add(seed.replaceAll(RegExp(r'\bМінск\b', caseSensitive: false), 'Minsk'));
    }

    return variants;
  }

  bool mentionsMinsk(String address) => _mentionsMinsk(address);

  bool _mentionsMinsk(String value) {
    final lower = value.toLowerCase();
    return lower.contains('minsk') ||
        lower.contains('минск') ||
        lower.contains('мінск');
  }

  String _rewriteContaining(String source, String needle, String replacement) {
    final index = source.toLowerCase().indexOf(needle);
    if (index < 0) return replacement;
    return source.replaceRange(index, index + needle.length, replacement);
  }

  String _stripHouseNoise(String value) {
    return value
        .replaceAll(_unitNoise, '')
        .replaceFirst(_houseNumberBeforeComma, '')
        .replaceFirst(_houseNumberTail, '')
        .replaceFirst(_leadingHouseNumber, '')
        .trim();
  }

  String _streetCore(String value) {
    var core = _stripHouseNoise(value);
    core = core.replaceAll(_streetSuffixEn, '').trim();
    core = core.replaceFirst(_streetPrefixRu, '').trim();
    core = core.replaceFirst(_streetSuffixRu, '').trim();
    // Drop trailing ", City"
    core = core.split(',').first.trim();
    return core;
  }

  /// Drops mixed-script street noise and normalizes commas/spaces.
  String? _normalizeQuery(String? value) {
    var normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return null;

    // Cyrillic street name + leftover "Street"/"Avenue" is never useful.
    if (_hasCyrillic.hasMatch(normalized) && _hasLatin.hasMatch(normalized)) {
      normalized = normalized.replaceAll(_streetSuffixEn, '').trim();
    }

    normalized = normalized
        .replaceAll(_commaSpaces, ', ')
        .replaceAll(_whitespace, ' ')
        .replaceAll(_trailingComma, '')
        .trim();
    if (normalized.isEmpty) return null;

    // Reject digit-only / punctuation-only leftovers.
    if (!_hasLatin.hasMatch(normalized) &&
        !_hasCyrillic.hasMatch(normalized) &&
        !_hasDigit.hasMatch(normalized)) {
      return null;
    }
    return normalized;
  }

  String? _capitalize(String? value) {
    if (value == null || value.isEmpty) return value;
    if (value.length == 1) return value.toUpperCase();
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  String? _applyByLatinHeuristics(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    var next = trimmed;
    next = next.replaceAll(RegExp(r'tskaya\b', caseSensitive: false), 'ckaja');
    next = next.replaceAll(RegExp(r'skaya\b', caseSensitive: false), 'skaja');
    next = next.replaceAll(RegExp(r'naya\b', caseSensitive: false), 'naja');
    next = next.replaceAll(RegExp(r'aya\b', caseSensitive: false), 'aja');
    next = next.replaceAll(RegExp(r'iya\b', caseSensitive: false), 'ija');
    next = next.replaceAll(RegExp(r'\bya\b', caseSensitive: false), 'ja');
    next = next.replaceAll(RegExp(r'kh', caseSensitive: false), 'h');
    if (next.toLowerCase() == trimmed.toLowerCase()) return null;
    return next;
  }
}
