import 'package:date_navigation/features/date_navigation/presentation/view_data/open_participant_view_data.dart';
import 'package:date_navigation/features/date_navigation/presentation/widgets/open_session/open_session_panel.dart';
import 'package:date_navigation/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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

Widget _host0({
  required List<OpenParticipantViewData> participants,
  required bool hasOwnPoint,
  VoidCallback? onLeave,
}) {
  return MaterialApp(
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
}
