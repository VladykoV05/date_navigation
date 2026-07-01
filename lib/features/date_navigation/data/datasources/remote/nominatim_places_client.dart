import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../../../config/date_navigation_config.dart';
import '../../../config/format_chip_config.dart';
import '../../../domain/entities/date_vibe.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/services/place_quality_service.dart';

class NominatimPlacesClient {
  const NominatimPlacesClient({
    required http.Client client,
    required PlaceQualityService qualityService,
  }) : _client = client,
       _qualityService = qualityService;

  final http.Client _client;
  final PlaceQualityService _qualityService;

  Future<List<Place>> fetchFallback({
    required double lat,
    required double lon,
    required int radius,
    required MeetingFormat format,
  }) async {
    final bbox = _buildBoundingBox(lat: lat, lon: lon, radius: radius);
    final types = FormatChipConfig.nominatimQueriesFor(format);
    final futures = types.map(
      (type) => _fetchNominatimByType(type: type, bbox: bbox),
    );
    final results = await Future.wait(futures);
    final all = results.expand((items) => items).toList(growable: false);
    final unique = _qualityService.dedupePlaces(all);
    _qualityService.stableSortPlaces(unique);
    return unique;
  }

  Future<List<Place>> _fetchNominatimByType({
    required String type,
    required Map<String, double> bbox,
  }) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=${Uri.encodeComponent(type)}'
      '&format=jsonv2'
      '&limit=${DateNavigationConfig.placesFallbackLimitPerType}'
      '&bounded=1'
      '&viewbox=${bbox['left']},${bbox['top']},${bbox['right']},${bbox['bottom']}',
    );
    final response = await _client
        .get(
          url,
          headers: {
            'User-Agent': DateNavigationConfig.appUserAgent,
            'Accept-Language': 'ru-RU,ru;q=0.9,en;q=0.8',
          },
        )
        .timeout(
          const Duration(seconds: DateNavigationConfig.nominatimTimeoutSeconds),
          onTimeout: () => http.Response('[]', 408),
        );
    if (response.statusCode != 200) return const [];

    final List<dynamic> data = json.decode(response.body);
    final places = <Place>[];
    for (final item in data) {
      final latStr = item['lat']?.toString();
      final lonStr = item['lon']?.toString();
      if (latStr == null || lonStr == null) continue;
      final parsedLat = double.tryParse(latStr);
      final parsedLon = double.tryParse(lonStr);
      if (parsedLat == null || parsedLon == null) continue;

      final displayName = item['display_name']?.toString();
      final fallbackName =
          (item['name'] ?? displayName?.split(',').first.trim() ?? 'Заведение')
              .toString();
      places.add(
        Place(
          name: fallbackName,
          lat: parsedLat,
          lon: parsedLon,
          address: _compactDisplayName(displayName, skipFirst: true),
          type: _normalizeType(type),
        ),
      );
    }
    return places;
  }

  Map<String, double> _buildBoundingBox({
    required double lat,
    required double lon,
    required int radius,
  }) {
    final latDelta = radius / 111000.0;
    final latRad = lat * math.pi / 180.0;
    final cosLat = math.cos(latRad).abs().clamp(0.2, 1.0);
    final lonDelta = radius / (111000.0 * cosLat);
    return {
      'left': lon - lonDelta,
      'right': lon + lonDelta,
      'top': lat + latDelta,
      'bottom': lat - latDelta,
    };
  }

  String? _compactDisplayName(String? displayName, {required bool skipFirst}) {
    final raw = displayName?.trim();
    if (raw == null || raw.isEmpty) return null;

    final parts = raw
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList(growable: false);

    if (parts.length <= 1) return raw;

    final start = skipFirst ? 1 : 0;
    final tail = parts.skip(start).toList();
    if (tail.isEmpty) return raw;

    final take = tail.length >= 2 ? 2 : 1;
    return tail.take(take).join(', ');
  }

  String _normalizeType(String rawType) {
    return switch (rawType) {
      'tennis' ||
      'badminton' ||
      'squash' ||
      'table_tennis' ||
      'padel' => 'active_racket',
      'climbing' || 'bouldering' => 'active_climb',
      'dance' => 'active_dance',
      'football' ||
      'basketball' ||
      'volleyball' ||
      'futsal' ||
      'handball' => 'active_team',
      'yoga' || 'pilates' => 'active_mind_body',
      _ => rawType,
    };
  }
}
