import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/utils/app_logger.dart';
import '../../../config/format_chip_config.dart';
import '../local/cache_service.dart';
import '../../../domain/entities/date_vibe.dart';
import '../../../domain/entities/place.dart';
import '../../../config/date_navigation_config.dart';
import '../../mappers/overpass_place_mapper.dart';
import 'nominatim_places_client.dart';
import 'place_discovery_pipeline.dart';
import '../../../domain/services/place_quality_service.dart';

class PlacesRemoteDataSource {
  static const List<String> _overpassUrls = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
    'https://overpass.openstreetmap.ru/api/interpreter',
  ];

  final http.Client _client;
  final CacheService _cache;
  final PlaceQualityService _qualityService;
  final NominatimPlacesClient _nominatimClient;
  final OverpassPlaceMapper _overpassPlaceMapper;
  final Map<String, Future<List<Place>>> _inFlight = {};

  final Map<String, String> _headers = {
    'User-Agent': DateNavigationConfig.appUserAgent,
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  PlacesRemoteDataSource({
    required http.Client client,
    CacheService? cache,
    PlaceQualityService? qualityService,
    NominatimPlacesClient? nominatimClient,
    OverpassPlaceMapper? overpassPlaceMapper,
  }) : _client = client,
       _cache = cache ?? CacheService(),
       _qualityService = qualityService ?? const PlaceQualityService(),
       _overpassPlaceMapper =
           overpassPlaceMapper ?? const OverpassPlaceMapper(),
       _nominatimClient =
           nominatimClient ??
           NominatimPlacesClient(
             client: client,
             qualityService: qualityService ?? const PlaceQualityService(),
           );

  Future<List<Place>> findPlacesNearby({
    required double lat,
    required double lon,
    required MeetingFormat format,
    int radius = 800,
    int maxRetries = DateNavigationConfig.overpassMaxRetries,
    int radiusExpansionDepth = 0,
  }) async {
    final cacheKey = _cache.makePlacesKey(
      lat,
      lon,
      radius,
      format: format.wireValue,
    );
    final existing = _inFlight[cacheKey];
    if (existing != null) return existing;

    final future = _findPlacesNearbyInternal(
      lat: lat,
      lon: lon,
      format: format,
      radius: radius,
      maxRetries: maxRetries,
      radiusExpansionDepth: radiusExpansionDepth,
      cacheKey: cacheKey,
    );
    _inFlight[cacheKey] = future;
    return future.whenComplete(() => _inFlight.remove(cacheKey));
  }

  Future<List<Place>> _findPlacesNearbyInternal({
    required double lat,
    required double lon,
    required MeetingFormat format,
    required int radius,
    required int maxRetries,
    required int radiusExpansionDepth,
    required String cacheKey,
  }) async {
    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
      AppLogger.e('❌ Некорректные координаты: $lat, $lon');
      return [];
    }

    if (DateNavigationConfig.useNominatimPrimary) {
      final nominatimPlaces = await _nominatimClient.fetchFallback(
        lat: lat,
        lon: lon,
        radius: radius,
        format: format,
      );
      if (nominatimPlaces.isNotEmpty) {
        final unique = _qualityService.dedupePlaces(nominatimPlaces);
        final quality = _resolveWithFallbacks(unique, format: format);
        _qualityService.rankPlacesByRelevance(
          quality,
          centerLat: lat,
          centerLon: lon,
        );
        await _cache.cachePlaces(cacheKey, quality);
        return quality;
      }
      final cachedPlaces = await _cache.getCachedPlaces(cacheKey);
      if (cachedPlaces != null && cachedPlaces.isNotEmpty) {
        final sanitizedCached = _resolveWithFallbacks(
          cachedPlaces,
          format: format,
        );
        if (sanitizedCached.isNotEmpty) {
          _qualityService.rankPlacesByRelevance(
            sanitizedCached,
            centerLat: lat,
            centerLon: lon,
          );
          return sanitizedCached;
        }
      }
      // If Nominatim is rate-limited/empty, continue with Overpass fallback path.
    }

    final String query = _buildFormatQuery(
      format: format,
      radius: radius,
      lat: lat,
      lon: lon,
    );

    int attempt = 0;
    int endpointIndex = 0;

    while (attempt <= maxRetries) {
      try {
        final endpoint = _overpassUrls[endpointIndex];
        final response = await _client
            .post(Uri.parse(endpoint), headers: _headers, body: {'data': query})
            .timeout(
              const Duration(
                seconds: DateNavigationConfig.overpassTimeoutSeconds,
              ),
              onTimeout: () => http.Response('{"error": "timeout"}', 408),
            );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> elements = data['elements'] ?? [];

          if (elements.isEmpty &&
              radius < DateNavigationConfig.placesMaxRadiusMeters &&
              radiusExpansionDepth < 2) {
            final expandedRadius = (radius * 2).clamp(
              DateNavigationConfig.placesMinRadiusMeters,
              DateNavigationConfig.placesMaxRadiusMeters,
            );
            return findPlacesNearby(
              lat: lat,
              lon: lon,
              format: format,
              radius: expandedRadius,
              maxRetries: maxRetries,
              radiusExpansionDepth: radiusExpansionDepth + 1,
            );
          }

          final places = <Place>[];
          for (final element in elements) {
            try {
              if (element['type'] == 'way' && element['center'] != null) {
                final nodeLike = Map<String, dynamic>.from(element);
                nodeLike['lat'] = element['center']['lat'];
                nodeLike['lon'] = element['center']['lon'];
                places.add(_overpassPlaceMapper.fromJson(nodeLike));
              } else if (element['type'] == 'node' && element['lat'] != null) {
                places.add(_overpassPlaceMapper.fromJson(element));
              }
            } catch (e) {
              AppLogger.w('⚠️ Ошибка парсинга элемента: $e');
            }
          }

          final unique = _qualityService.dedupePlaces(places);
          final quality = _resolveWithFallbacks(unique, format: format);
          _qualityService.rankPlacesByRelevance(
            quality,
            centerLat: lat,
            centerLon: lon,
          );
          if (quality.length < DateNavigationConfig.placesMinDesiredResults &&
              radius < DateNavigationConfig.placesMaxRadiusMeters &&
              radiusExpansionDepth < 2) {
            final expandedRadius = (radius * 2).clamp(
              DateNavigationConfig.placesMinRadiusMeters,
              DateNavigationConfig.placesMaxRadiusMeters,
            );
            return findPlacesNearby(
              lat: lat,
              lon: lon,
              format: format,
              radius: expandedRadius,
              maxRetries: maxRetries,
              radiusExpansionDepth: radiusExpansionDepth + 1,
            );
          }
          if (quality.isNotEmpty) {
            await _cache.cachePlaces(cacheKey, quality);
          }
          return quality;
        }

        // retryable statuses: try next endpoint first, then count attempt
        final isRetryable =
            response.statusCode == 408 ||
            response.statusCode == 429 ||
            response.statusCode == 502 ||
            response.statusCode == 504;
        if (isRetryable) {
          if (endpointIndex < _overpassUrls.length - 1) {
            endpointIndex++;
          } else {
            endpointIndex = 0;
            attempt++;
          }
          if (attempt <= maxRetries) {
            await Future.delayed(Duration(seconds: (attempt + 1) * 2));
            continue;
          }
        }

        break;
      } catch (e, stack) {
        AppLogger.e('💥 Исключение при поиске мест', e, stack);
        if (endpointIndex < _overpassUrls.length - 1) {
          endpointIndex++;
        } else {
          endpointIndex = 0;
          attempt++;
        }
        if (attempt <= maxRetries) {
          await Future.delayed(Duration(seconds: (attempt + 1) * 2));
        }
      }
    }

    final fallbackPlaces = await _nominatimClient.fetchFallback(
      lat: lat,
      lon: lon,
      radius: radius,
      format: format,
    );
    if (fallbackPlaces.isNotEmpty) {
      final unique = _qualityService.dedupePlaces(fallbackPlaces);
      final quality = _resolveWithFallbacks(unique, format: format);
      _qualityService.rankPlacesByRelevance(
        quality,
        centerLat: lat,
        centerLon: lon,
      );
      if (quality.length < DateNavigationConfig.placesMinDesiredResults &&
          radius < DateNavigationConfig.placesMaxRadiusMeters &&
          radiusExpansionDepth < 2) {
        final expandedRadius = (radius * 2).clamp(
          DateNavigationConfig.placesMinRadiusMeters,
          DateNavigationConfig.placesMaxRadiusMeters,
        );
        return findPlacesNearby(
          lat: lat,
          lon: lon,
          format: format,
          radius: expandedRadius,
          maxRetries: maxRetries,
          radiusExpansionDepth: radiusExpansionDepth + 1,
        );
      }
      await _cache.cachePlaces(cacheKey, quality);
      return quality;
    }

    final cachedPlaces = await _cache.getCachedPlaces(cacheKey);
    if (cachedPlaces != null && cachedPlaces.isNotEmpty) {
      final sanitizedCached = _resolveWithFallbacks(
        cachedPlaces,
        format: format,
      );
      if (sanitizedCached.isNotEmpty) {
        _qualityService.rankPlacesByRelevance(
          sanitizedCached,
          centerLat: lat,
          centerLon: lon,
        );
        return sanitizedCached;
      }
    }

    return [];
  }

  String _buildFormatQuery({
    required MeetingFormat format,
    required int radius,
    required double lat,
    required double lon,
  }) {
    final selectors = FormatChipConfig.overpassSelectorsFor(format);
    final aroundSelectors = selectors
        .map((selector) => '$selector(around:$radius,$lat,$lon);')
        .join();
    return '[out:json];($aroundSelectors);out body center;';
  }

  bool _matchesFormat(Place place, MeetingFormat format) {
    final text = '${place.name} ${place.address ?? ''}'.toLowerCase();
    const blockedBeautyKeywords = [
      'barber',
      'barbershop',
      'барбершоп',
      'салон',
      'beauty',
      'nails',
      'маникюр',
      'бров',
    ];
    final hasBeautyNoise = blockedBeautyKeywords.any(text.contains);
    if (hasBeautyNoise) return false;

    final allowedTypes = FormatChipConfig.allowedTypesFor(format);
    return place.types.any(allowedTypes.contains);
  }

  List<Place> _resolveWithFallbacks(
    List<Place> candidates, {
    required MeetingFormat format,
  }) {
    final pipeline = PlaceDiscoveryPipeline(
      matchesFormat: (place) => _matchesFormat(place, format),
      isUsablePlace: _qualityService.isUsablePlace,
      diagnosticsLabel: 'format=${format.wireValue}',
      allowedTypesLabel: FormatChipConfig.allowedTypesFor(format).join(','),
      mode: DateNavigationConfig.placesUseSoftDiscoveryFallback
          ? PlaceDiscoveryMode.strictThenSoft
          : PlaceDiscoveryMode.strictOnly,
    );
    return pipeline.resolve(candidates);
  }
}
