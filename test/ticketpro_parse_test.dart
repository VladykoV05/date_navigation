import 'package:date_navigation/features/date_navigation/data/datasources/remote/ticketpro_events_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

const _eventHtml = '''
<html><head>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"Event","name":"Концерт тестовый",
 "description":"Большой концерт","startDate":"2026-11-27T19:00:00",
 "location":{"@type":"Place","name":"Арена","url":"/ru/venue/arena",
   "address":{"streetAddress":"пр. Победителей, 111","addressLocality":"Минск"}},
 "offers":{"price":"40","priceCurrency":"BYN"},
 "image":["https://cdn.example/img.png"]}
</script></head><body>
<a href="/ru/event/first-event">a</a>
<a href="/ru/event/first-event?x=1">dup</a>
<a href="/ru/other">no</a>
</body></html>
''';

const _venueHtml = '''
<script type="application/ld+json">
{"@graph":[{"@type":"Place","geo":{"latitude":53.936,"longitude":27.482}}]}
</script>
''';

void main() {
  test('parses JSON-LD event fields like the proxy did', () {
    final parsed = parseEventPage(_eventHtml, 'https://ticketpro.by/ru/event/first-event');

    expect(parsed, isNotNull);
    final event = parsed!.event;
    expect(event.title, 'Концерт тестовый');
    expect(event.venueName, 'Арена');
    expect(event.address, 'пр. Победителей, 111');
    expect(event.price, '40 BYN');
    expect(event.imageUrl, 'https://cdn.example/img.png');
    expect(event.startsAt, DateTime(2026, 11, 27, 19));
    expect(event.category, 'Концерты');
    expect(event.source, 'ticketpro');
    expect(parsed.venueUrl, 'https://ticketpro.by/ru/venue/arena');
  });

  test('extracts unique event links and skips other pages', () {
    final links = extractEventLinks(_eventHtml, 'https://ticketpro.by');
    expect(links, ['https://ticketpro.by/ru/event/first-event']);
  });

  test('venue coordinates come from Place.geo in @graph', () {
    final geo = parseVenueGeo(_venueHtml);
    expect(geo.lat, closeTo(53.936, 1e-6));
    expect(geo.lon, closeTo(27.482, 1e-6));
  });

  test('page without Event node yields nothing', () {
    expect(parseEventPage('<html></html>', 'https://ticketpro.by/ru/event/x'), isNull);
  });

  test('ticketpro url check accepts only https ticketpro hosts', () {
    expect(isTicketProUrl('https://ticketpro.by/ru/venue/a'), isTrue);
    expect(isTicketProUrl('http://ticketpro.by/ru/venue/a'), isFalse);
    expect(isTicketProUrl('https://evil.example/ticketpro.by'), isFalse);
  });
}
