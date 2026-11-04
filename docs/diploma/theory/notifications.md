# Уведомления

## 1. Проблема и границы
Нужно сообщать о новых сообщениях, вступлении в комнату, подтверждении формата
и приближении встречи. Сейчас инфраструктуры нет. В раздел входят: local
notifications, push (FCM/APNs), токены устройств, deep links, настройки.
Не входят: маркетинговые рассылки, SMS, сложная сегментация.

## 2. Теория (с источниками)
- Local notifications — планируются на устройстве; работают без сервера, но не
  приходят, если приложение убито и событие внешнее.
- Push: FCM принимает сообщение и доставляет через APNs (iOS) или сервис
  Android; нужен токен устройства и серверный отправитель.
- Токены меняются; их нужно обновлять в `users/{uid}/devices/{token}`.
- Topics удобны для групп, но для приватных комнат лучше точечная отправка
  участникам.
- Delivery не гарантирован: Doze/фон, отключённые уведомления, лимиты.
- Payload: `notification` + `data` (roomId, messageId) для deep link.
- Приватность: не класть текст сообщения в push, если он чувствительный;
  лучше «Новое сообщение в комнате».
- Антиспам: батчинг, throttle, настройки пользователя.

Источники (проверить и дополнить):
- Firebase Cloud Messaging. URL: https://firebase.google.com/docs/cloud-messaging
- FCM iOS/APNs. URL: https://firebase.google.com/docs/cloud-messaging/ios/client
- Android Doze. URL: https://developer.android.com/training/monitoring-device-state/doze-standby
- flutter_local_notifications. URL: https://pub.dev/packages/flutter_local_notifications

## 3. Решение в проекте
- MVP: `flutter_local_notifications` для foreground/локальных событий; unread
  бейдж; deep link в комнату/чат.
- Stretch: `firebase_messaging`; `users/{uid}/devices`; Cloud Function на
  `rooms/{id}/messages` и события комнаты; multicast участникам.
- Payload: `{type, roomId, messageId}`; без текста сообщения.
- Настройки: включить/выключить по типам; не спамить.
- Deep link: `datenavigation://room/{id}/chat` (или существующая схема).
- Если Blaze нет — push не включаем, фиксируем ограничение в тексте.

## 4. Реализация
- `core/notifications/local_notification_service.dart`.
- `core/notifications/push_token_service.dart` (stretch).
- `users/{uid}/devices/{token}` + rules.
- `functions/src/onMessageCreate.ts` (stretch).
- `core/deep_links/*` — маршрутизация.

## 5. Проверка
- Local: сообщение в foreground → уведомление; tap → чат.
- Push: приложение в фоне/убито → уведомление; tap → комната.
- Токен: обновление, logout, смена устройства.
- Отказ в разрешении → приложение работает, уведомлений нет.
- Метрика: delivery rate, latency, доля отключивших.

## 6. Ограничения и развитие
- FCM требует Blaze и настройки APNs; без этого только local.
- Доставка не гарантирована; UI не должен зависеть от push.
- Приватность: текст сообщения в push — риск.
- В будущем: групповые топики, тихие часы, батчинг, rich notifications.
