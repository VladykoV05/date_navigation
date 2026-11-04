import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../account/account.dart';
import '../providers/date_navigation_provider.dart';

class DateNavigationAccountMenu extends ConsumerWidget {
  const DateNavigationAccountMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider).value;
    final title = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : (user?.email ?? l10n.accountFallbackTitle);
    final currentLocale = Localizations.localeOf(context);

    return SafeArea(
      child: Material(
        color: Colors.white,
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        child: PopupMenuButton<String>(
          tooltip: l10n.accountMenuTooltip,
          onSelected: (value) async {
            if (value == 'cabinet') {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AccountPage()));
            }
            if (value == 'logout') {
              // Clear keepAlive room session before tearing down auth.
              ref.read(dateNavigationControllerProvider.notifier).leaveRoom();
              ref.invalidate(dateNavigationControllerProvider);
              await ref.read(authSignOutServiceProvider).signOut();
            }
            if (value == 'lang_ru') {
              await ref
                  .read(appLocaleProvider.notifier)
                  .setLocale(const Locale('ru'));
            }
            if (value == 'lang_en') {
              await ref
                  .read(appLocaleProvider.notifier)
                  .setLocale(const Locale('en'));
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              enabled: false,
              value: 'user',
              child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'cabinet',
              child: Text(l10n.accountMenuCabinet),
            ),
            PopupMenuItem<String>(
              enabled: false,
              value: 'language_header',
              child: Text(
                l10n.accountMenuLanguage,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            CheckedPopupMenuItem<String>(
              value: 'lang_ru',
              checked: currentLocale.languageCode == 'ru',
              child: Text(l10n.languageRussian),
            ),
            CheckedPopupMenuItem<String>(
              value: 'lang_en',
              checked: currentLocale.languageCode == 'en',
              child: Text(l10n.languageEnglish),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: Text(l10n.accountMenuLogout),
            ),
          ],
          child: Semantics(
            label: l10n.accountMenuTooltip,
            hint: l10n.accountMenuTooltip,
            button: true,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Icon(Icons.account_circle, size: 30),
            ),
          ),
        ),
      ),
    );
  }
}
