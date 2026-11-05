import 'package:date_navigation/features/date_navigation/presentation/view_data/open_participant_view_data.dart';
import 'package:date_navigation/features/date_navigation/presentation/widgets/open_session/open_session_panel.dart';
import 'package:date_navigation/l10n/app_localizations.dart';
import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/core/profile/public_profile.dart';
import 'package:date_navigation/core/profile/public_profile_repository.dart';
import 'package:date_navigation/core/profile/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _host = OpenParticipantViewData(
  uid: 'host',
  isHost: true,
  hasAddress: true,
);
const _me = OpenParticipantViewData(
  uid: 'me',
  isHost: false,
  hasAddress: false,
);
const _other = OpenParticipantViewData(
  uid: 'other',
  isHost: false,
  hasAddress: true,
);

class _NoProfileRepository implements PublicProfileRepository {
  @override
  Stream<PublicProfile?> watch(String uid) => Stream.value(null);

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
  }) async => const Ok(null);

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

Widget _host0({
  required List<OpenParticipantViewData> participants,
  required bool hasOwnPoint,
  VoidCallback? onLeave,
  bool canLeave = true,
  bool isClosed = false,
  bool isExpired = false,
  bool canComplete = false,
  VoidCallback? onComplete,
}) {
  return ProviderScope(
    overrides: [
      publicProfileRepositoryProvider.overrideWithValue(_NoProfileRepository()),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: OpenSessionPanel(
            displayCode: 'ABC123',
            participants: participants,
            selfUid: 'me',
            hasOwnPoint: hasOwnPoint,
            canSubmitAddress: true,
            addressController: TextEditingController(),
            onAddressSubmit: () {},
            onOpenChat: () {},
            onLeaveRoom: onLeave ?? () {},
            unreadCount: 0,
            event: null,
            canLeave: canLeave,
            isClosed: isClosed,
            isExpired: isExpired,
            canComplete: canComplete,
            onCompleteSession: onComplete ?? () {},
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('UC-06: shows every participant with address status', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host0(participants: const [_host, _me, _other], hasOwnPoint: true),
    );
    await tester.pumpAndSettle();

    expect(find.text('Вы'), findsOneWidget);
    expect(find.text('Хост'), findsOneWidget);
    expect(find.text('Участник 3'), findsOneWidget);
    expect(find.text('адрес указан'), findsNWidgets(2));
    expect(find.text('адрес не указан'), findsOneWidget);
  });

  testWidgets('UC-08: tapping a participant opens card with address status', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host0(participants: const [_host, _other], hasOwnPoint: true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Участник 2'));
    await tester.pumpAndSettle();

    expect(find.text('Участник'), findsOneWidget);
    expect(find.text('адрес указан'), findsNWidgets(3));
  });

  testWidgets('UC-09: address button shown only without own point', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host0(participants: const [_host, _me], hasOwnPoint: false),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ввести адрес'), findsOneWidget);

    await tester.pumpWidget(
      _host0(participants: const [_host, _me], hasOwnPoint: true),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ввести адрес'), findsNothing);
  });

  testWidgets('UC-11: leave button calls onLeaveRoom', (tester) async {
    var left = false;
    await tester.pumpWidget(
      _host0(
        participants: const [_host],
        hasOwnPoint: true,
        onLeave: () => left = true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Выйти'));
    await tester.pump();
    expect(left, isTrue);
  });

  testWidgets('UC-11: solo host cannot leave, sees hint, tap does nothing', (
    tester,
  ) async {
    var left = false;
    await tester.pumpWidget(
      _host0(
        participants: const [_host, _other],
        hasOwnPoint: true,
        canLeave: false,
        onLeave: () => left = true,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Чтобы выйти, завершите сессию: вы единственный участник'),
      findsOneWidget,
    );
    await tester.tap(find.text('Выйти'));
    await tester.pump();
    expect(left, isFalse);
  });

  testWidgets('UC-13: host confirms before ending the session', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      _host0(
        participants: const [_host, _other],
        hasOwnPoint: true,
        canComplete: true,
        onComplete: () => completed = true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Завершить сессию'));
    await tester.pumpAndSettle();
    expect(find.text('Завершить сессию?'), findsOneWidget);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(completed, isFalse);

    await tester.tap(find.text('Завершить сессию'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Завершить'));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
  });

  testWidgets('UC-13: closed session shows status and hides complete action', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host0(
        participants: const [_host, _other],
        hasOwnPoint: true,
        isClosed: true,
        canComplete: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Сессия завершена. Чат только для чтения, вход закрыт.'),
      findsOneWidget,
    );
    expect(find.text('Завершить сессию'), findsNothing);
    expect(find.text('Создать новую комнату'), findsNothing);
  });

  testWidgets('tabs: plan tab shows no-event text without event', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host0(participants: const [_host], hasOwnPoint: true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('План'));
    await tester.pumpAndSettle();
    expect(find.text('Открытая сессия'), findsOneWidget);
  });

  testWidgets('UC-14: expired session shows expiry text', (tester) async {
    await tester.pumpWidget(
      _host0(
        participants: const [_host, _other],
        hasOwnPoint: true,
        isClosed: true,
        isExpired: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Сессия истекла. Чат только для чтения, вход закрыт.'),
      findsOneWidget,
    );
  });
}
