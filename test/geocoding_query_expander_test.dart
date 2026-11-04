import 'package:date_navigation/features/date_navigation/data/datasources/remote/geocoding_query_expander.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/remote/latin_to_cyrillic_transliterator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const expander = GeocodingQueryExpander();
  const transliterator = LatinToCyrillicTransliterator();

  test('expands Independence Avenue to Nezavisimosti / Cyrillic aliases', () {
    final variants = expander.expand('Minsk, Independence Avenue 10');

    expect(variants.first, 'Minsk, Independence Avenue 10');
    expect(variants, contains('Minsk, Nezavisimosti 10'));
    expect(variants, contains('Minsk, Nezavisimosti'));
    expect(variants.any((v) => v.contains('Независимости')), isTrue);
  });

  test('global expansion does not add Minsk aliases', () {
    final variants = expander.expand(
      'Independence Avenue 10',
      allowMinskAliases: false,
    );

    expect(variants.any((v) => v.contains('Минск')), isFalse);
    expect(variants.any((v) => v.contains('Независимости')), isFalse);
  });

  test('expands Zybitskaya Street to BY-latin and Cyrillic', () {
    final variants = expander.expand('Minsk, Zybitskaya Street');

    expect(variants.any((v) => v.toLowerCase().contains('zybickaja')), isTrue);
    expect(variants, contains('Зыбицкая'));
    expect(variants, contains('улица Зыбицкая'));
    expect(
      variants.any(
        (v) => v.contains('Зыбицкая') && v.toLowerCase().contains('street'),
      ),
      isFalse,
    );
  });

  test('expands Surganova with Cyrillic reverse transliteration', () {
    final variants = expander.expand('Surganova Street, Minsk');

    expect(variants, contains('Сурганова'));
    expect(
      variants.any((v) => v.contains('Сурганова') && v.contains('Минск')),
      isTrue,
    );
  });

  test('strips apartment and leading house number', () {
    final variants = expander.expand('20 Nezavisimosti St., Apt. 15');

    expect(variants, contains('20 Nezavisimosti St.'));
    expect(
      variants.any((v) => v.toLowerCase().contains('nezavisimosti')),
      isTrue,
    );
    expect(variants.any((v) => v.contains('Независимости')), isTrue);
  });

  test('strips office units from expansion seed', () {
    final variants = expander.expand(
      '19 Pobediteley Avenue, Office 501, Minsk',
    );

    expect(variants, contains('19 Pobediteley Avenue, Minsk'));
    expect(variants.any((v) => v.contains('Победителей')), isTrue);
    expect(
      variants.where((v) => !v.toLowerCase().contains('office')),
      isNotEmpty,
    );
  });

  test('strips house number as a fallback variant', () {
    final variants = expander.expand('Зыбицкая 12, Минск');

    expect(variants, contains('Зыбицкая, Минск'));
  });

  test('transliterator maps common street endings', () {
    expect(transliterator.toCyrillic('Zybitskaya'), 'зыбицкая');
    expect(transliterator.toCyrillic('Surganova'), 'сурганова');
    expect(transliterator.toCyrillic('Oktyabrskaya'), 'октябрская');
    expect(transliterator.toCyrillic('Pobediteley'), 'победителей');
  });
}
