# Traceability matrix

Правило: каждая строка имеет код, тест и раздел текста. Если чего-то нет —
статус `planned` и причина. Обновлять после каждого блока.

| ID | Требование | Блок | Код | Тест | Раздел | Статус |
|---|---|---|---|---|---|---|
| FR-1.1 | Текущая геопозиция | R1 | `core/location/*` | `room_control_panel_test.dart` | `theory/geolocation.md` | частично |
| FR-1.2 | «Моя точка» из GPS | R1 | `date_navigation_controller.dart` | `room_control_panel_test.dart` | `04_implementation.md#r1` | частично |
| FR-1.3 | Fallback на ручной ввод | R1 | `room_address_section.dart` | `room_control_panel_test.dart` | `theory/geolocation.md` | частично |
| FR-1.4 | Глобальный геокодинг | R1 | `geocoding_remote_data_source.dart` | `geocoding_region_test.dart` | `theory/global-geocoding.md` | done |
| FR-1.5 | Выбор региона | R1 | `search_region.dart`, `search_region_preferences.dart` | `search_region_test.dart` | `theory/global-geocoding.md` | done |
| FR-1.6 | Ошибки геокодинга | R1 | `failure_codes.dart` | `failure_retry_policy_test.dart` | `theory/global-geocoding.md` | частично |
| FR-1.7 | Кэш с локалью/регионом | R1 | `cache_service.dart` | `geocoding_region_test.dart` | `theory/global-geocoding.md` | done |
| FR-2.1 | Private/open room | R2 | `room_session_remote_data_source.dart` | `room_snapshot_mapper_test.dart` | `theory/open-sessions.md` | done |
| FR-2.2 | Метаданные open room | R2 | TODO | TODO | `adr/0002-room-schema-v2.md` | planned |
| FR-2.3 | Список открытых | R2 | `room_session_remote_data_source.dart`, `open_sessions_page.dart` | `open_sessions_page_test.dart` | `theory/open-sessions.md` | done |
| FR-2.4 | Join open | R2 | `room_session_remote_data_source.dart` | rules emulator | `theory/open-sessions.md` | done |
| FR-2.5 | Capacity race | R2 | `joinOpenRoom` transaction | rules emulator | `theory/open-sessions.md` | done |
| FR-2.6 | Private invite/roomFull | R2 | `room_session_remote_data_source.dart:204` | `room_remote_data_source_test.dart` | `theory/realtime-sync.md` | planned |
| FR-2.7 | End/leave | R2 | `complete_session.dart` | `session_lifecycle_test.dart` | `theory/open-sessions.md` | planned |
| FR-2.8 | Приватность точек | R2 | TODO rules/mapper | TODO | `theory/open-sessions.md` | planned |
| FR-3.1 | Чат в обеих комнатах | R3 | TODO `chat_remote_data_source.dart` | TODO | `theory/chat.md` | planned |
| FR-3.2 | Realtime + история | R3 | TODO | TODO | `theory/chat.md` | planned |
| FR-3.3 | Пагинация | R3 | TODO | TODO | `theory/chat.md` | planned |
| FR-3.4 | Optimistic + dedupe | R3 | TODO `clientId` | TODO | `theory/chat.md` | planned |
| FR-3.5 | Системные сообщения | R3 | TODO | TODO | `theory/chat.md` | planned |
| FR-3.6 | Unread + local | R3 | TODO `reads`, notifications | TODO | `theory/notifications.md` | planned |
| FR-3.7 | Push (stretch) | R3 | TODO FCM | TODO | `theory/notifications.md` | planned |
| FR-3.8 | Deep link | R3 | `core/deep_links/*` | `invite_link_test.dart` | `theory/notifications.md` | planned |
| FR-4.1 | Больше форматов | R4 | `date_vibe.dart`, registry | TODO | `theory/formats.md` | planned |
| FR-4.2 | Chip'ы внутри формата | R4 | `format_chip_config.dart` | TODO | `theory/formats.md` | planned |
| FR-4.3 | Создание кастомного | R4 | TODO | TODO | `theory/formats.md` | planned |
| FR-4.4 | Личная библиотека | R4 | TODO `users/{uid}/customFormats` | TODO | `theory/formats.md` | planned |
| FR-4.5 | Отдельный блок UI | R4 | TODO | TODO | `theory/formats.md` | planned |
| FR-4.6 | Фильтрация | R4 | `place_discovery_pipeline.dart` | TODO | `theory/formats.md` | planned |
| FR-4.7 | Валидация селекторов | R4 | TODO | TODO | `theory/formats.md` | planned |
| FR-5.1 | Next step | R5 | TODO `next_step_service.dart` | TODO | `theory/next-step-and-routing.md` | planned |
| FR-5.2 | Ranking | R5 | TODO | TODO | `theory/next-step-and-routing.md` | planned |
| FR-5.3 | Добавить шаг | R5 | TODO `selectedScenario` | TODO | `theory/next-step-and-routing.md` | planned |
| FR-5.4 | Маршрут в приложении | R5 | `osrm_remote_data_source.dart` | TODO | `theory/next-step-and-routing.md` | planned |
| FR-5.5 | Маршрут на каждого | R5 | TODO `route_plan.dart` | TODO | `theory/next-step-and-routing.md` | planned |
| FR-5.6 | Деградация OSRM | R5 | `meeting_repository_impl.dart` | `meeting_repository_degraded_routing_test.dart` | `theory/next-step-and-routing.md` | planned |
| FR-5.7 | Внешняя навигация | R5 | TODO | TODO | `theory/next-step-and-routing.md` | planned |
| FR-6.1 | Консьерж в комнате | R6 | TODO | TODO | `theory/ai-concierge.md` | planned |
| FR-6.2 | 3 варианта | R6 | TODO | TODO | `theory/ai-concierge.md` | planned |
| FR-6.3 | Объяснение | R6 | TODO | TODO | `theory/ai-concierge.md` | planned |
| FR-6.4 | Только из выдачи | R6 | TODO validation | TODO | `theory/ai-concierge.md` | planned |
| FR-6.5 | Fallback | R6 | `date_assistant_service.dart` | TODO | `theory/ai-concierge.md` | planned |
| FR-6.6 | Ключ на сервере | R6 | TODO proxy | TODO | `adr/0003-ai-proxy.md` | planned |
| FR-6.7 | Rate limit | R6 | TODO proxy | TODO | `theory/ai-concierge.md` | planned |
| FR-7.1 | Поиск событий TicketPro | R2 | `proxy/src/events/ticketpro.ts`, `events_proxy_data_source.dart` | `events_proxy_data_source_test.dart` | `theory/events.md` | done |
| FR-7.2 | Импорт по ссылке | R2 | `proxy/src/events/ticketpro.ts` | `proxy` tests | `theory/events.md` | прототип |
| FR-7.3 | Карточка события | R2 | `open_sessions_page.dart`, `room_control_panel.dart` | `open_sessions_page_test.dart` | `theory/events.md` | done |
| FR-7.4 | Координаты площадки | R2 | `parseVenuePage` | `proxy` tests | `theory/events.md` | прототип |
| FR-7.5 | Сессия из события | R2 | `createOpenRoom(event:)` | `room_snapshot_mapper_test.dart` | `theory/events.md` | done |
| FR-7.6 | Ручной fallback | R2 | TODO | TODO | `theory/events.md` | planned |
| FR-7.7 | Атрибуция TicketPro | R2 | TODO | TODO | `theory/events.md` | planned |
| FR-7.8 | Кэш/rate limit | R2 | `proxy/src/events/ticketpro.ts` | TODO | `theory/events.md` | прототип |
| NFR-1 | Производительность | R7 | — | замеры | `05_testing.md` | planned |
| NFR-3 | Безопасность | R2/R3 | `firestore.rules` | rules tests | `03_design.md#5` | planned |
| NFR-8 | Сопровождаемость | R7 | слои/ADR | architecture tests | `03_design.md` | planned |
