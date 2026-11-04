# How To Add New Meeting Format Safely

Use this checklist whenever you add or modify a `MeetingFormat`.

## 1) Domain Model

- Update `MeetingFormat` enum in `domain/entities/date_vibe.dart`.
- Add `wireValue` mapping.
- Add backward-compat mappings in `fromWireValue(...)` when needed.

## 2) Single Source of Truth (Format Config)

- Update `config/format_chip_config.dart`:
  - chips/options (`id`, `placeType`, Overpass/Nominatim queries, bonus),
  - do **not** hardcode UI labels here — labels come from ARB via `chipLabelFor` / `meetingFormatLabel`.
- Add format label keys to `lib/l10n/app_en.arb` and `app_ru.arb`.
- Update scenario copy in `ScenarioCopyCatalog` / ARB scenario keys.

Do not duplicate chip/query/type logic in widgets or data sources.

## 3) Data Layer

- Verify `Place` type inference supports all new categories (`domain/entities/place.dart`).
- Ensure discovery pipeline remains strict by default (`PlaceDiscoveryMode.strictOnly`).
- If soft fallback is required, enable only via config flag.
- Validate that dedupe and blocked-place filters still behave correctly.

## 4) Presentation Layer

- Ensure new format appears in format chips and labels automatically via config.
- Verify empty-state copy remains consistent and non-alarming.
- Confirm map legend and place list still use dynamic visibility rules.

## 5) Sync & Persistence

- Verify room sync for `creatorMeetingFormat` / `partnerMeetingFormat`.
- Keep Firestore rules compatible with new wire value.
- Check snapshot/cache keys still include format where required.

## 6) Scenarios & Analytics

- Update scenario generation for the new format.
- Ensure analytics events include the new format wire value.

## 7) Tests (Required)

- Add/adjust tests for:
  - strict filtering by format,
  - dedupe behavior for close duplicates,
  - sync suggestion behavior with timestamps,
  - scenario generation for new format.

## 8) Release Checklist

- Run: `dart format`, `flutter analyze`, `flutter test`.
- Smoke test with two devices:
  - agree format,
  - change format,
  - apply peer suggestion,
  - select/confirm venue.
