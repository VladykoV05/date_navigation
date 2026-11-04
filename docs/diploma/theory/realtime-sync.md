# Синхронизация состояния в реальном времени

## 1. Проблема и границы
Комната должна синхронизироваться между устройствами: точки, формат, голоса,
места, финальный выбор, чат. Сейчас это Firestore snapshots + reducer, но модель
бинарная и ролевая. Нужно понять, как обеспечить консистентность, offline и
конфликты при переходе к v2. В раздел входят: listeners, транзакции, offline,
конфликты, правила. Не входят: CRDT, своя синхронизация, realtime-БД.

## 2. Теория (с источниками)
- Firestore — документная БД с eventual consistency; `snapshots()` доставляет
  изменения, но порядок между разными документами не гарантирован.
- Транзакции дают атомарность над набором документов; для join/capacity нужна
  транзакция, иначе гонка.
- Offline persistence хранит локальный кэш и очередь; при восстановлении сети
  возможны конфликты, которые разрешаются last-write-wins на уровне полей.
- Идемпотентность: повторная операция не должна создавать дубликат (clientId).
- Денормализация ускоряет чтение, но требует синхронизации копий.
- Security rules — часть модели: они ограничивают, кто и какие поля пишет.

Источники (проверить и дополнить):
- Firebase. Cloud Firestore data model. URL: https://firebase.google.com/docs/firestore/data-model
- Firebase. Transactions and batched writes. URL: https://firebase.google.com/docs/firestore/manage-data/transactions
- Firebase. Offline persistence. URL: https://firebase.google.com/docs/firestore/manage-data/enable-offline
- Firebase. Security rules. URL: https://firebase.google.com/docs/firestore/security/get-started

## 3. Решение в проекте
- Перейти на схему v2: `rooms/{id}` + `participants/{uid}` + подколлекции.
- Join открытой комнаты — транзакция: read room, проверка capacity/status,
  create participant, increment count.
- Приватная комната — тот же invite, но `capacity=2`; сохранить поведение
  `roomFull` для третьего.
- Чтение: snapshot комнаты + snapshot участников; reducer собирает state.
- Offline: использовать кэш Firestore; UI показывает «отправляется/офлайн».
- Конфликты личных полей — разные документы, поэтому нет борьбы за один.
- `creatorUid/partnerUid` — derived на переходный период, не источник истины.

Альтернативы: оставить один документ (конфликты и rules), отдельная `openRooms`
(дублирование), своя БД (вне scope).

## 4. Реализация
- `lib/features/date_navigation/domain/entities/room_snapshot.dart` — v2 поля.
- `lib/features/date_navigation/data/mappers/room_snapshot_mapper.dart` — adapter v1/v2.
- `lib/features/date_navigation/application/sync/room_snapshot_reducer.dart` — сборка.
- `lib/features/date_navigation/data/datasources/remote/room_session_remote_data_source.dart`
  — транзакции.
- `firestore.rules`, `firestore.indexes.json`.
- `scripts/migrate_rooms_v2.js`.

## 5. Проверка
- Contract/emulator: join, capacity, чужие поля, приватная регрессия.
- Параллельные join (10 при capacity=3) — count консистентен.
- Offline: отключить сеть, изменить поле, восстановить — нет потерь/дублей.
- Метрика: число чтений на открытие комнаты; latency синхронизации.

## 6. Ограничения и развитие
- Eventual consistency: короткое окно расхождения; UI должен это переживать.
- Last-write-wins для одного поля; для сложных конфликтов нужна стратегия.
- Больше чтений при подколлекциях; для больших N — пагинация/агрегаты.
- В будущем: Cloud Functions для системных событий, presence, агрегаты.
