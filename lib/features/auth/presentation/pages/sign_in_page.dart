import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/show_notification.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await ref.read(authSignInServiceProvider).signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ShowNotification.showSnackBar(
        context,
        context.l10n.signInError(e.message ?? e.code),
      );
    } catch (e, stack) {
      AppLogger.e('Google sign-in failed', e, stack);
      if (!mounted) return;
      ShowNotification.showSnackBar(
        context,
        context.l10n.signInGenericError('$e'),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.9),
                      colorScheme.surface,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.place_rounded,
                      size: 38,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.signInTitle,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.signInSubtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      label: Text(
                        _isLoading ? l10n.signInLoading : l10n.signInButton,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
