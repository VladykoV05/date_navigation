# Развёртывание и среда

## 1. Локальная среда
- Flutter SDK (Dart 3.10), Xcode/Android Studio.
- Firebase project с Auth + Firestore + Analytics + Crashlytics.
- `flutter pub get`, `flutterfire configure` (если проект пересоздаётся).
- Файлы `google-services.json` / `GoogleService-Info.plist` — локально, не в git.

## 2. Секреты
- Не коммитить: `config/dart_defines.json`, ключи, service account, токены.
- Клиентские конфиги — через `--dart-define`.
- LLM/FCM service account — только на сервере (Functions).
- Проверка перед коммитом: `git status`, поиск по `key|secret|token`.

## 3. CI
- `.github/workflows/ci.yml`: `flutter analyze`, `flutter test`.
- Добавить job для rules emulator (`@firebase/rules-unit-testing`) в R2.
- Кэш pub, фиксированная версия Flutter.
- Для Functions — отдельный job: `npm ci`, `npm test`, `firebase deploy --only functions` (по тегу/вручную).

## 4. Firestore
- `firestore.rules` — деплой через Firebase CLI.
- `firestore.indexes.json` — обновлять при новых запросах.
- Cleanup: `scripts/cleanup-rooms.js` + workflow (уже есть).
- Миграция v1→v2: `scripts/migrate_rooms_v2.js` (создать в R2), dry-run + backup.

## 5. Billing account и Blaze (не используется)
1. Google Cloud Console → Billing → создать платёжный аккаунт, привязать карту.
2. Firebase Console → Project settings → Usage and billing → Modify plan → Blaze
   → выбрать billing account.
3. Billing → Budgets & alerts: бюджет (например, 5–10 $/мес), алерты 50/90/100 %.
   Важно: алерты **не останавливают** траты автоматически; при необходимости
   настроить программный лимит.
4. Разделить проекты: `date-navigation-dev` и `date-navigation-demo/prod`.
5. Проверить бесплатные квоты Functions/Firestore и включить уведомления.
6. Не привязывать billing к личному проекту с другими сервисами.

### Ограничение для Беларуси
Беларуси нет в списке стран/валют Cloud Billing
(`docs.cloud.google.com/billing/docs/resources/currency`). Скорее всего,
создать billing account с белорусским адресом/картой не получится. Варианты:
- billing account университета/организации (если есть);
- внешний прокси (B) + Firebase Spark;
- локальный демо-стенд для AI/push (Ollama + локальный прокси, FCM Admin SDK).
Не использовать карту/адрес другой страны только для обхода ограничений —
это риск нарушения условий Google и санкционных правил.

## 6. Внешний прокси (основной путь)
Сервис: `proxy/` (Node/TypeScript, Fastify).
```bash
cd proxy
npm install
npm run build
cp .env.example .env
npm start
curl http://127.0.0.1:8080/health
curl -X POST http://127.0.0.1:8080/aiSuggest \
  -H 'content-type: application/json' -d '{}'
```
Ожидаемо: `/health` → 200; невалидное тело → 400.

- Эндпоинты: `GET /health`, `POST /aiSuggest`.
- Auth: Firebase ID token, проверка участия в комнате.
- `DEV_SKIP_AUTH=true` и `DEV_SKIP_ROOM_CHECK=true` — только локально; в деплое
  обязательно `false`.
- `LLM_MOCK=true` — локальная проверка без ключа. Проверено: mock возвращает
  3 варианта из выдачи.
- Секреты: `LLM_API_KEY`, `FIREBASE_SERVICE_ACCOUNT_JSON` в env/secret store.
- Хостинг: сервера нет, поэтому основной стенд — локальный Mac + Cloudflare
  Tunnel. Production-like — позже Docker на университетском сервере/VPS.
- Push listener: Admin SDK слушает `rooms/{id}/messages` и отправляет FCM.
- CORS allowlist, rate limit, таймауты, логи без ПДн.

### События TicketPro
- `GET /events/search?limit=5&category=concerts` — каталог событий.
- Приложение ходит в прокси через `--dart-define=EVENTS_PROXY_URL=https://...`.
- `POST /events/import` с `{"url":"https://ticketpro.by/ru/event/..."}`.
- Парсинг schema.org JSON-LD: `Event` + `Place.geo`.
- Кэш 15 минут, задержка 300 мс, User-Agent, таймауты.
- Атрибуция «Данные: TicketPro» + ссылка на событие.
- Это не официальный API; для production нужно соглашение/фид.
- Fallback: ручная карточка события.

### Локальный AI через Ollama
```bash
brew install ollama cloudflared
ollama serve
ollama pull llama3.1:8b
```
Запуск прокси с Ollama:
```bash
LLM_MOCK=false LLM_PROVIDER=ollama OLLAMA_MODEL=llama3.1:8b npm start
```
Туннель для телефонов:
```bash
cloudflared tunnel --url http://localhost:8080
```
URL туннеля передаётся в приложение через `--dart-define` (R6). Mac должен быть
включён на время демо; для страховки — записать видео-демо.

## 7. Cloud Functions (резерв)
```bash
npm i -g firebase-tools
firebase login
firebase init functions   # TypeScript, регион europe-west1, Node LTS
firebase emulators:start --only functions,firestore,auth
firebase deploy --only functions
```
- `aiSuggest`: проверка auth и участия в комнате, rate limit, таймаут,
  валидация JSON, проверка placeId из выдачи, fallback.
- Секрет провайдера: `firebase functions:secrets:set LLM_API_KEY` (Secret Manager),
  не в коде и не в `.env` в репозитории.
- Логи без ПДн; метрики latency/cost/fallback.
- Локально Functions emulator работает без Blaze; деплой — только на Blaze.

### Проверка локально (2026-11-04)
```bash
cd functions
npm install
npm run build
firebase emulators:start --only functions --project date-navigation
curl http://127.0.0.1:5001/date-navigation/europe-west1/healthCheck
```
Ожидаемый ответ: `200 OK` и JSON `{"ok":true,...}`. Проверено: healthCheck
отвечает на emulator. Деплой:
```bash
firebase deploy --only functions
```
После деплоя проверить URL функции в консоли/логах и бюджет.

## 8. Push (если включаем)
- Firebase Cloud Messaging, APNs для iOS.
- `users/{uid}/devices/{token}`.
- Cloud Function на `rooms/{id}/messages` → multicast участникам.
- Требуется Blaze; при отказе — local notifications и документированное
  ограничение.

## 8a. Live-геолокация (stretch)
- Android: `ACCESS_BACKGROUND_LOCATION`, foreground service + постоянное
  уведомление, `FOREGROUND_SERVICE_LOCATION`, `POST_NOTIFICATIONS`.
- iOS: `NSLocationAlwaysAndWhenInUseUsageDescription`,
  `UIBackgroundModes: location`, `allowsBackgroundLocationUpdates`,
  `showsBackgroundLocationIndicator`.
- Flutter: `geolocator` с background-настройками; резерв —
  `flutter_background_geolocation`.
- Частота 30–60 с или 50 м, accuracy medium/low.
- Авто-стоп 60 минут; история не хранится.
- Только приватные комнаты.

## 9. Сборка
```bash
flutter build apk --release --dart-define=...
flutter build ios --release --dart-define=...
```
- Версии и подписи — локально.
- Демо-сборка: debug/profile, тестовые аккаунты.

## 10. Демо-среда
- 2–3 устройства/эмулятора.
- Тестовые комнаты и данные (без реальных адресов пользователей).
- Стабильная сеть + сценарий деградации (отключить Wi-Fi на одном устройстве).
- Резервный видео-ролик демо на случай сбоя.

## 11. Риски развёртывания
- Blaze/биллинг: забытый бюджет или аномальный расход.
- APNs-сертификаты для iOS.
- Публичные API могут тормозить на демо — кэш/fallback.
- Разные версии ОС и permissions.
- Холодные старты Functions на демо.
