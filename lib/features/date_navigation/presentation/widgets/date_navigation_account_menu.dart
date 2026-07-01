import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../../account/account.dart';

class DateNavigationAccountMenu extends ConsumerWidget {
  const DateNavigationAccountMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final title = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : (user?.email ?? 'Аккаунт');

    return SafeArea(
      child: Material(
        color: Colors.white,
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        child: PopupMenuButton<String>(
          tooltip: 'Аккаунт',
          onSelected: (value) {
            if (value == 'cabinet') {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AccountPage()));
            }
            if (value == 'logout') {
              ref.read(authSignOutServiceProvider).signOut();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              enabled: false,
              value: 'user',
              child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'cabinet',
              child: Text('Кабинет'),
            ),
            const PopupMenuItem<String>(value: 'logout', child: Text('Выйти')),
          ],
          child: Semantics(
            label: 'Меню аккаунта',
            hint: 'Открывает действия аккаунта',
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
