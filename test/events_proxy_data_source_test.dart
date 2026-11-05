import 'dart:convert';

import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/remote/events_proxy_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('parses proxy events and sends category query', () async {
    Uri? captured;
    final client = MockClient((request) async {
      captured = request.url;
      return http.Response(
        jsonEncode({
          'source': 'ticketpro',
          'events': [
            {
              'id': 'https://ticketpro.by/ru/event/zoloto',
              'title': 'Zoloto',
              'venueName': 'Дворец спорта',
              'lat': 53.912589,
              'lon': 27.548675,
              'url': 'https://ticketpro.by/ru/event/zoloto',
              'category': 'Концерты',
            },
            {'id': '', 'title': 'skipped'},
          ],
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final source = EventsProxyDataSource(
      client: client,
      baseUrl: 'https://proxy.example/',
    );

    final result = await source.searchEvents(category: 'concerts', limit: 5);

    expect(captured?.path, '/events/search');
    expect(captured?.queryParameters['category'], 'concerts');
    expect(captured?.queryParameters['limit'], '5');
    final events = (result as Ok).value;
    expect(events, hasLength(1));
    expect(events.single.title, 'Zoloto');
    expect(events.single.lat, 53.912589);
    expect(events.single.sourceUrl, 'https://ticketpro.by/ru/event/zoloto');
  });

  test('returns failure when proxy is unavailable', () async {
    final client = MockClient((_) async => http.Response('down', 502));
    final source = EventsProxyDataSource(
      client: client,
      baseUrl: 'https://proxy.example',
    );

    final result = await source.searchEvents();
    expect(result, isA<Err<List<dynamic>>>());
  });

  test('empty base url fails fast without network', () async {
    final source = EventsProxyDataSource(
      client: MockClient((_) async => http.Response('', 500)),
      baseUrl: '',
    );
    final result = await source.searchEvents();
    expect(result, isA<Err<List<dynamic>>>());
  });
}
