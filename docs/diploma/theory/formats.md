# Форматы встреч и кастомные форматы

## 1. Проблема и границы
Сейчас 4 формата (`food`, `culture`, `walk_only`, `active`) и статический
`FormatChipConfig`. Нужно больше форматов и возможность пользователю создать
свой (название + набор типов/chip'ов), с отдельным блоком в UI. В раздел входят:
реестр форматов, чипы, кастомные форматы, валидация, шаринг в комнате. Не входят:
произвольный Overpass QL от пользователя, маркетплейс форматов, ML-рекомендации.

## 2. Теория (с источниками)
- Расширяемость: enum + switch плохо масштабируется; реестр/стратегии
  поддерживают Open/Closed Principle.
- Config-as-data: формат — это данные (id, label, icon, chips), а не код;
  UI и фильтрация читают один источник.
- Схема и валидация: id, label, список chip'ов; селекторы — из allowlist
  (amenity/tourism/leisure/sport), иначе риск инъекций и дорогих запросов.
- Совместимость: wire values и legacy-значения; миграция enum → registry.
- UX создания: предсказуемые поля, предпросмотр, ограничения, понятные ошибки.
- Рекомендации: кастомный формат влияет на ранжирование (bonus), но не ломает
  качество/дедуп.

Источники (проверить и дополнить):
- OSM Wiki. Map features (amenity/tourism/leisure/sport). URL: https://wiki.openstreetmap.org/wiki/Map_features
- Overpass API. URL: https://wiki.openstreetmap.org/wiki/Overpass_API
- Martin, R. C. Clean Architecture (OCP/SRP) — указать издание.
- Flutter. Internationalization (ARB). URL: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

## 3. Решение в проекте
- Ввести `MeetingFormatDef` и `FormatRegistry`:
  `{id, labelKey|label, icon, chips[], builtIn}`.
- Встроенные форматы: текущие 4 + 2–3 новых (например, `nightlife`, `outdoor`,
  `games`) — решить по данным OSM.
- Кастомный формат: `users/{uid}/customFormats/{id}`; при использовании в
  комнате — снимок в `rooms/{id}/customFormats/{id}` (воспроизводимость).
- UI: блоки «Базовые», «Мои», «В комнате»; редактор: название, иконка, chip'ы.
- Валидация: id уникален, label 1..40, chips 1..8, селекторы из allowlist,
  запрет пустых/дублирующихся.
- Фильтрация: `PlaceDiscoveryPipeline` читает chips из реестра/снимка.
- Совместимость: старые wire values маппятся в defs; `MeetingFormat` остаётся
  для legacy, новый код — по id.

Альтернативы: оставить enum (не расширяемо), хранить только строки без схемы
(небезопасно), дать полный Overpass QL (риск).

## 4. Реализация
- `domain/entities/meeting_format_def.dart`, `config/format_registry.dart`.
- `data/datasources/remote/custom_format_remote_data_source.dart`.
- `presentation/widgets/room_control/custom_format_editor.dart`.
- `presentation/widgets/room_control/place_type_filter_chips.dart` — блоки.
- `firestore.rules` — схема кастомного формата.
- ARB: лейблы встроенных форматов.

## 5. Проверка
- Unit: registry, backward compat, валидация.
- Widget: создание/редактирование, блоки, ошибки.
- Интеграция: кастомный формат фильтрует места у обоих участников.
- Rules: невалидная схема/чужой формат отклоняются.
- Метрика: доля успешных созданий, число мест, ошибки Overpass.

## 6. Ограничения и развитие
- Пользовательские селекторы ограничены allowlist; сложные запросы — вне scope.
- Кастомные форматы могут давать пустую выдачу; нужен понятный empty state.
- Снимок в комнате увеличивает документ; следить за размером.
- В будущем: шаринг, публичная библиотека, ML-подбор формата.
