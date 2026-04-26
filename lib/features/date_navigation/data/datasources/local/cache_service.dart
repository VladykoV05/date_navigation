import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/app_logger.dart';
import '../../../config/date_navigation_config.dart';
import '../../../domain/entities/place.dart';

class CacheService {
  static final _instance = CacheService._();
  factory CacheService() => _instance;
  CacheService._();

  static const _geoCacheDuration = Duration(hours: 24);
  static const _routeCacheDuration = Duration(hours: 6);
  static const _placesCacheDuration = Duration(
    hours: DateNavigationConfig.placesCacheHours,
  );

  Future<Map<String, double>?> getCachedCoords(String address) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'geo_$address';
      final cacheTimeKey = 'geo_time_$address';

      final cachedTime = prefs.getInt(cacheTimeKey);
      if (cachedTime != null) {
        final cacheAge = DateTime.now().millisecondsSinceEpoch - cachedTime;
        if (cacheAge < _geoCacheDuration.inMilliseconds) {
          final cached = prefs.getString(cacheKey);
          if (cached != null) {
            AppLogger.i('💾 Кэш геокодинга: $address');
            return Map<String, double>.from(json.decode(cached));
          }
        }
      }
    } catch (e) {
      AppLogger.w('⚠️ Ошибка чтения кэша геокодинга: $e');
    }
    return null;
  }

  Future<void> cacheCoords(String address, Map<String, double> coords) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'geo_$address';
      final cacheTimeKey = 'geo_time_$address';

      await prefs.setString(cacheKey, json.encode(coords));
      await prefs.setInt(cacheTimeKey, DateTime.now().millisecondsSinceEpoch);

      AppLogger.d('💾 Сохранен геокодинг: $address');
    } catch (e) {
      AppLogger.w('⚠️ Ошибка записи кэша геокодинга: $e');
    }
  }

  String makeRouteKey(double lat1, double lon1, double lat2, double lon2) {
    return 'v1_${lat1.toStringAsFixed(4)}_${lon1.toStringAsFixed(4)}_'
        '${lat2.toStringAsFixed(4)}_${lon2.toStringAsFixed(4)}';
  }

  Future<Map<String, double>?> getCachedRoute(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'route_$key';
      final cacheTimeKey = 'route_time_$key';

      final cachedTime = prefs.getInt(cacheTimeKey);
      if (cachedTime != null) {
        final cacheAge = DateTime.now().millisecondsSinceEpoch - cachedTime;
        if (cacheAge < _routeCacheDuration.inMilliseconds) {
          final cached = prefs.getString(cacheKey);
          if (cached != null) {
            AppLogger.i('💾 Кэш маршрута');
            return Map<String, double>.from(json.decode(cached));
          }
        }
      }
    } catch (e) {
      AppLogger.w('⚠️ Ошибка чтения кэша маршрута: $e');
    }
    return null;
  }

  Future<void> cacheRoute(
    String key,
    double durationSeconds,
    double distanceMeters,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'route_$key';
      final cacheTimeKey = 'route_time_$key';

      final data = {'duration': durationSeconds, 'distance': distanceMeters};

      await prefs.setString(cacheKey, json.encode(data));
      await prefs.setInt(cacheTimeKey, DateTime.now().millisecondsSinceEpoch);

      AppLogger.d('💾 Сохранен маршрут');
    } catch (e) {
      AppLogger.w('⚠️ Ошибка записи кэша маршрута: $e');
    }
  }

  String makePlacesKey(double lat, double lon, int radius, {String? format}) {
    final formatPart = (format == null || format.isEmpty) ? 'any' : format;
    return '${DateNavigationConfig.placesCacheVersion}_${lat.toStringAsFixed(3)}_${lon.toStringAsFixed(3)}_'
        '${radius}_$formatPart';
  }

  Future<List<Place>?> getCachedPlaces(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'places_$key';
      final cacheTimeKey = 'places_time_$key';

      final cachedTime = prefs.getInt(cacheTimeKey);
      if (cachedTime == null) return null;

      final cacheAge = DateTime.now().millisecondsSinceEpoch - cachedTime;
      if (cacheAge >= _placesCacheDuration.inMilliseconds) return null;

      final cached = prefs.getString(cacheKey);
      if (cached == null) return null;

      final List<dynamic> decoded = json.decode(cached);
      final places = decoded
          .map(
            (e) => Place(
              name: (e['name'] ?? '').toString(),
              lat: (e['lat'] as num).toDouble(),
              lon: (e['lon'] as num).toDouble(),
              address: e['address']?.toString(),
              type: e['type']?.toString(),
              rating: (e['rating'] as num?)?.toDouble(),
              types: ((e['types'] as List?) ?? const <dynamic>[])
                  .map((value) => value.toString())
                  .toSet(),
            ),
          )
          .toList();
      AppLogger.i('💾 Кэш заведений: ${places.length}');
      return places;
    } catch (e) {
      AppLogger.w('⚠️ Ошибка чтения кэша заведений: $e');
      return null;
    }
  }

  Future<void> cachePlaces(String key, List<Place> places) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'places_$key';
      final cacheTimeKey = 'places_time_$key';

      final payload = places
          .map(
            (p) => {
              'name': p.name,
              'lat': p.lat,
              'lon': p.lon,
              'address': p.address,
              'type': p.type,
              'rating': p.rating,
              'types': p.types.toList(growable: false),
            },
          )
          .toList();

      await prefs.setString(cacheKey, json.encode(payload));
      await prefs.setInt(cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
      AppLogger.d('💾 Сохранены заведения: ${places.length}');
    } catch (e) {
      AppLogger.w('⚠️ Ошибка записи кэша заведений: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      AppLogger.i('🗑 Весь кэш очищен');
    } catch (e) {
      AppLogger.w('⚠️ Ошибка очистки кэша: $e');
    }
  }
}
