import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/core/profile/profile_providers.dart';
import 'package:date_navigation/core/profile/public_profile.dart';
import 'package:date_navigation/core/profile/public_profile_repository.dart';
import 'package:date_navigation/features/account/presentation/widgets/profile_header.dart';
import 'package:date_navigation/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements PublicProfileRepository {
  final List<String> renamed = [];

  @override
  Stream<PublicProfile?> watch(String uid) =>
      Stream.value(PublicProfile(uid: uid, googleName: 'Ivan'));

  @override
  Future<Result<void>> syncFromAuth({
    required String uid,
    String? googleName,
    String? photoUrl,
  }) async => const Ok(null);

  @override
  Future<Result<void>> rename({
    required String uid,
    required String name,
  }) async {
    renamed.add(name);
    return const Ok(null);
  }

  @override
  Future<Result<void>> setAvatarBase64({
    required String uid,
    required String avatarBase64,
  }) async => const Ok(null);

  @override
  Future<Result<void>> setPreset({
    required String uid,
    required int preset,
  }) async => const Ok(null);

  @override
  Future<Result<void>> resetAvatar({required String uid}) async =>
      const Ok(null);
}

void main() {
  testWidgets('rename dialog: cancel closes without errors', (tester) async {
    final repo = _FakeRepo();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [publicProfileRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: ProfileHeader(uid: 'u1', emailOrId: 'ivan@example.com'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Новое имя');
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(repo.renamed, isEmpty);
  });

  testWidgets('rename dialog: save sends the new name', (tester) async {
    final repo = _FakeRepo();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [publicProfileRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: ProfileHeader(uid: 'u1', emailOrId: 'ivan@example.com'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  Иван  ');
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(repo.renamed, ['Иван']);
  });
}
