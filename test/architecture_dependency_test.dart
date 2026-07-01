import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final featureFiles = Directory('lib/features')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => !file.path.endsWith('.g.dart'))
      .where((file) => !file.path.endsWith('.freezed.dart'))
      .toList(growable: false);

  test('domain layer does not import Firebase packages', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/domain/')),
      RegExp(r"import 'package:(cloud_firestore|firebase_)"),
    );

    expect(offenders, isEmpty);
  });

  test('presentation layer does not import feature data layers', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/presentation/')),
      RegExp(
        r"import '.*features/.*/data/|import '../data/|import '../../data/",
      ),
    );

    expect(offenders, isEmpty);
  });

  test('data layer does not import presentation layer', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/data/')),
      RegExp(r"import '.*presentation/"),
    );

    expect(offenders, isEmpty);
  });
}

List<String> _filesContaining(Iterable<File> files, Pattern pattern) {
  return files
      .where((file) => file.readAsStringSync().contains(pattern))
      .map((file) => file.path)
      .toList(growable: false);
}
