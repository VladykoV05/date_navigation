import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../config/date_navigation_config.dart';
import '../../../domain/entities/room_snapshot.dart';
import '../../../domain/ports/event_source.dart';

/// События TicketPro без прокси: разбор публичных страниц ticketpro.by (JSON-LD),
/// кеш в памяти и задержка между запросами — как в прокси (proxy/src/events/ticketpro.ts).
class TicketProEventsDataSource implements EventSource {
  TicketProEventsDataSource({
    required http.Client client,
    this.baseUrl = 'https://ticketpro.by',
    this.fetchDelay = const Duration(milliseconds: 300),
    this.cacheTtl = const Duration(minutes: 15),
    this.timeout = const Duration(seconds: 10),
  }) : _client = client;

  final http.Client _client;
  final String baseUrl;
  final Duration fetchDelay;
  final Duration cacheTtl;
  final Duration timeout;

  final Map<String, _CacheEntry<Object>> _cache = {};

  static const Map<String, String> _categorySlugs = {
    'concerts': 'bilety-na-koncert',
    'theatre': 'bilety-v-teatr',
    'sport': 'bilety-na-sportivnye-meropriyatiya',
  };

  static const Map<String, String> _categoryLabels = {
    'concerts': 'Концерты',
    'theatre': 'Театр',
    'sport': 'Спорт',
  };

  @override
  Future<Result<List<RoomEventSnapshot>>> searchEvents({
    String? category,
    int limit = 10,
  }) async {
    final normalized = category?.trim().toLowerCase();
    final cacheKey = 'list:${normalized ?? 'home'}:$limit';
    final cached = _cacheGet<List<RoomEventSnapshot>>(cacheKey);
    if (cached != null) return Ok(cached);

    final slug = normalized == null ? null : _categorySlugs[normalized];
    final label = normalized == null ? null : _categoryLabels[normalized];
    try {
      String html;
      try {
        html = await _fetch(slug != null ? '$baseUrl/ru/$slug' : '$baseUrl/ru');
      } catch (_) {
        html = await _fetch('$baseUrl/ru');
      }
      final links = extractEventLinks(html, baseUrl).take(limit);
      final events = <RoomEventSnapshot>[];
      for (final link in links) {
        try {
          final event = await _loadEvent(link);
          if (event != null) {
            events.add(
              event.category == null && label != null
                  ? _withCategory(event, label)
                  : event,
            );
          }
        } catch (_) {
          continue;
        }
        await Future<void>.delayed(fetchDelay);
      }
      _cachePut(cacheKey, events);
      return Ok(events);
    } catch (e) {
      AppLogger.w('TicketPro events failed: $e');
      return const Err(NetworkFailure(FailureCodes.eventSourceUnavailable));
    }
  }

  Future<RoomEventSnapshot?> _loadEvent(String url) async {
    final cached = _cacheGet<RoomEventSnapshot>(url);
    if (cached != null) return cached;

    final html = await _fetch(url);
    final parsed = parseEventPage(html, url);
    if (parsed == null) return null;

    var event = parsed.event;
    final venueUrl = parsed.venueUrl;
    if (venueUrl != null && isTicketProUrl(venueUrl)) {
      try {
        final geo = parseVenueGeo(await _fetch(venueUrl));
        event = _withGeo(event, geo.lat, geo.lon);
      } catch (_) {
        // Координаты площадки не обязательны: событие остаётся без них.
      }
    }
    _cachePut(url, event);
    return event;
  }

  Future<String> _fetch(String url) async {
    final response = await _client
        .get(
          Uri.parse(url),
          headers: {
            'user-agent': DateNavigationConfig.appUserAgent,
            'accept-language': 'ru,en;q=0.8',
            'accept': 'text/html,application/xhtml+xml',
          },
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      throw StateError('ticketpro_http_${response.statusCode}');
    }
    return utf8.decode(response.bodyBytes);
  }

  T? _cacheGet<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (!entry.expiresAt.isAfter(DateTime.now())) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T;
  }

  void _cachePut(String key, Object value) {
    _cache[key] = _CacheEntry(
      expiresAt: DateTime.now().add(cacheTtl),
      value: value,
    );
  }

  static RoomEventSnapshot _withCategory(
    RoomEventSnapshot e,
    String category,
  ) => _copy(e, category: category);

  static RoomEventSnapshot _withGeo(
    RoomEventSnapshot e,
    double? lat,
    double? lon,
  ) => _copy(e, lat: lat, lon: lon);

  static RoomEventSnapshot _copy(
    RoomEventSnapshot e, {
    String? category,
    double? lat,
    double? lon,
  }) {
    return RoomEventSnapshot(
      id: e.id,
      title: e.title,
      startsAt: e.startsAt,
      venueName: e.venueName,
      address: e.address,
      lat: lat ?? e.lat,
      lon: lon ?? e.lon,
      imageUrl: e.imageUrl,
      sourceUrl: e.sourceUrl,
      price: e.price,
      category: category ?? e.category,
      source: e.source,
    );
  }
}

class _CacheEntry<T> {
  const _CacheEntry({required this.expiresAt, required this.value});

  final DateTime expiresAt;
  final T value;
}

/// Страница события с адресом площадки (для координат), если она есть.
class ParsedEventPage {
  const ParsedEventPage({required this.event, this.venueUrl});

  final RoomEventSnapshot event;
  final String? venueUrl;
}

bool isTicketProUrl(String value) {
  final uri = Uri.tryParse(value);
  if (uri == null) return false;
  return uri.scheme == 'https' &&
      (uri.host == 'ticketpro.by' || uri.host == 'www.ticketpro.by');
}

/// Ссылки на события из HTML списка: `href="/ru/event/..."`.
List<String> extractEventLinks(String html, String baseUrl) {
  final regex = RegExp(r'href="(/ru/event/[^"#?]+)"');
  final links = <String>{};
  for (final match in regex.allMatches(html)) {
    links.add(Uri.parse(baseUrl).resolve(match.group(1)!).toString());
  }
  return links.toList(growable: false);
}

/// JSON-LD узлы страницы (включая `@graph`).
List<Map<String, dynamic>> extractJsonLdNodes(String html) {
  final regex = RegExp(
    r'<script[^>]*type="application/ld\+json"[^>]*>([\s\S]*?)</script>',
    caseSensitive: false,
  );
  final nodes = <Map<String, dynamic>>[];
  for (final match in regex.allMatches(html)) {
    try {
      final parsed = jsonDecode(match.group(1)!.trim());
      final items = parsed is List ? parsed : [parsed];
      for (final item in items) {
        if (item is! Map<String, dynamic>) continue;
        final graph = item['@graph'];
        if (graph is List) {
          nodes.addAll(graph.whereType<Map<String, dynamic>>());
        } else {
          nodes.add(item);
        }
      }
    } catch (_) {
      continue;
    }
  }
  return nodes;
}

Map<String, dynamic>? findNodeByType(
  List<Map<String, dynamic>> nodes,
  String type,
) {
  for (final node in nodes) {
    final t = node['@type'];
    if (t == type || (t is List && t.contains(type))) return node;
  }
  return null;
}

String? _text(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String? _imageUrl(Object? value) {
  if (value is String) return value;
  if (value is List) {
    for (final entry in value) {
      if (entry is String) return entry;
    }
  }
  return null;
}

/// Разбор страницы события (поля как в прокси: name, startDate, location, offers, image).
ParsedEventPage? parseEventPage(String html, String url) {
  final nodes = extractJsonLdNodes(html);
  final event = findNodeByType(nodes, 'Event');
  if (event == null) return null;

  final location = event['location'] is Map<String, dynamic>
      ? event['location'] as Map<String, dynamic>
      : <String, dynamic>{};
  final address = location['address'] is Map<String, dynamic>
      ? location['address'] as Map<String, dynamic>
      : <String, dynamic>{};
  final offers = event['offers'] is Map<String, dynamic>
      ? event['offers'] as Map<String, dynamic>
      : <String, dynamic>{};

  final price = _text(offers['price']?.toString());
  final currency = _text(offers['priceCurrency']);
  final venueUrlRaw = _text(location['url']);
  final title = _text(event['name']) ?? 'Событие';
  final description = _text(event['description']);

  return ParsedEventPage(
    event: RoomEventSnapshot(
      id: url,
      title: title,
      startsAt: DateTime.tryParse(_text(event['startDate']) ?? ''),
      venueName: _text(location['name']),
      address: _text(address['streetAddress']),
      imageUrl: _imageUrl(event['image']),
      sourceUrl: url,
      price: price == null
          ? null
          : (currency == null ? price : '$price $currency'),
      category: inferCategory(title, description),
      source: 'ticketpro',
    ),
    venueUrl: venueUrlRaw == null
        ? null
        : Uri.parse(url).resolve(venueUrlRaw).toString(),
  );
}

/// Координаты площадки из JSON-LD `Place.geo`.
({double? lat, double? lon}) parseVenueGeo(String html) {
  final place = findNodeByType(extractJsonLdNodes(html), 'Place');
  final geo = place?['geo'];
  if (geo is! Map<String, dynamic>) return (lat: null, lon: null);
  final lat = geo['latitude'];
  final lon = geo['longitude'];
  return (
    lat: lat is num && lat.isFinite ? lat.toDouble() : null,
    lon: lon is num && lon.isFinite ? lon.toDouble() : null,
  );
}

/// Категория по ключевым словам (как inferCategory в прокси).
String? inferCategory(String title, String? description) {
  final haystack = '$title ${description ?? ''}'.toLowerCase();
  if (haystack.contains('концерт')) return 'Концерты';
  if (haystack.contains('спектакл') || haystack.contains('театр')) {
    return 'Театр';
  }
  if (haystack.contains('спорт') ||
      haystack.contains('матч') ||
      haystack.contains('кубок')) {
    return 'Спорт';
  }
  if (haystack.contains('выставк')) return 'Выставки';
  if (haystack.contains('фестивал')) return 'Фестивали';
  if (haystack.contains('шоу')) return 'Шоу';
  return null;
}
