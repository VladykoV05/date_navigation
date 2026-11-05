import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core_ui/core_ui.dart';
import '../../../user_profile/user_profile.dart';
import '../widgets/profile_header.dart';
import '../../di/account_di.dart';
import '../widgets/account_empty_state.dart';

class AccountPage extends ConsumerWidget {
  static const int _defaultMapZoom = 16;
  static const String _yandexMapsBaseUrl = 'https://yandex.ru/maps/';

  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final state = ref.watch(accountControllerProvider);
    final accountController = ref.read(accountControllerProvider.notifier);
    final user = ref.watch(currentUserProvider).value;
    final l10n = context.l10n;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.accountTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.accountTabFavorites),
              Tab(text: l10n.accountTabHistory),
            ],
          ),
        ),
        body: Column(
          children: [
            if (user != null)
              ProfileHeader(uid: user.uid, emailOrId: user.email ?? user.uid)
            else
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(l10n.accountUserFallback),
              ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(l10n.privacyTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showPrivacySheet(context),
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: colorScheme.error),
              title: Text(
                l10n.deleteAccountButton,
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () => _confirmDeleteAccount(context, ref),
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text(
                  _localizeAccountError(context, state.error!),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state.favorites.isEmpty)
                    AccountEmptyState(message: l10n.accountFavoritesEmpty)
                  else
                    ListView.separated(
                      itemCount: state.favorites.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final favorite = state.favorites[index];
                        return ListTile(
                          onTap: () =>
                              _showFavoriteInfoSheet(context, favorite),
                          title: Text(favorite.name),
                          subtitle: Text(
                            (favorite.address?.trim().isNotEmpty ?? false)
                                ? favorite.address!
                                : l10n.addressNotSpecified,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.info_outline),
                              IconButton(
                                tooltip: l10n.removeFromFavoritesTooltip,
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () =>
                                    accountController.removeFavorite(favorite),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state.history.isEmpty)
                    AccountEmptyState(message: l10n.accountHistoryEmpty)
                  else
                    ListView.separated(
                      itemCount: state.history.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = state.history[index];
                        final date = item.createdAt;
                        final historyKey = FavoritePlaceKey.fromPlace(
                          placeName: item.placeName,
                          lat: item.lat,
                          lon: item.lon,
                        );
                        final isAlreadyFavorite = state.favorites.any(
                          (favorite) =>
                              FavoritePlaceKey.fromPlace(
                                placeName: favorite.name,
                                lat: favorite.lat,
                                lon: favorite.lon,
                              ) ==
                              historyKey,
                        );
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(item.placeName),
                          onTap: () => _showHistoryInfoSheet(
                            context,
                            ref,
                            item,
                            isAlreadyFavorite: isAlreadyFavorite,
                          ),
                          subtitle: Text(
                            date == null
                                ? l10n.timeUnknown
                                : '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFavoriteInfoSheet(
    BuildContext context,
    UserFavorite favorite,
  ) async {
    final l10n = context.l10n;
    final type = l10n.placeTypeLabelFromWire(favorite.type);
    final address = favorite.address?.trim();
    final lat = favorite.lat;
    final lon = favorite.lon;
    final hasCoordinates = lat != null && lon != null;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favorite.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_cafe, size: 18),
                const SizedBox(width: 6),
                Text(type),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.place_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (address != null && address.isNotEmpty)
                        ? address
                        : l10n.addressNotSpecified,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.pin_drop_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    hasCoordinates
                        ? '${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)}'
                        : l10n.coordinatesNotSaved,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: hasCoordinates
                    ? () => _openFavoriteOnMap(
                        name: favorite.name,
                        address: address,
                        lat: lat,
                        lon: lon,
                      )
                    : null,
                icon: const Icon(Icons.map_outlined),
                label: Text(l10n.openOnMap),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFavoriteOnMap({
    required String name,
    required String? address,
    required double lat,
    required double lon,
  }) async {
    final query = Uri.encodeComponent('$name ${address ?? ''}');
    final url = Uri.parse(
      '$_yandexMapsBaseUrl?text=$query&ll=$lon,$lat&z=$_defaultMapZoom',
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _showHistoryInfoSheet(
    BuildContext context,
    WidgetRef ref,
    MeetingHistoryItem item, {
    required bool isAlreadyFavorite,
  }) async {
    final l10n = context.l10n;
    final date = item.createdAt;
    final formattedDate = date == null
        ? l10n.timeUnknown
        : '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.placeName,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(formattedDate)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.local_offer_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (item.placeType?.trim().isNotEmpty ?? false)
                        ? l10n.placeTypeLabelFromWire(item.placeType)
                        : l10n.typeNotSpecified,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.place_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (item.placeAddress?.trim().isNotEmpty ?? false)
                        ? item.placeAddress!
                        : l10n.addressNotSaved,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: isAlreadyFavorite
                          ? null
                          : () async {
                              await ref
                                  .read(accountControllerProvider.notifier)
                                  .addFavoriteFromHistory(item);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.addedToFavorites),
                                  ),
                                );
                              }
                            },
                      icon: Icon(
                        isAlreadyFavorite
                            ? Icons.bookmark_added_outlined
                            : Icons.bookmark_add_outlined,
                      ),
                      label: Text(
                        isAlreadyFavorite
                            ? l10n.alreadyInFavorites
                            : l10n.addToFavorites,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _openHistoryPlaceOnMap(item.placeName),
                      icon: const Icon(Icons.map_outlined),
                      label: Text(l10n.openOnMap),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openHistoryPlaceOnMap(String placeName) async {
    final query = Uri.encodeComponent(placeName);
    final url = Uri.parse('$_yandexMapsBaseUrl?text=$query&z=$_defaultMapZoom');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _showPrivacySheet(BuildContext context) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.privacyTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(l10n.privacyBody),
              const SizedBox(height: 12),
              Text(
                l10n.storeReadyChecklistNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.showBinary(
      context,
      title: l10n.deleteAccountTitle,
      message: l10n.deleteAccountMessage,
      cancelLabel: l10n.cancelLabel,
      confirmLabel: l10n.deleteAccountConfirm,
    );
    if (confirmed != true || !context.mounted) return;

    final result = await ref
        .read(accountDeletionServiceProvider)
        .deleteCurrentAccount();
    if (!context.mounted) return;
    switch (result) {
      case Ok():
        // AuthGate remounts on signed-out stream; keepAlive session is
        // invalidated there to avoid cross-feature presentation imports.
        break;
      case Err(:final failure):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.localizeFailure(failure))));
    }
  }

  String _localizeAccountError(BuildContext context, String error) {
    return context.l10n.localizeFailure(UnknownFailure(error));
  }
}
