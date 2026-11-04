# Тестирование и эксперименты

## 1. Стратегия
| Уровень | Что проверяем | Инструмент |
|---|---|---|
| Unit | Политики, редьюсеры, мапперы, ранжирование | `flutter_test` |
| Application | Сценарии с fake-репозиториями | `flutter_test` |
| Data | HTTP/Firestore-мапперы, кэш, деградация | mock-клиенты |
| Rules | Доступ, поля, capacity, чат | contract + emulator (`@firebase/rules-unit-testing`) |
| Widget | Состояния экранов, чат, форматы | `flutter_test` |
| Manual/E2E | 2–3 устройства, realtime, permissions | чек-лист |

## 2. Матрица (заполняется)
| Требование | Тест | Файл | Статус |
|---|---|---|---|
| FR-1.1–1.3 | permission/current location | TODO | planned |
| FR-1.4–1.7 | global geocoding/cache | `geocoding_region_test.dart`, `search_region_test.dart` | done |
| FR-2.1–2.8 | room v2/join/capacity | `test/room_remote_data_source_test.dart` + новые | planned |
| FR-3.1–3.8 | chat/order/dedupe/unread | TODO | planned |
| FR-4.1–4.7 | formats/custom/validation | TODO | planned |
| FR-5.1–5.7 | next step/route/fallback | `test/meeting_repository_degraded_routing_test.dart` + новые | planned |
| FR-6.1–6.7 | AI fallback/validation/rate | TODO | planned |
| FR-7.1–7.8 | TicketPro JSON-LD/import/fallback | `proxy` tests + новые | прототип проверен |
| FR-8.1–8.9 | live location/expiry/rules | TODO | planned |

## 3. Rules-тесты (минимум)
- join в открытую комнату при наличии места — allow.
- join при capacity — deny.
- запись чужого participant-документа — deny.
- чтение сообщений не-участником — deny.
- create message с чужим `senderUid` — deny.
- update/delete сообщения — deny.
- create кастомного формата с невалидной схемой — deny.
- приватная комната: старый invite-сценарий — allow.

## 4. Эксперименты
### E1. Геокодинг вне Минска
- Гипотеза: без `countrycodes=by` top-1/top-3 не хуже на наборе адресов.
- Условия: 20 адресов (BY, PL, LT, DE), нормальная сеть, кэш выключен.
- Метрики: top-1, top-3, latency p50/p95, ошибки.
- Результат: TODO.

### E2. Join и capacity
- Гипотеза: транзакция не пропускает лишнего участника.
- Условия: 10 параллельных join при capacity=3.
- Метрики: успешные/отклонённые, консистентность count.
- Результат: TODO.

### E3. Чат
- Гипотеза: сообщения не теряются и не дублируются при ретрае/offline.
- Условия: 100 сообщений, отключение сети на 5 с, повтор отправки.
- Метрики: доставлено, дубликаты, порядок, unread.
- Результат: TODO.

### E4. Next step
- Гипотеза: 3 предложения релевантны и разнообразны.
- Условия: 10 сценариев, экспертная оценка 1–5.
- Метрики: relevance, diversity, distance/ETA.
- Результат: TODO.

### E5. AI
- Гипотеза: консьерж не выдумывает места и укладывается в лимит.
- Условия: 15 запросов, фиксированный контекст, 3 модели/промпта.
- Метрики: relevance, diversity, latency, cost, fallback rate, invalid JSON.
- Результат: TODO.

### E6. TicketPro JSON-LD
- Гипотеза: карточка события и координаты площадки извлекаются без ручного ввода.
- Условия: 10 ссылок TicketPro (концерты/театр/спорт), кэш выключен.
- Метрики: успех парсинга, наличие lat/lon, latency, ошибки.
- Результат: прототип на 1 ссылке — 200 OK, координаты есть; расширить до 10.

### E7. Live-геолокация
- Гипотеза: при свёрнутом приложении партнёр видит обновления в течение часа.
- Условия: Android/iOS, foreground/background, 30–60 с, экран партнёра открыт.
- Метрики: число обновлений, задержка, расход батареи, авто-стоп, ошибки.
- Результат: TODO.

## 4a. GPS: как тестировать
### Автоматически
- `test/location_submission_service_test.dart` — permission granted/denied/
  deniedForever/serviceDisabled, timeout, ошибка обновления.
- `test/room_control_panel_test.dart` — кнопка «Моя точка» и callback.

### Android emulator
1. Extended Controls → Location → задать lat/lon → Set Location.
2. App Info → Permissions → Location: allow / deny / deny forever.
3. Отключить Location в шторке → проверить ошибку.
4. Проверить, что после allow точка появляется в Firestore и на карте.

### iOS Simulator
1. Features → Location → Custom Location → lat/lon.
2. Settings → Privacy & Security → Location Services → Siri/приложение:
   allow / deny.
3. Reset location permissions:
   `xcrun simctl privacy booted reset location <bundle-id>`.

### Реальное устройство
- На улице: точность, время до первой точки.
- Deny → ручной адрес всё ещё работает.
- Deny forever → понятное сообщение и путь в настройки.
- Выключенная геолокация → ошибка, не пустой экран.
- Сверху наложение: точка не «прыгает» при повторном запросе.

### Матрица
| Сценарий | Ожидание |
|---|---|
| granted + service on | точка сохранена |
| denied | ошибка, ручной ввод доступен |
| deniedForever | ошибка + настройки |
| serviceDisabled | ошибка |
| timeout | ошибка, повтор возможен |
| нет комнаты | no-op |
| успех | point обновлён, маркер на карте |

## 5. Ручной smoke (2–3 устройства)
1. GPS/разрешения: allow, deny, повторный запрос.
2. Приватная комната: create → invite → join → roomFull.
3. Открытая: create → list → join → capacity → leave.
4. Чат: send, receive, unread, offline/retry, deep link.
5. Форматы: встроенный, кастомный, смена, фильтрация.
6. Место: выбор, «куда дальше», маршрут, внешняя навигация.
7. AI: успех, таймаут, fallback.
8. Локаль/тема/text scale.

## 6. Деградация
- Nominatim 429/timeout → кэш/сообщение, не пустой экран.
- Overpass пусто → расширение радиуса/понятный empty state.
- OSRM недоступен → haversine/прямая линия + deeplink.
- AI недоступен → детерминированные сценарии.
- Firestore offline → локальный кэш, очередь, статус «отправляется».

## 7. Артефакты
- Логи замеров в `docs/diploma/log/`.
- Скриншоты в `docs/diploma/assets/` (создать при первом замере).
- Сводная таблица результатов в конце раздела.
