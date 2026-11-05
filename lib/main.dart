import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/deep_links/invite_deep_link_controller.dart';
import 'core/di/analytics_di.dart';
import 'core/di/app_services_di.dart';
import 'core/di/auth_di.dart';
import 'core/l10n/locale_provider.dart';
import 'core/onboarding/onboarding_page.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'firebase_options.dart';
import 'features/auth/auth.dart';
import 'features/date_navigation/date_navigation.dart';
import 'features/date_navigation/presentation/providers/date_navigation_provider.dart';
import 'features/date_navigation/presentation/widgets/chat_notifications_host.dart';
import 'l10n/app_localizations.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (!kIsWeb) {
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
      }

      final bootstrapContainer = ProviderContainer();
      await bootstrapContainer
          .read(firebaseAnalyticsProvider)
          .setAnalyticsCollectionEnabled(kReleaseMode);
      bootstrapContainer.dispose();
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          kReleaseMode,
        );
      }

      if (!kIsWeb) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } else {
        AppLogger.e('Unhandled zone error', error, stack);
      }
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Warm deep-link listener early so cold-start invites survive onboarding.
    ref.watch(inviteDeepLinkControllerProvider);
    final analytics = ref.watch(firebaseAnalyticsProvider);
    final localeAsync = ref.watch(appLocaleProvider);
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      locale: localeAsync.value,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: kReleaseMode
          ? <NavigatorObserver>[FirebaseAnalyticsObserver(analytics: analytics)]
          : const <NavigatorObserver>[],
      home: const ChatNotificationsHost(child: AuthGate()),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(currentUserProvider, (previous, next) {
      final wasSignedIn = previous?.value != null;
      final isSignedOut = next.asData?.value == null;
      if (wasSignedIn && isSignedOut) {
        // Drop keepAlive room session after logout / account deletion.
        ref.invalidate(dateNavigationControllerProvider);
      }
    });
    final authAsync = ref.watch(currentUserProvider);
    return authAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (user) =>
          user == null ? const SignInPage() : const AuthenticatedGate(),
      loading: () {
        // Keep the authenticated tree mounted when a prior user is known
        // (stream reconnects); only block on the first unresolved auth state.
        final previous = authAsync.value;
        if (previous != null) return const AuthenticatedGate();
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (_, _) => const SignInPage(),
    );
  }
}

class AuthenticatedGate extends ConsumerStatefulWidget {
  const AuthenticatedGate({super.key});

  @override
  ConsumerState<AuthenticatedGate> createState() => _AuthenticatedGateState();
}

class _AuthenticatedGateState extends ConsumerState<AuthenticatedGate> {
  bool? _onboardingCompleted;

  @override
  void initState() {
    super.initState();
    ref.read(onboardingPreferencesProvider).isCompleted().then((completed) {
      if (mounted) {
        setState(() => _onboardingCompleted = completed);
      }
    });
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingPreferencesProvider).markCompleted();
    if (mounted) {
      setState(() => _onboardingCompleted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingCompleted == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_onboardingCompleted!) {
      return OnboardingPage(onCompleted: _completeOnboarding);
    }
    return const DateNavigationPage();
  }
}
