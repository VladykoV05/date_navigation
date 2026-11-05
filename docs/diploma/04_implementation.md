# Реализация

Карта «что сделано / где / чем подтверждено». Обновляется после каждого блока.

## R1. GPS + глобальный поиск
**Статус:** MVP готов.

Сделано:
- `core/location/location_service.dart` — порт.
- `core/location/geolocator_location_service.dart` — реализация.
- `core/di/app_services_di.dart` — `locationServiceProvider`.
- `application/services/location_submission_service.dart` — permission/location/update.
- `presentation/controllers/date_navigation_controller.dart` — `submitMyLocation`.
- `presentation/widgets/room_control/room_address_section.dart` — кнопка «Моя точка».
- Android/iOS permissions.
- ARB: строки и ошибки геолокации.
- `core/search/search_region.dart` — глобальный/Минск + custom.
- `core/search/search_region_preferences.dart` — сохранение региона.
- `data/datasources/remote/geocoding_remote_data_source.dart` — без жёсткого
  `countrycodes=by`; country/viewbox только для выбранного региона.
- `data/datasources/local/cache_service.dart` — ключ с регионом.
- UI: выбор «Весь мир / Минск».
- Тесты: `location_submission_service_test.dart`, `search_region_test.dart`,
  `geocoding_region_test.dart`, widget-тест кнопки.

Stretch: reverse geocode, accuracy circle, «рядом со мной», custom region UI.

Теория: `theory/geolocation.md`, `theory/global-geocoding.md`.

## R2. Открытые сессии + события + схема v2
**Статус:** in progress: схема v2, data layer, rules и UI открытых сессий готовы.

Сделано:
- `RoomType`, `RoomVisibility`, `RoomParticipantRole`, `RoomParticipant`.
- `RoomEventSnapshot`.
- `RoomSnapshot`: `schemaVersion`, `type`, `visibility`, `capacity`, `hostUid`,
  `participants`, `event`.
- Mapper v1/v2: v1 выводит участников из creator/partner, v2 читает
  participants/event.
- Тесты mapper: v1 derivation, v2 open room + event.
- Data layer: create/join/list open rooms, capacity/expiry transaction.
- Rules v2 + participant docs + 11 emulator tests.
- UI: список открытых сессий, создание с capacity, вход, выбор события TicketPro,
  баннер события в комнате.
- `EventsProxyDataSource` + `EVENTS_PROXY_URL`.

Осталось:
- data layer: create open room, join transaction, participant subcollection.
- discovery/list, rules, indexes, migration.
- UI открытых сессий и событий.

Планируемые изменения:
- `domain/entities/room_snapshot.dart` — `RoomType`, `visibility`, `capacity`, participant, event.
- `domain/entities/event.dart`, `domain/ports/event_source.dart`.
- `data/mappers/room_snapshot_mapper.dart` — v1/v2 adapter.
- `data/datasources/remote/room_session_remote_data_source.dart` — create open, join transaction.
- `data/datasources/remote/room_discovery_remote_data_source.dart` — список открытых.
- `proxy/src/events/ticketpro.ts` — парсер JSON-LD (уже прототип).
- `proxy/src/events/jsonld.ts` — извлечение JSON-LD.
- `firestore.rules`, `firestore.indexes.json`.
- `presentation/pages/open_sessions_page.dart`, `events_page.dart`, `widgets/open_session_card.dart`, `event_card.dart`.
- `scripts/migrate_rooms_v2.js` — идемпотентная миграция.

Теория: `theory/open-sessions.md`, `theory/realtime-sync.md`,
`theory/events.md` (создать).
ADR: `adr/0002-room-schema-v2.md`, `adr/0005-event-source.md`.
Тесты: capacity race, join/leave, rules, mapper v1/v2, JSON-LD, fallback.

## R2.5. Live-геолокация (stretch)
**Статус:** planned, после R2.

Планируемые изменения:
- `rooms/{id}/participants/{uid}.liveLocation` (enabled, expiresAt, point,
  accuracy, updatedAt).
- `core/location/live_location_service.dart` — start/stop/stream/expiry.
- Android foreground service + notification; iOS background mode.
- `presentation/widgets/room_control/live_location_toggle.dart`.
- Live-маркер напарника на карте + «обновлено N сек назад».
- Rules: только свой `liveLocation`, expiry, private-only.
- Авто-стоп и fallback на foreground/снимок.

Теория: `theory/geolocation.md` (дополнить background).
ADR: `adr/0006-live-location.md`.
Тесты: fake location stream, expiry, rules, Android/iOS manual.

## R3. Чат + уведомления
**Статус:** planned.

Планируемые изменения:
- `domain/entities/chat_message.dart`, `domain/repositories/chat_repository.dart`.
- `data/datasources/remote/chat_remote_data_source.dart`.
- `presentation/pages/chat_page.dart`, `widgets/message_bubble.dart`, unread badge.
- `core/notifications/local_notification_service.dart`.
- `users/{uid}/devices` + FCM (stretch).
- Deep link `datenavigation://room/{id}/chat`.

Теория: `theory/chat.md`, `theory/notifications.md`.
Тесты: ordering, dedupe, pagination, unread, rules.

## R4. Форматы + кастомные
**Статус:** planned.

Планируемые изменения:
- `domain/entities/meeting_format.dart` (registry-friendly) + backward compat.
- `config/format_registry.dart` вместо статического enum-only.
- `users/{uid}/customFormats`, `rooms/{id}/customFormats`.
- `presentation/widgets/room_control/custom_format_editor.dart`.
- Валидация чипов/селекторов.

Теория: `theory/formats.md`.
Тесты: registry, custom format, filtering, rules.

## R5. «Куда дальше» + маршрут
**Статус:** planned.

Планируемые изменения:
- `domain/services/next_step_service.dart`.
- `domain/entities/route_plan.dart` (legs, steps, ETA).
- `data/datasources/remote/osrm_remote_data_source.dart` — steps/legs.
- `presentation/pages/route_page.dart`, `widgets/next_step_cards.dart`.
- `selectedScenario` — добавление шага и маршрута.

Теория: `theory/next-step-and-routing.md`.
Тесты: next-step ranking, route parsing, fallback.

## R6. AI-консьерж
**Статус:** planned.

Планируемые изменения:
- `domain/ports/ai_assistant_port.dart`.
- `data/datasources/remote/ai_proxy_data_source.dart`.
- Cloud Function/Worker `aiSuggest` (контекст, rate limit, валидация).
- `presentation/widgets/room_control/ai_concierge_section.dart`.
- Fallback на `DateAssistantService`.

Теория: `theory/ai-concierge.md`.
ADR: `adr/0003-ai-proxy.md`.
Тесты: fallback, schema validation, no-hallucination guard, rate limit.

## R7. UX/motion, качество
**Статус:** planned.
- Токены движения, переходы, skeleton, empty/error states.
- a11y: semantics, contrast, text scale.
- Полный прогон тестов и замеры.
- Текст, диаграммы, скриншоты, демо.

## Текущая база (до R1)
- Приватная комната на 2, invite, голосование, форматы, места, маршрут в data-слое.
- 24 тестовых файла, contract-тесты rules, CI.
- Известные ограничения: `SearchCityBias.minsk`, enum форматов, роль-зависимые поля.
