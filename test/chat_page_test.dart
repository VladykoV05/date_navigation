import 'package:date_navigation/core/di/auth_di.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/core/services/auth_session.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/chat_message.dart';
import 'package:date_navigation/features/date_navigation/domain/repositories/chat_repository.dart';
import 'package:date_navigation/features/date_navigation/presentation/pages/chat_page.dart';
import 'package:date_navigation/features/date_navigation/di/date_navigation_di.dart';
import 'package:date_navigation/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthSession implements AuthSession {
  const _FakeAuthSession(this.currentUserId);

  @override
  final String? currentUserId;

  @override
  Stream<User?> authStateChanges() => const Stream.empty();

  @override
  Future<void> signOut() async {}
}

class _FakeChatRepository implements ChatRepository {
  _FakeChatRepository(this.messages);

  final List<ChatMessage> messages;
  String? lastText;

  @override
  Stream<List<ChatMessage>> watchMessages(String roomId, {int limit = 50}) {
    return Stream.value(messages);
  }

  @override
  Future<Result<List<ChatMessage>>> fetchMessages({
    required String roomId,
    required int limit,
    DateTime? before,
  }) async {
    return const Ok([]);
  }

  @override
  Stream<DateTime?> watchLastRead({
    required String roomId,
    required String userId,
  }) {
    return Stream.value(null);
  }

  @override
  Future<Result<void>> sendMessage({
    required String roomId,
    required String senderUid,
    required String text,
    required String clientId,
  }) async {
    lastText = text;
    return const Ok(null);
  }

  @override
  Future<Result<void>> sendSystemMessage({
    required String roomId,
    required String senderUid,
    required String code,
  }) async {
    return const Ok(null);
  }

  @override
  Future<Result<void>> markRead({
    required String roomId,
    required String userId,
  }) async {
    return const Ok(null);
  }
}

Widget _app(_FakeChatRepository repository) {
  return ProviderScope(
    overrides: [
      authSessionProvider.overrideWithValue(const _FakeAuthSession('me')),
      chatRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ChatPage(roomId: 'room-1'),
    ),
  );
}

void main() {
  testWidgets('renders messages and sends text', (tester) async {
    final repository = _FakeChatRepository([
      ChatMessage(
        id: 'm1',
        senderUid: 'partner',
        text: 'Hi',
        createdAt: DateTime(2026),
      ),
    ]);
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('Hi'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(repository.lastText, 'Hello');
  });

  testWidgets('shows empty state', (tester) async {
    await tester.pumpWidget(_app(_FakeChatRepository(const [])));
    await tester.pumpAndSettle();

    expect(find.text('No messages yet'), findsOneWidget);
  });
}
