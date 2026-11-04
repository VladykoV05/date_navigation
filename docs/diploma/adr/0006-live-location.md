# ADR-0006: Live-геолокация для приватной комнаты

**Статус:** Proposed (stretch после R2)
**Дата:** 2026-11-04

## Контекст
Пользователь хочет делиться текущей геопозицией с напарником в течение часа,
даже если его приложение свёрнуто. У напарника приложение открыто, поэтому он
видит live-маркер на карте. Это не то же самое, что точка для планирования:
снимок `point` используется для центра и маршрута, а live-точка показывает,
где человек находится сейчас.

## Варианты
### A. Только foreground live
- Плюс: без background permissions, проще, безопаснее.
- Минус: если приложение свернуть, обновления прекращаются.

### B. Background live (выбран как stretch)
- Плюс: работает при свёрнутом приложении, закрывает запрос пользователя.
- Минус: foreground service/уведомление на Android, background mode на iOS,
  батарея, политика магазинов, сложность тестов.

### C. Только снимок
- Плюс: самый простой и приватный.
- Минус: не показывает «где сейчас».

## Решение
B — background live, но как **stretch после R2**, когда схема комнаты v2 и
participant-подколлекция готовы. Fallback: A (foreground live) или C (снимок),
если платформенные ограничения/сроки не позволяют.

Правила:
1. `point` (снимок для планирования) и `liveLocation` (текущая позиция) —
   разные поля и разные маркеры.
2. Live-точка **не** пересчитывает центр встречи автоматически; только по
   кнопке пользователя.
3. Sharing включается явно, на 60 минут, с таймером и кнопкой «Остановить».
4. Авто-стоп: истечение часа, выбор финального места, выход из комнаты.
5. История не хранится: только последняя точка.
6. Только приватные комнаты. В открытых сессиях live-точка запрещена.

## Данные
```text
rooms/{id}/participants/{uid}
  point: GeoPoint
  liveLocation: {
    enabled: bool
    startedAt: Timestamp
    expiresAt: Timestamp
    updatedAt: Timestamp
    point: GeoPoint
    accuracyMeters: number
  }
```

## Платформы
- Android: `ACCESS_BACKGROUND_LOCATION`, foreground service с постоянным
  уведомлением, `FOREGROUND_SERVICE_LOCATION`, `POST_NOTIFICATIONS`.
- iOS: `NSLocationAlwaysAndWhenInUseUsageDescription`,
  `UIBackgroundModes: location`, `allowsBackgroundLocationUpdates`,
  `showsBackgroundLocationIndicator`.
- Flutter: `geolocator` с background-настройками; при проблемах —
  `flutter_background_geolocation` (платный) как резерв.
- Частота: 30–60 секунд или 50 м, accuracy medium/low.

## Безопасность и приватность
- Только участники комнаты; rules разрешают писать только свой `liveLocation`.
- `expiresAt` проверяется; просроченное не считается активным.
- Видимый индикатор sharing, кнопка стоп, авто-стоп.
- Нет истории, нет фонового трекинга после стопа.
- В открытых сессиях — запрещено.

## Последствия
- +1.5–2 недели после R2 (stretch).
- Новые permissions, foreground service, тесты на Android/iOS.
- Риск App Store/Play и батареи; документируется.
- Если не успеваем — fallback A/C, core не блокируется.

## Проверка
- Android emulator: sharing, свернуть приложение, партнёр видит обновления.
- iOS Simulator: то же с Custom Location.
- Реальное устройство: батарея, permission denied, авто-стоп.
- Rules: чужой `liveLocation` писать нельзя; после `expiresAt` — не активно.
- UI: два маркера (план и live), «обновлено N сек назад», стоп.
