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

  test('presentation layer does not import other feature presentation', () {
    final offenders = _featureImportOffenders(
      featureFiles.where((file) => file.path.contains('/presentation/')),
      (currentFeature, importPath) {
        final targetFeature = _targetFeature(importPath);
        return targetFeature != null &&
            targetFeature != currentFeature &&
            importPath.contains('/presentation/');
      },
    );

    expect(offenders, isEmpty);
  });

  test('features do not import other feature di internals directly', () {
    final offenders = _featureImportOffenders(featureFiles, (
      currentFeature,
      importPath,
    ) {
      final targetFeature = _targetFeature(importPath);
      return targetFeature != null &&
          targetFeature != currentFeature &&
          importPath.contains('/di/');
    });

    expect(offenders, isEmpty);
  });

  test('data layer does not import other feature application internals', () {
    final offenders = _featureImportOffenders(
      featureFiles.where((file) => file.path.contains('/data/')),
      (currentFeature, importPath) {
        final targetFeature = _targetFeature(importPath);
        if (targetFeature == null || targetFeature == currentFeature) {
          return false;
        }
        return importPath.contains('/data/') ||
            importPath.contains('/di/') ||
            importPath.contains('/presentation/') ||
            importPath.contains('/application/') ||
            importPath.contains('/domain/usecases/');
      },
    );

    expect(offenders, isEmpty);
  });

  test('domain layer does not import feature config', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/domain/')),
      RegExp(r"import '.*(/config/|\.\./\.\./config/)"),
    );

    expect(offenders, isEmpty);
  });

  test('domain layer does not import map coordinate packages', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/domain/')),
      RegExp(r"import 'package:latlong2/"),
    );

    expect(offenders, isEmpty);
  });

  test('domain facade barrels do not export presentation layer', () {
    final barrelFiles = featureFiles.where((file) {
      final normalized = file.path.replaceAll('\\', '/');
      if (!RegExp(r'lib/features/[^/]+/[^/]+\.dart$').hasMatch(normalized)) {
        return false;
      }
      final content = file.readAsStringSync();
      return content.contains("export 'domain/") || content.contains("export 'di/");
    });

    final offenders = _filesContaining(
      barrelFiles,
      RegExp(r"export '.*presentation/"),
    );

    expect(offenders, isEmpty);
  });

  test('date_navigation presentation does not import user_profile presentation', () {
    final offenders = _featureImportOffenders(
      featureFiles.where(
        (file) =>
            file.path.contains('/date_navigation/') &&
            file.path.contains('/presentation/'),
      ),
      (currentFeature, importPath) {
        return _targetFeature(importPath) == 'user_profile' &&
            importPath.contains('/presentation/');
      },
    );

    expect(offenders, isEmpty);
  });

  test('application layer does not import presentation layer', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/application/')),
      RegExp(r"import '.*presentation/"),
    );

    expect(offenders, isEmpty);
  });

  test('application layer does not import feature data layers', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/application/')),
      RegExp(
        r"import '.*features/.*/data/|import '../data/|import '../../data/",
      ),
    );

    expect(offenders, isEmpty);
  });

  test('data layer does not import application layer', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/data/')),
      RegExp(r"import '.*application/"),
    );

    expect(offenders, isEmpty);
  });

  test('presentation widgets do not import domain entities', () {
    final offenders = _filesContaining(
      featureFiles.where((file) => file.path.contains('/presentation/widgets/')),
      RegExp(r"import '.*domain/entities/"),
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

List<String> _featureImportOffenders(
  Iterable<File> files,
  bool Function(String currentFeature, String importPath) violates,
) {
  return [
    for (final file in files)
      for (final importPath in _importPaths(file))
        if (violates(_currentFeature(file), importPath))
          '${file.path} imports $importPath',
  ];
}

Iterable<String> _importPaths(File file) {
  final content = file.readAsStringSync();
  return RegExp(
    r"import '([^']+)';",
  ).allMatches(content).map((match) => match.group(1)!);
}

String _currentFeature(File file) {
  final parts = file.path.split(Platform.pathSeparator);
  final featuresIndex = parts.indexOf('features');
  return parts[featuresIndex + 1];
}

String? _targetFeature(String importPath) {
  if (importPath.contains('/core/') || importPath.endsWith('/core')) {
    return null;
  }
  final packageMatch = RegExp(r'features/([^/]+)/').firstMatch(importPath);
  if (packageMatch != null) return packageMatch.group(1);

  final relativeMatch = RegExp(
    r'^\.\./\.\./\.\./([^/]+)/',
  ).firstMatch(importPath);
  final feature = relativeMatch?.group(1);
  return feature == 'core' ? null : feature;
}
