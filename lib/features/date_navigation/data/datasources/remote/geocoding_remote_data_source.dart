import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/utils/app_logger.dart';
import '../local/cache_service.dart';
import '../../../config/date_navigation_config.dart';

class GeocodingRemoteDataSource {
  final String _nominatimUrl = 'https://nominatim.openstreetmap.org/search';
  final http.Client _client;
  final CacheService _cache;

  final Map<String, String> _headers = {
    'User-Agent': DateNavigationConfig.appUserAgent,
    'Accept-Language': 'ru-RU,ru;q=0.9,en;q=0.8',
  };

  GeocodingRemoteDataSource({required http.Client client, CacheService? cache})
    : _client = client,
      _cache = cache ?? CacheService();

  Future<Result<({double lat, double lon})?>> geocodeAddress(
    String address,
  ) async {
    if (address.isEmpty) return const Ok(null);

    final cached = await _cache.getCachedCoords(address);
    if (cached != null) {
      return Ok((lat: cached['lat']!, lon: cached['lon']!));
    }

    try {
      final url = Uri.parse(
        '$_nominatimUrl?q=${Uri.encodeComponent(address)}&format=json&limit=1',
      );
      AppLogger.d('🔍 Геокодинг: $address');

      final response = await _client
          .get(url, headers: _headers)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              AppLogger.w('⏰ Таймаут запроса геокодинга');
              return http.Response('{"error": "timeout"}', 408);
            },
          );

      if (response.statusCode == 408) {
        return const Err(TimeoutFailure('Таймаут геокодинга'));
      }

      if (response.statusCode == 429) {
        return const Err(
          RateLimitFailure('Слишком много запросов (геокодинг)'),
        );
      }

      if (response.statusCode != 200) {
        AppLogger.e('❌ Ошибка Nominatim: ${response.statusCode}');
        return Err(NetworkFailure('Ошибка геокодинга: ${response.statusCode}'));
      }

      final List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) {
        AppLogger.w('⚠️ Адрес не найден: $address');
        return const Ok(null);
      }

      final firstResult = data[0];
      final lat = double.parse(firstResult['lat']);
      final lon = double.parse(firstResult['lon']);

      await _cache.cacheCoords(address, {'lat': lat, 'lon': lon});
      return Ok((lat: lat, lon: lon));
    } catch (e, stack) {
      AppLogger.e('💥 Исключение при геокодинге', e, stack);
      return const Err(UnknownFailure('Не удалось выполнить геокодинг'));
    }
  }
}
