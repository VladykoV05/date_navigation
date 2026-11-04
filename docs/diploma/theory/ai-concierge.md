# AI-консьерж подбора

## 1. Проблема и границы
Нужен помощник, который предлагает формат/место/следующий шаг и объясняет
выбор. Он не должен выдумывать места, не должен хранить ключ в клиенте и не
должен ломать основной сценарий при ошибке. В раздел входят: LLM-прокси,
контекст, промпт, валидация, оценка, fallback. Не входят: бот в чате,
автономные действия без подтверждения, обучение своей модели.

## 2. Теория (с источниками)
- LLM генерирует текст вероятностно; температура влияет на разнообразие,
  но не гарантирует факты.
- Function calling/tools позволяют модели запрашивать данные приложения
  (места, маршруты) вместо выдумывания.
- RAG: подать в контекст релевантные данные (выдачу мест), ограничить ответ
  ими; проверять, что предложенные id есть в контексте.
- Prompt injection: пользовательский текст — данные, не инструкции; системный
  промпт отделён; tools с allowlist.
- Оценка: релевантность, разнообразие, объяснимость, latency, стоимость,
  доля fallback/невалидного JSON.
- Приватность: минимизировать ПДн, не отправлять лишние координаты/имена.
- Стоимость: токены на вход/выход, лимиты на пользователя/комнату.

Источники (проверить и дополнить):
- OWASP Top 10 for LLM Applications. URL: https://owasp.org/www-project-top-10-for-large-language-model-applications/
- OpenAI. Function calling. URL: https://platform.openai.com/docs/guides/function-calling
- Anthropic. Prompt engineering overview. URL: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview
- Lewis, P. et al. Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks (2020) — указать DOI.

## 3. Решение в проекте
- `AiAssistantPort` в domain; реализация — `AiProxyDataSource` → Cloud Function
  или Worker. Ключ только на сервере.
- Вход: формат(ы), город/регион, 10–20 мест из выдачи (id, name, type,
  distance, eta), точки участников (можно приблизить), бюджет времени.
- Выход: 3 варианта `{placeId, reason, score}`; валидация: placeId из выдачи,
  reason 1–2 предложения, без персональных данных.
- Промпт: роль консьержа, ограничения (только из списка), формат JSON,
  объяснение, diversity.
- Fallback: `DateAssistantService` (детерминированные сценарии), если таймаут,
  ошибка, невалидный JSON или место вне выдачи.
- Rate limit: на uid/room, дневной бюджет; логи метрик без ПДн.
- UI: блок «AI-консьерж» в панели комнаты; карточки с причиной; кнопка
  «Предложить» / «Обновить».

Альтернативы: on-device модель (приватность, но размер/качество), только
эвристики (дёшево, но нет объяснений), прямой вызов из клиента (небезопасно).

## 4. Реализация
- `domain/ports/ai_assistant_port.dart`.
- `data/datasources/remote/ai_proxy_data_source.dart`.
- `functions/src/aiSuggest.ts` (или Worker).
- `presentation/widgets/room_control/ai_concierge_section.dart`.
- `application/services/date_assistant_service.dart` — fallback.

## 5. Проверка
- 15 запросов: relevance/diversity (экспертная шкала), latency, cost,
  fallback rate, invalid JSON rate.
- Тест: место вне выдачи → отбраковка/fallback.
- Тест: таймаут/500 → fallback.
- Проверка: ключ отсутствует в клиентском бандле.
- Prompt injection: текст пользователя не меняет системные ограничения.

## 6. Ограничения и развитие
- Недетерминизм и галлюцинации; нужна валидация и fallback.
- Стоимость/latency; лимиты обязательны.
- Малая выборка оценки; экспертная шкала субъективна.
- В будущем: tool calling к живым данным, обратная связь, персонализация,
  on-device модель.
