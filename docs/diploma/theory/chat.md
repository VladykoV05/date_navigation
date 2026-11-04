# Чат в комнате

## 1. Проблема и границы
Сейчас в комнате есть только голосование/предложение места. Нужен realtime-чат
в приватных и открытых сессиях. В раздел входят: сообщения, история, пагинация,
optimistic UI, дедупликация, unread, системные события. Не входят: вложения,
звонки, E2E-шифрование, полноценная модерация.

## 2. Теория (с источниками)
- Порядок сообщений: клиентские часы ненадёжны; используем серверный
  `serverTimestamp` и сортировку по нему. При равных timestamp — tie-breaker.
- Идемпотентность: `clientId` на сообщение; повторная отправка не создаёт дубль.
- Optimistic UI: показать сообщение сразу, заменить после подтверждения; при
  ошибке — статус «не отправлено» и retry.
- Пагинация: `orderBy(createdAt, desc).limit(N)`; старые — по скроллу.
- Unread: отдельный документ `reads/{uid}` с `lastReadAt`; бейдж = count после.
- Offline: Firestore кэширует; очередь отправки; при конфликте — last-write.
- Присутствие/presence — отдельная задача, не путать с чатом.
- Приватность: сообщения доступны только участникам; логи без текста.

Источники (проверить и дополнить):
- Firebase. Firestore realtime updates. URL: https://firebase.google.com/docs/firestore/query-data/listen
- Firebase. Server timestamps. URL: https://firebase.google.com/docs/firestore/manage-data/transactions#server_timestamps
- Firebase. Security rules. URL: https://firebase.google.com/docs/firestore/security/get-started

## 3. Решение в проекте
- `rooms/{id}/messages/{msgId}`: `senderUid`, `kind`, `text`, `createdAt`,
  `clientId`.
- `rooms/{id}/reads/{uid}`: `lastReadAt`.
- Правила: read — участник; create — `senderUid == auth.uid`, `text` 1..2000,
  `kind` из allowlist; update/delete запрещены (кроме системных — отдельно).
- Отправка: локальное сообщение с `clientId`; snapshot заменяет/дедуплицирует.
- История: первые 30, затем `startAfter` при скролле.
- Системные сообщения: join, смена формата, финальный выбор; пишет клиент-актор
  (MVP) или Cloud Function (цель).
- Unread: бейдж в панели комнаты; при открытии — обновить `lastReadAt`.
- Локальное уведомление о новом сообщении (R3), push — stretch.

## 4. Реализация
- `domain/entities/chat_message.dart`.
- `domain/repositories/chat_repository.dart`.
- `data/datasources/remote/chat_remote_data_source.dart`.
- `presentation/pages/chat_page.dart`, `widgets/message_bubble.dart`.
- `presentation/widgets/room_control_panel.dart` — вход в чат/бейдж.
- `core/notifications/local_notification_service.dart`.
- `firestore.rules`, индексы `messages: createdAt desc`.

## 5. Проверка
- 100 сообщений, offline 5 с, retry — нет дублей/потерь.
- Порядок при быстрой отправке с двух устройств.
- Пагинация: старые сообщения подгружаются, нет пропусков.
- Unread: корректный count, сброс при открытии.
- Rules: не-участник не читает; чужой senderUid отклоняется.

## 6. Ограничения и развитие
- Нет E2E; сообщения видны правилам/админам проекта.
- Нет вложений и реакций; нет модерации/жалоб.
- `serverTimestamp` может быть null в optimistic-сообщении; UI должен это
  обрабатывать.
- В будущем: push, read receipts, presence, шифрование, модерация.
