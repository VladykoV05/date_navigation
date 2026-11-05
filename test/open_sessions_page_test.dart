import 'package:date_navigation/features/date_navigation/domain/entities/room_snapshot.dart';
import 'package:date_navigation/features/date_navigation/presentation/pages/open_sessions_page.dart';
import 'package:date_navigation/features/date_navigation/presentation/providers/open_sessions_provider.dart';
import 'package:date_navigation/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

RoomSnapshot _room({
  required String id,
  required int capacity,
  required List<String> participants,
  String? eventTitle,
}) {
  return RoomSnapshot(
    id: id,
    creatorUid: 'host',
    hostUid: 'host',
    type: RoomType.open,
    visibility: RoomVisibility.public,
    capacity: capacity,
    participants: [for (final uid in participants) RoomParticipant(uid: uid)],
    event: eventTitle == null
        ? null
        : RoomEventSnapshot(id: 'e-$id', title: eventTitle),
  );
}

Widget _app(List<RoomSnapshot> rooms) {
  return ProviderScope(
    overrides: [openSessionsProvider.overrideWith((ref) async => rooms)],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const OpenSessionsPage(),
    ),
  );
}

void main() {
  testWidgets('shows event title and member count for open rooms', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app([
        _room(
          id: 'r1',
          capacity: 4,
          participants: ['host', 'a'],
          eventTitle: 'Zoloto',
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Zoloto'), findsOneWidget);
    expect(find.text('2 of 4'), findsOneWidget);
    expect(find.text('Join'), findsOneWidget);
  });

  testWidgets('full room disables join button', (tester) async {
    await tester.pumpWidget(
      _app([
        _room(id: 'r2', capacity: 2, participants: ['host', 'a']),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Full'), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('empty list shows empty state', (tester) async {
    await tester.pumpWidget(_app(const []));
    await tester.pumpAndSettle();

    expect(
      find.text('No open sessions yet. Create one and invite people.'),
      findsOneWidget,
    );
  });
}
