import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/utils/place_type_localizer.dart';
import '../../domain/entities/account_favorite.dart';
import '../../domain/entities/account_history_item.dart';
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
    final user = ref.watch(currentUserProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Кабинет'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Избранное'),
              Tab(text: 'История'),
            ],
          ),
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(user?.displayName ?? 'Пользователь'),
              subtitle: Text(user?.email ?? user?.uid ?? ''),
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text(
                  state.error!,
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
                    const AccountEmptyState(message: 'Избранное пока пустое')
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
                                : 'Адрес не указан',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.info_outline),
                              IconButton(
                                tooltip: 'Удалить из избранного',
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
                    const AccountEmptyState(
                      message: 'История встреч пока пустая',
                    )
                  else
                    ListView.separated(
                      itemCount: state.history.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = state.history[index];
                        final date = item.createdAt;
                        final isAlreadyFavorite = state.favorites.any(
                          (favorite) =>
                              favorite.name.trim().toLowerCase() ==
                              item.placeName.trim().toLowerCase(),
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
                                ? 'Время неизвестно'
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
    AccountFavorite favorite,
  ) async {
    final type = localizePlaceType(favorite.type);
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
                        : 'Адрес не указан',
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
                        : 'Координаты не сохранены',
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
                label: const Text('Открыть на карте'),
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
    AccountHistoryItem item, {
    required bool isAlreadyFavorite,
  }) async {
    final date = item.createdAt;
    final formattedDate = date == null
        ? 'Время неизвестно'
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
                        ? localizePlaceType(item.placeType)
                        : 'Тип не указан',
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
                        : 'Адрес не сохранен',
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
                                  const SnackBar(
                                    content: Text('Добавлено в избранное'),
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
                        isAlreadyFavorite ? 'Уже в избранном' : 'В избранное',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _openHistoryPlaceOnMap(item.placeName),
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Открыть на карте'),
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
}
