import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/search/search_region.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../config/date_navigation_config.dart';
import '../local/cache_service.dart';
import 'geocoding_query_expander.dart';

class GeocodingRemoteDataSource {
  static const _nominatimUrl = 'https://nominatim.openstreetmap.org/search';
  static const _photonUrl = 'https://photon.komoot.io/api/';
  static const _maxNominatimVariants = 8;

  final http.Client _client;
  final CacheService _cache;
  final String Function() _acceptLanguage;
  final String Function()? _cacheLocaleTag;
  final SearchRegion Function() _searchRegion;
  final GeocodingQueryExpander _queryExpander;

  GeocodingRemoteDataSource({
    required http.Client client,
    required CacheService cache,
    required String Function() acceptLanguage,
    String Function()? cacheLocaleTag,
    SearchRegion Function()? searchRegion,
    GeocodingQueryExpander? queryExpander,
  }) : _client = client,
       _acceptLanguage = acceptLanguage,
       _cacheLocaleTag = cacheLocaleTag,
       _searchRegion = searchRegion ?? (() => SearchRegion.global),
       _cache = cache,
       _queryExpander = queryExpander ?? const GeocodingQueryExpander();

  SearchRegion get _region => _searchRegion();

  Future<Result<({double lat, double lon})?>> geocodeAddress(
    String address,
  ) async {
    if (address.isEmpty) return const Ok(null);

    final localeTag = _cacheLocaleTag?.call();
    final regionKey = _region.cacheKey;
    final cached = await _cache.getCachedCoords(
      address,
      localeTag: localeTag,
      regionKey: regionKey,
    );
    if (cached != null) {
      return Ok((lat: cached['lat']!, lon: cached['lon']!));
    }

    try {
      Failure? lastFailure;
      final variants = _queryExpander
          .expand(
            address,
            allowMinskAliases: _region.id == SearchRegion.minsk.id,
          )
          .take(_maxNominatimVariants);

      for (final query in variants) {
        AppLogger.d('🔍 Геокодинг Nominatim: $query');
        final lookup = await _lookupNominatim(query);
        switch (lookup) {
          case _GeocodeHit(:final lat, :final lon):
            return await _cacheAndOk(address, lat, lon, localeTag, regionKey);
          case _GeocodeEmpty():
            continue;
          case _GeocodeFailed(:final failure):
            lastFailure = failure;
            if (failure is TimeoutFailure || failure is RateLimitFailure) {
              return Err(failure);
            }
            continue;
        }
      }

      // Photon often indexes English/exonym names better than Nominatim search.
      AppLogger.d('🔍 Геокодинг Photon fallback: $address');
      final photon = await _lookupPhoton(address);
      switch (photon) {
        case _GeocodeHit(:final lat, :final lon):
          return await _cacheAndOk(address, lat, lon, localeTag, regionKey);
        case _GeocodeEmpty():
          break;
        case _GeocodeFailed(:final failure):
          lastFailure ??= failure;
          if (failure is TimeoutFailure || failure is RateLimitFailure) {
            return Err(failure);
          }
      }

      if (lastFailure != null) return Err(lastFailure);
      AppLogger.w('⚠️ Адрес не найден: $address');
      return const Ok(null);
    } catch (e, stack) {
      AppLogger.e('💥 Исключение при геокодинге', e, stack);
      return const Err(UnknownFailure(FailureCodes.geocodingUnknown));
    }
  }

  Future<Result<({double lat, double lon})?>> _cacheAndOk(
    String address,
    double lat,
    double lon,
    String? localeTag,
    String regionKey,
  ) async {
    await _cache.cacheCoords(
      address,
      {'lat': lat, 'lon': lon},
      localeTag: localeTag,
      regionKey: regionKey,
    );
    return Ok((lat: lat, lon: lon));
  }

  Future<_GeocodeOutcome> _lookupNominatim(String query) async {
    final region = _region;
    final uri = Uri.parse(_nominatimUrl).replace(
      queryParameters: <String, String>{
        'q': query,
        'format': 'json',
        'limit': '1',
        if (region.countryCode != null) 'countrycodes': region.countryCode!,
        if (region.hasCenter) 'viewbox': _viewboxFor(region),
      },
    );

    final response = await _get(uri);
    return _parseNominatim(response);
  }

  Future<_GeocodeOutcome> _lookupPhoton(String address) async {
    final region = _region;
    final uri = Uri.parse(_photonUrl).replace(
      queryParameters: <String, String>{
        'q': address,
        'limit': '8',
        'lang': _photonLang(),
        if (region.hasCenter) 'lat': '${region.latitude}',
        if (region.hasCenter) 'lon': '${region.longitude}',
      },
    );

    final response = await _get(uri);
    return _parsePhoton(response, requireNearBias: region.hasCenter);
  }

  String _viewboxFor(SearchRegion region) {
    final latitude = region.latitude!;
    final longitude = region.longitude!;
    final radiusKm = region.radiusKm ?? 45;
    final latDelta = radiusKm / 111.0;
    final lonDelta = radiusKm / (111.0 * math.cos(latitude * math.pi / 180.0));
    return '${longitude - lonDelta},${latitude + latDelta},'
        '${longitude + lonDelta},${latitude - latDelta}';
  }

  Future<http.Response> _get(Uri uri) {
    return _client
        .get(
          uri,
          headers: {
            'User-Agent': DateNavigationConfig.appUserAgent,
            'Accept-Language': _acceptLanguage(),
          },
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            AppLogger.w('⏰ Таймаут запроса геокодинга');
            return http.Response('{"error": "timeout"}', 408);
          },
        );
  }

  _GeocodeOutcome _parseNominatim(http.Response response) {
    if (response.statusCode == 408) {
      return const _GeocodeFailed(
        TimeoutFailure(FailureCodes.geocodingTimeout),
      );
    }
    if (response.statusCode == 429) {
      return const _GeocodeFailed(
        RateLimitFailure(FailureCodes.geocodingRateLimit),
      );
    }
    if (response.statusCode != 200) {
      AppLogger.e('❌ Ошибка Nominatim: ${response.statusCode}');
      return const _GeocodeFailed(NetworkFailure(FailureCodes.geocodingHttp));
    }

    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    if (data.isEmpty) return const _GeocodeEmpty();

    final firstResult = data[0] as Map<String, dynamic>;
    final lat = double.parse(firstResult['lat'].toString());
    final lon = double.parse(firstResult['lon'].toString());
    return _GeocodeHit(lat: lat, lon: lon);
  }

  _GeocodeOutcome _parsePhoton(
    http.Response response, {
    required bool requireNearBias,
  }) {
    if (response.statusCode == 408) {
      return const _GeocodeFailed(
        TimeoutFailure(FailureCodes.geocodingTimeout),
      );
    }
    if (response.statusCode == 429) {
      return const _GeocodeFailed(
        RateLimitFailure(FailureCodes.geocodingRateLimit),
      );
    }
    if (response.statusCode != 200) {
      AppLogger.e('❌ Ошибка Photon: ${response.statusCode}');
      return const _GeocodeFailed(NetworkFailure(FailureCodes.geocodingHttp));
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final features = decoded['features'] as List<dynamic>? ?? const [];
    if (features.isEmpty) return const _GeocodeEmpty();

    _PhotonCandidate? best;
    for (final raw in features) {
      final feature = raw as Map<String, dynamic>;
      final props = feature['properties'] as Map<String, dynamic>? ?? const {};
      final geometry = feature['geometry'] as Map<String, dynamic>? ?? const {};
      final coords = geometry['coordinates'] as List<dynamic>?;
      if (coords == null || coords.length < 2) continue;

      final lon = (coords[0] as num).toDouble();
      final lat = (coords[1] as num).toDouble();
      final countryCode = (props['countrycode'] ?? '').toString().toUpperCase();
      final expectedCountry = _region.countryCode?.toUpperCase();
      if (expectedCountry != null &&
          countryCode.isNotEmpty &&
          countryCode != expectedCountry) {
        continue;
      }

      final type = (props['type'] ?? '').toString().toLowerCase();
      final osmKey = (props['osm_key'] ?? '').toString().toLowerCase();
      final nearBias = _isNearBias(lat, lon);
      if (requireNearBias && !nearBias) continue;

      // Prefer real addresses / streets over POIs and vague localities.
      final score = _photonScore(
        type: type,
        osmKey: osmKey,
        nearBias: nearBias,
      );
      if (score <= 0) continue;

      final candidate = _PhotonCandidate(lat: lat, lon: lon, score: score);
      if (best == null || candidate.score > best.score) {
        best = candidate;
      }
    }

    if (best == null) return const _GeocodeEmpty();
    return _GeocodeHit(lat: best.lat, lon: best.lon);
  }

  int _photonScore({
    required String type,
    required String osmKey,
    required bool nearBias,
  }) {
    final typeScore = switch (type) {
      'house' => 50,
      'street' => 40,
      'district' || 'locality' || 'neighbourhood' => 10,
      'city' || 'county' || 'state' || 'country' => 0,
      _ => 5,
    };
    if (typeScore == 0) return 0;

    var score = typeScore;
    if (osmKey == 'highway' || osmKey == 'place' || osmKey == 'addr') {
      score += 15;
    }
    if (osmKey == 'amenity' || osmKey == 'shop' || osmKey == 'tourism') {
      score -= 25;
    }
    if (nearBias) score += 10;
    return score;
  }

  bool _isNearBias(double lat, double lon) {
    final region = _region;
    if (!region.hasCenter) return false;
    return _haversineKm(lat, lon, region.latitude!, region.longitude!) <=
        (region.radiusKm ?? 45);
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _degToRad(double deg) => deg * math.pi / 180.0;

  String _photonLang() {
    final tag = _acceptLanguage().toLowerCase();
    if (tag.startsWith('ru')) return 'ru';
    return 'en';
  }
}

class _PhotonCandidate {
  const _PhotonCandidate({
    required this.lat,
    required this.lon,
    required this.score,
  });

  final double lat;
  final double lon;
  final int score;
}

sealed class _GeocodeOutcome {
  const _GeocodeOutcome();
}

class _GeocodeHit extends _GeocodeOutcome {
  const _GeocodeHit({required this.lat, required this.lon});
  final double lat;
  final double lon;
}

class _GeocodeEmpty extends _GeocodeOutcome {
  const _GeocodeEmpty();
}

class _GeocodeFailed extends _GeocodeOutcome {
  const _GeocodeFailed(this.failure);
  final Failure failure;
}
