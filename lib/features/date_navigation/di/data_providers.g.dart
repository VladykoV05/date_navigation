// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(walkingRouteSource)
final walkingRouteSourceProvider = WalkingRouteSourceProvider._();

final class WalkingRouteSourceProvider
    extends
        $FunctionalProvider<
          WalkingRouteSource,
          WalkingRouteSource,
          WalkingRouteSource
        >
    with $Provider<WalkingRouteSource> {
  WalkingRouteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walkingRouteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walkingRouteSourceHash();

  @$internal
  @override
  $ProviderElement<WalkingRouteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WalkingRouteSource create(Ref ref) {
    return walkingRouteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalkingRouteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalkingRouteSource>(value),
    );
  }
}

String _$walkingRouteSourceHash() =>
    r'30b2f2a4b5e177645ca90c2bcfd77147b2b29ea9';

/// Источник событий TicketPro (на устройстве, без прокси).

@ProviderFor(eventsProxyDataSource)
final eventsProxyDataSourceProvider = EventsProxyDataSourceProvider._();

/// Источник событий TicketPro (на устройстве, без прокси).

final class EventsProxyDataSourceProvider
    extends $FunctionalProvider<EventSource, EventSource, EventSource>
    with $Provider<EventSource> {
  /// Источник событий TicketPro (на устройстве, без прокси).
  EventsProxyDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsProxyDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsProxyDataSourceHash();

  @$internal
  @override
  $ProviderElement<EventSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventSource create(Ref ref) {
    return eventsProxyDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventSource>(value),
    );
  }
}

String _$eventsProxyDataSourceHash() =>
    r'e1eeec9f4b8a30006e1ab5479808c39df5fea064';

@ProviderFor(cacheService)
final cacheServiceProvider = CacheServiceProvider._();

final class CacheServiceProvider
    extends $FunctionalProvider<CacheService, CacheService, CacheService>
    with $Provider<CacheService> {
  CacheServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheServiceHash();

  @$internal
  @override
  $ProviderElement<CacheService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheService create(Ref ref) {
    return cacheService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheService>(value),
    );
  }
}

String _$cacheServiceHash() => r'bf5dee3937cc8737dd1550a43c77eedd44eba0bd';

@ProviderFor(chatRemoteDataSource)
final chatRemoteDataSourceProvider = ChatRemoteDataSourceProvider._();

final class ChatRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ChatRemoteDataSource,
          ChatRemoteDataSource,
          ChatRemoteDataSource
        >
    with $Provider<ChatRemoteDataSource> {
  ChatRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ChatRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatRemoteDataSource create(Ref ref) {
    return chatRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRemoteDataSource>(value),
    );
  }
}

String _$chatRemoteDataSourceHash() =>
    r'30ce348317cb3b9827601172f22e32eef1648bdf';

@ProviderFor(roomRemoteDataSource)
final roomRemoteDataSourceProvider = RoomRemoteDataSourceProvider._();

final class RoomRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          RoomRemoteDataSource,
          RoomRemoteDataSource,
          RoomRemoteDataSource
        >
    with $Provider<RoomRemoteDataSource> {
  RoomRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<RoomRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoomRemoteDataSource create(Ref ref) {
    return roomRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomRemoteDataSource>(value),
    );
  }
}

String _$roomRemoteDataSourceHash() =>
    r'a0fe01f3ba31a4a56a103c1ded3f8eb96e551634';

@ProviderFor(geocodingRemoteDataSource)
final geocodingRemoteDataSourceProvider = GeocodingRemoteDataSourceProvider._();

final class GeocodingRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          GeocodingRemoteDataSource,
          GeocodingRemoteDataSource,
          GeocodingRemoteDataSource
        >
    with $Provider<GeocodingRemoteDataSource> {
  GeocodingRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geocodingRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geocodingRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<GeocodingRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeocodingRemoteDataSource create(Ref ref) {
    return geocodingRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeocodingRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeocodingRemoteDataSource>(value),
    );
  }
}

String _$geocodingRemoteDataSourceHash() =>
    r'b467bd58eeffc1152f554c90a36e46845b8cb0f6';

@ProviderFor(osrmRemoteDataSource)
final osrmRemoteDataSourceProvider = OsrmRemoteDataSourceProvider._();

final class OsrmRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          OsrmRemoteDataSource,
          OsrmRemoteDataSource,
          OsrmRemoteDataSource
        >
    with $Provider<OsrmRemoteDataSource> {
  OsrmRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'osrmRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$osrmRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<OsrmRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OsrmRemoteDataSource create(Ref ref) {
    return osrmRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OsrmRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OsrmRemoteDataSource>(value),
    );
  }
}

String _$osrmRemoteDataSourceHash() =>
    r'342c59c92bfb8ef985122e3c96ca6775b60b7e8e';

@ProviderFor(placesRemoteDataSource)
final placesRemoteDataSourceProvider = PlacesRemoteDataSourceProvider._();

final class PlacesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          PlacesRemoteDataSource,
          PlacesRemoteDataSource,
          PlacesRemoteDataSource
        >
    with $Provider<PlacesRemoteDataSource> {
  PlacesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placesRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PlacesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlacesRemoteDataSource create(Ref ref) {
    return placesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlacesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlacesRemoteDataSource>(value),
    );
  }
}

String _$placesRemoteDataSourceHash() =>
    r'962a78b2b6339a064826b59383b8a054a4d12b80';
