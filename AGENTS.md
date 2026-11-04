# AGENTS.md — date_navigation

## Commands
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter test
flutter run
```
A task is not done until `flutter analyze` and `flutter test` pass.

Backend proxy:
```bash
cd proxy
npm install
npm run typecheck
npm run build
npm start
```
`functions/` is a reserve path (Cloud Functions), not the main backend.
TicketPro integration lives in `proxy/src/events/` and must keep cache, rate
limits, User-Agent, attribution and manual fallback.

## Architecture
- Feature-first: `presentation -> application -> domain <- data`.
- Business rules live in policies/flows/services/transitions, not controllers.
- Controllers orchestrate; they do not own feature rules.
- Read `docs/date_navigation_architecture.md` before moving logic between layers.

## Non-negotiables
1. Room v1 is a 2-person, role-scoped model (`creatorUid`/`partnerUid`, `point1`/`point2`). Do not add multi-user features before room schema v2 (`docs/diploma/adr/0002-room-schema-v2.md`).
2. Any Firestore schema/rules change requires: updated `firestore.rules`, indexes if needed, and a contract/emulator test.
3. Keep wire values backward compatible (`MeetingFormat.fromWireValue`, legacy room fields).
4. Public OSM services (Nominatim/Overpass/OSRM) are best-effort: cache, User-Agent, rate limits, degraded path.
5. No secrets in the repo. Use `--dart-define`; LLM/FCM keys stay server-side.
6. Do not duplicate format chip/query logic in widgets; use the format registry/config.

## Feature workflow
1. Read `docs/diploma/README.md`, `00_topic.md`, relevant ADR.
2. Implement domain -> data -> application -> presentation.
3. Add tests: unit for rules, widget for UI states, rules test for Firestore.
4. Update `docs/diploma/04_implementation.md`, the matching `theory/*.md`, and `traceability.md`.
5. Run format, analyze, test.

## Scope (diploma)
- R1 GPS + global search
- R2 Open sessions + TicketPro events + room schema v2
- R3 Chat + notifications
- R4 Formats + custom formats
- R5 Next step after venue + in-app route
- R6 AI concierge
- R7 UX/motion, tests, measurements, thesis, demo

Full plan: `~/.config/opencode/skills/date-navigation-app/references/roadmap.md`.

## UI
- Every async screen has loading, empty, error, success states.
- User-facing strings go to `lib/l10n/app_en.arb` and `app_ru.arb`.
- Respect text scaling, contrast, and semantics.
