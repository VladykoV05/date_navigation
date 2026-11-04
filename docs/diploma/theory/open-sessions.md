# Открытые сессии

## 1. Проблема и границы
Сейчас комната — приватная, ровно на двоих, вход по invite. Нужен новый тип:
публичная/обнаруживаемая сессия, куда могут заходить другие (не жёстко 2).
В раздел входят: модель открытой комнаты, список, вступление, capacity,
приватность, модерация. Не входят: рекомендации людей, социальный граф,
платежи, промышленный антиспам.

## 2. Теория (с источниками)
- Обнаруживаемость — это публикация метаданных (тип, формат, город, число
  участников) без публикации личных точек.
- Firestore не имеет гео-запросов «из коробки»; типовые решения — geohash +
  bounding box, либо фильтр по городу/стране и сортировка на клиенте.
- Capacity — классическая гонка: два пользователя одновременно видят «есть
  место». Решение — транзакция/условная запись.
- Пагинация и индексы: составные индексы для `type + status + updatedAt`.
- Модерация: кто может завершить, kick/ban, rate limit, жалобы.
- Приватность: точные координаты — чувствительные данные; в списке показываем
  приблизительный центр/район и расстояние.

Источники (проверить и дополнить):
- Firebase. Geo queries (geohash). URL: https://firebase.google.com/docs/firestore/solutions/geoqueries
- Firebase. Transactions. URL: https://firebase.google.com/docs/firestore/manage-data/transactions
- OSM Wiki. Geohash. URL: https://wiki.openstreetmap.org/wiki/Geohash
- OWASP. Authorization cheat sheet. URL: https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html

## 3. Решение в проекте
- `type: private|open`, `visibility: invite|public`, `capacity`, `hostUid`.
- Открытая сессия: название, формат, город/страна, приблизительный центр,
  срок жизни, число участников.
- Список: `where type=open, status=active, expiresAt>now`, сортировка
  `updatedAt desc`; гео-фильтр — geohash-префикс (R2 stretch) или city/country.
- Join — транзакция с проверкой capacity; отказ `roomFull`.
- Хост завершает; участник выходит; при выходе хоста — завершение или передача
  (решение TODO).
- Приватная комната остаётся invite-only, capacity=2.
- Модерация MVP: хост может завершить, rate limit на создание; kick — stretch.

## 4. Реализация
- `domain/entities/room_snapshot.dart` — тип/видимость/capacity.
- `data/datasources/remote/room_session_remote_data_source.dart` — create/join.
- `data/datasources/remote/room_discovery_remote_data_source.dart` — список.
- `presentation/pages/open_sessions_page.dart`, `widgets/open_session_card.dart`.
- `firestore.rules`, `firestore.indexes.json`.
- `scripts/migrate_rooms_v2.js`.

## 5. Проверка
- 2 устройства входят, третий при capacity=2 получает отказ.
- 10 параллельных join при capacity=3 — ровно 3 успешных.
- Приватная комната: invite/join/roomFull — без регрессии.
- Список: не показывает точные точки; пагинация; фильтр по городу.
- Rules: чтение чужой приватной комнаты запрещено.

## 6. Ограничения и развитие
- Публичные открытые сессии — риск спама и нежелательных встреч; нужна
  модерация/жалобы (вне MVP).
- Гео-поиск на Firestore ограничен; geohash даёт приблизительность.
- Нет гарантии «свободного места» без транзакции.
- В будущем: approval, рекомендации, рейтинг хоста, безопасность встреч.
