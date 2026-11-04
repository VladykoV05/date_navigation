# Геолокация и «моя точка»

## 1. Проблема и границы
Сейчас пользователь вводит адрес текстом. Нужно брать текущую геопозицию
устройства как «мою точку», но сохранить ручной ввод как fallback. В раздел
входят: получение координат, разрешения, точность, отображение, приватность.
Не входят: фоновая геолокация, геозоны, трекинг перемещений.

## 2. Теория (с источниками)
- ГНСС (GPS, GLONASS, Galileo, BeiDou) даёт координаты в WGS-84; на картах
  OSM используется та же система, но tile/проекция — Web Mercator (EPSG:3857).
- Точность и погрешность — разные вещи: `accuracy` в метрах описывает радиус
  ошибки, а не «качество сигнала».
- Разрешения: Android — `ACCESS_FINE_LOCATION`/`ACCESS_COARSE_LOCATION`,
  iOS — `NSLocationWhenInUseUsageDescription`; отказ — штатное состояние.
- Расстояние между точками: haversine для сферы; для малых расстояний ошибка
  приемлема, для строгой геодезии — Vincenty/geodesic.
- Приватность: координаты — персональные данные; не публиковать точные точки
  в открытых списках, не логировать без необходимости.

Источники (проверить и дополнить):
- Android Developers. Location permissions. URL: https://developer.android.com/develop/sensors-and-location/location/permissions
- Apple Developer. Core Location. URL: https://developer.apple.com/documentation/corelocation
- flutter geolocator. URL: https://pub.dev/packages/geolocator
- OSM Wiki. WGS 84 / Web Mercator. URL: https://wiki.openstreetmap.org/wiki/EPSG:3857

## 3. Решение в проекте
- Добавить `LocationService` (порт) + `GeolocatorLocationService` (адаптер).
- Состояния: unknown / denied / deniedForever / granted / error.
- Кнопка «Моя точка» в `RoomAddressSection`; при отказе — ручной ввод.
- Показывать `accuracy` кругом на карте (stretch).
- Не запрашивать фон; не хранить историю перемещений.
- Для открытых сессий точная точка остаётся в participant-документе и не
  отдаётся в список.

Альтернативы: `location` пакет, нативный канал. Выбран geolocator — зрелость,
поддержка permission flow, тестируемость через mock.

## 4. Реализация
Планируемые файлы:
- `lib/core/location/location_service.dart` — контракт.
- `lib/core/location/geolocator_location_service.dart` — реализация.
- `lib/features/date_navigation/presentation/widgets/room_control/room_address_section.dart` — UI.
- `lib/features/date_navigation/domain/usecases/update_location.dart` — уже есть.
- `ios/Runner/Info.plist`, `android/app/src/main/AndroidManifest.xml` — permissions.

## 5. Проверка
- Unit: состояния permission, таймаут, ошибка.
- Widget: кнопка/лейблы/отказ.
- Ручной smoke: allow, deny, denyForever, повторный запрос.
- Метрика: время до первой точки, точность (м).
- Сравнение: GPS vs ручной адрес (расстояние между ними).

## 6. Ограничения и развитие
- В помещении/эмуляторе точность низкая; тесты на mock-координатах.
- Расход батареи при частых запросах; используем одноразовый запрос.
- iOS/Android по-разному ведут себя при отказе; нужен понятный текст.
- В будущем: геозоны, фон, «рядом со мной» для списка.
