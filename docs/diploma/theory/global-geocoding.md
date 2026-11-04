# Глобальный геокодинг и поиск в разных странах

## 1. Проблема и границы
Сейчас поиск привязан к Минску: `SearchCityBias.minsk`, `countrycodes=by`,
Photon с bias на Минск. Нужно находить адреса в других странах, не ломая
релевантность для локальных адресов. В раздел входят: forward geocoding,
регион поиска, нормализация, кэш, деградация. Не входят: reverse geocoding
(Stretch), собственный геокодер, новые языки UI.

## 2. Теория (с источниками)
- Геокодинг — преобразование текста в координаты; обратный — координат в адрес.
- Nominatim (OSM) поддерживает `q`, `countrycodes`, `viewbox`, `bounded`,
  `accept-language`; публичный инстанс требует User-Agent и ограничивает
  нагрузку (политика: кэш, не более 1 запроса/с, без bulk).
- `countrycodes` сужает поиск, но делает его неверным для других стран;
  `viewbox`/`bounded` задают область, не отсекая страну жёстко.
- Photon лучше работает с некоторыми экзонимами и не-латинскими названиями;
  его можно использовать как fallback.
- Проблемы: неоднозначные топонимы (одинаковые названия улиц), транслитерация,
  сокращения, ошибки, локальные языки, плотность POI.
- Кэш должен учитывать локаль и регион: один и тот же запрос в разных странах
  может давать разные результаты.

Источники (проверить и дополнить):
- OSM Foundation. Nominatim Usage Policy. URL: https://operations.osmfoundation.org/policies/nominatim/
- Nominatim docs. URL: https://nominatim.org/release-docs/latest/api/Search/
- Photon. URL: https://photon.komoot.io/
- OSM Wiki. Names. URL: https://wiki.openstreetmap.org/wiki/Names

## 3. Решение в проекте
- Заменить `SearchCity` (minsk/other) на `SearchRegion`:
  `{countryCode?, city?, center, radiusKm, label}` + «моя страна/город».
- Убрать `countrycodes=by` по умолчанию; использовать `viewbox` вокруг центра
  региона, `bounded=0`, `accept-language` из локали.
- Если регион не выбран — глобальный поиск без country-фильтра, с приоритетом
  близости к текущей точке.
- Photon — fallback; фильтр по стране только если регион явно задан.
- Кэш: ключ `address + locale + region`; TTL; сброс при смене региона.
- Показывать пользователю, в какой стране/городе найден результат (stretch).

Альтернативы: оставить Минск по умолчанию (просто, но неверно); Google
Geocoding (качество, но ключ/цена); свой Nominatim (контроль, но хостинг).

## 4. Реализация
- `lib/core/search/search_region.dart` — новая модель (вместо `search_city.dart`).
- `lib/features/date_navigation/data/datasources/remote/geocoding_remote_data_source.dart`
  — убрать жёсткий country, добавить viewbox/регион.
- `lib/features/date_navigation/data/datasources/remote/geocoding_query_expander.dart`
  — варианты запроса без привязки к Минску.
- `lib/features/date_navigation/data/datasources/local/cache_service.dart` — ключи.
- UI: выбор региона/страны в `room_address_section.dart` + сохранение.

## 5. Проверка
- Набор 20 адресов: BY, PL, LT, DE; top-1/top-3, latency p50/p95.
- Сравнение с текущим поведением (Минск) на локальных адресах — не хуже.
- Ошибки: 429, timeout, пустой ответ; кэш-хит.
- Ручной smoke: адрес в другом городе/стране без ручной привязки к Минску.

## 6. Ограничения и развитие
- Публичный Nominatim без SLA; возможны 429/timeout.
- Неоднозначные адреса требуют выбора из списка (сейчас limit=1 — ограничение).
- Транслитерация и экзонимы — источник ошибок; нужен набор тестов.
- В будущем: reverse geocode, подсказки (autocomplete), свой инстанс.
