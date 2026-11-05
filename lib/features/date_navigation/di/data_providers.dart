import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/l10n/locale_headers.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/search/search_region.dart';
import '../../../core/search/search_region_preferences.dart';
import '../data/datasources/local/cache_service.dart';
import '../data/datasources/remote/chat_remote_data_source.dart';
import '../data/datasources/remote/ticketpro_events_data_source.dart';
import '../domain/ports/event_source.dart';
import '../data/datasources/remote/geocoding_remote_data_source.dart';
import '../data/datasources/remote/osrm_remote_data_source.dart';
import '../data/datasources/remote/places_remote_data_source.dart';
import '../data/datasources/remote/room_remote_data_source.dart';
import 'infra_providers.dart';

part 'data_providers.g.dart';

/// Источник событий TicketPro (на устройстве, без прокси).
@Riverpod(keepAlive: true)
EventSource eventsProxyDataSource(Ref ref) {
  return TicketProEventsDataSource(client: ref.watch(httpClientProvider));
}

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) => CacheService();

@Riverpod(keepAlive: true)
ChatRemoteDataSource chatRemoteDataSource(Ref ref) {
  return ChatRemoteDataSource(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
RoomRemoteDataSource roomRemoteDataSource(Ref ref) {
  return RoomRemoteDataSource(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
GeocodingRemoteDataSource geocodingRemoteDataSource(Ref ref) {
  Locale currentLocale() =>
      ref.read(appLocaleProvider).value ?? const Locale('ru');
  SearchRegion currentRegion() =>
      ref.read(searchRegionControllerProvider).value ?? SearchRegion.global;
  return GeocodingRemoteDataSource(
    client: ref.watch(httpClientProvider),
    cache: ref.watch(cacheServiceProvider),
    acceptLanguage: () => LocaleHeaders.acceptLanguage(currentLocale()),
    cacheLocaleTag: () => LocaleHeaders.cacheLocaleTag(currentLocale()),
    searchRegion: currentRegion,
  );
}

@Riverpod(keepAlive: true)
OsrmRemoteDataSource osrmRemoteDataSource(Ref ref) {
  return OsrmRemoteDataSource(
    client: ref.watch(httpClientProvider),
    cache: ref.watch(cacheServiceProvider),
  );
}

@Riverpod(keepAlive: true)
PlacesRemoteDataSource placesRemoteDataSource(Ref ref) {
  Locale currentLocale() =>
      ref.read(appLocaleProvider).value ?? const Locale('ru');
  return PlacesRemoteDataSource(
    client: ref.watch(httpClientProvider),
    cache: ref.watch(cacheServiceProvider),
    acceptLanguage: () => LocaleHeaders.acceptLanguage(currentLocale()),
    cacheLocaleTag: () => LocaleHeaders.cacheLocaleTag(currentLocale()),
  );
}
