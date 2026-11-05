import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/entities/room_snapshot.dart';
import '../../../domain/ports/event_source.dart';

class EventsProxyDataSource implements EventSource {
  EventsProxyDataSource({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl.replaceAll(RegExp(r'/$'), '');

  final http.Client _client;
  final String _baseUrl;

  @override
  Future<Result<List<RoomEventSnapshot>>> searchEvents({
    String? category,
    int limit = 10,
  }) async {
    if (_baseUrl.isEmpty) {
      return const Err(UnknownFailure(FailureCodes.eventSourceUnavailable));
    }
    final uri = Uri.parse('$_baseUrl/events/search').replace(
      queryParameters: {
        'limit': '$limit',
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        return const Err(NetworkFailure(FailureCodes.eventSourceUnavailable));
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = (decoded['events'] as List<dynamic>? ?? const []);
      final events = <RoomEventSnapshot>[];
      for (final item in raw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final id = (map['id'] ?? '').toString();
        final title = (map['title'] ?? '').toString();
        if (id.isEmpty || title.isEmpty) continue;
        events.add(
          RoomEventSnapshot(
            id: id,
            title: title,
            startsAt: DateTime.tryParse((map['startsAt'] ?? '').toString()),
            venueName: map['venueName']?.toString(),
            address: map['address']?.toString(),
            lat: (map['lat'] as num?)?.toDouble(),
            lon: (map['lon'] as num?)?.toDouble(),
            imageUrl: map['imageUrl']?.toString(),
            sourceUrl: map['url']?.toString(),
            price: map['price']?.toString(),
            category: map['category']?.toString(),
            source: map['source']?.toString(),
          ),
        );
      }
      return Ok(events);
    } catch (e) {
      AppLogger.w('Events proxy request failed: $e');
      return const Err(NetworkFailure(FailureCodes.eventSourceUnavailable));
    }
  }
}
