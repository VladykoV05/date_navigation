# События и интеграция с TicketPro

## 1. Проблема и границы
Открытая сессия должна уметь собирать компанию не только на «посидеть в кафе»,
но и на конкретное событие: концерт, спектакль, выставка, спортивное шоу.
Нужны название, дата, площадка, адрес, координаты, цена и ссылка. В раздел
входят: каталог событий, импорт по ссылке, нормализация, кэш, fallback.
Не входят: покупка билетов, парсинг всех площадок, афиша как отдельный продукт.

## 2. Теория (с источниками)
- Schema.org `Event` — стандарт структурированных данных: `name`, `startDate`,
  `location`, `offers`, `image`, `url`. `Place` может содержать `geo`.
- JSON-LD — JSON-представление schema.org, которое сайты кладут в
  `<script type="application/ld+json">`; его можно разбирать без парсинга вёрстки.
- Web scraping: даже публичные страницы имеют условия использования; нужно
  уважать `robots.txt`, не обходить защиту, ограничивать частоту, кэшировать.
- Нормализация: разные источники дают разные форматы дат, валют, адресов;
  нужен единый `EventItem`.
- Кэширование снижает нагрузку и ускоряет повторные запросы; TTL выбирается
  по частоте обновления данных.
- Fallback: при изменении вёрстки/JSON-LD или блокировке — ручная карточка.

Источники (проверить и дополнить):
- Schema.org. Event. URL: https://schema.org/Event
- Schema.org. Place. URL: https://schema.org/Place
- TicketPro. Афиша Минска. URL: https://ticketpro.by/ru
- Google Search Central. Structured data. URL: https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data
- OWASP. Authorization Cheat Sheet. URL: https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html

## 3. Решение в проекте
- `EventSource` в domain; `TicketProEventSource` в proxy.
- `GET /events/search?limit=&category=` — список событий с TicketPro.
- `POST /events/import` с `{url}` — импорт одного события по ссылке.
- Парсинг: JSON-LD `Event` -> `EventItem`; JSON-LD `Place.geo` -> lat/lon.
- Кэш 15 минут, задержка 300 мс, User-Agent, таймауты, лимит 10 событий.
- В комнате хранится снимок события; сессия воспроизводима.
- Fallback: ручная карточка события.
- Ticketmaster — второй провайдер на будущее.

Почему не официальный API: Ticketmaster/Eventbrite плохо покрывают Минск;
KudaGo API недоступен/ограничен. TicketPro даёт нужные данные в JSON-LD.

## 4. Реализация
- `proxy/src/events/jsonld.ts` — извлечение JSON-LD.
- `proxy/src/events/ticketpro.ts` — поиск, импорт, кэш, нормализация.
- `proxy/src/events/types.ts` — `EventItem`.
- `proxy/src/index.ts` — `/events/search`, `/events/import`.
- `domain/entities/event.dart`, `domain/ports/event_source.dart`.
- `presentation/pages/events_page.dart`, `widgets/event_card.dart`.
- `rooms/{id}.event` — снимок события.

## 5. Проверка
- `POST /events/import` с реальной ссылкой TicketPro: 200 OK, поля и координаты.
- `GET /events/search?limit=2`: 2 события с lat/lon.
- Тесты: парсинг JSON-LD, отсутствие `Event`, отсутствие `geo`, 429/timeout,
  кэш, fallback.
- Метрики: успех парсинга, наличие координат, latency, конверсия в сессию.

## 6. Ограничения и развитие
- TicketPro — не официальный API; JSON-LD/вёрстка могут измениться.
- Условия использования и атрибуция; для production — соглашение/фид.
- Покрытие других городов/стран не гарантировано.
- Нет покупки билетов и синхронизации с календарём.
- В будущем: Ticketmaster/Eventbrite как провайдеры, фильтры по датам/жанрам,
  кэш на диск, фоновое обновление.
