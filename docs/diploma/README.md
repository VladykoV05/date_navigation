# Диплом: Sbor (date_navigation)

Рабочий корпус диплома. Код и текст ведутся параллельно: каждый блок R1–R6
закрывается теорией, ADR (если есть выбор), тестами и строкой в traceability.

## Статус
| Блок | Код | Теория | ADR | Тесты | Текст |
|---|---|---|---|---|---|
| R1 GPS + глобальный поиск | done (MVP) | `theory/geolocation.md`, `theory/global-geocoding.md` | ADR-0008 | unit/widget/region | TODO |
| R2 Открытые сессии + события + схема v2 | done | `theory/open-sessions.md`, `theory/events.md`, `theory/realtime-sync.md` | `adr/0002-room-schema-v2.md`, `adr/0005-event-source.md` | прототип TicketPro | TODO |
| R2.5 Live-геолокация (stretch) | planned | `theory/geolocation.md` | `adr/0006-live-location.md` | TODO | TODO |
| R3 Чат + уведомления | done (push — stretch) | `theory/chat.md`, `theory/notifications.md` | ADR-0009 | chat/rules/widget/notifications | TODO |
| R4 Форматы + кастомные | planned | `theory/formats.md` | TODO | TODO | TODO |
| R5 «Куда дальше» + маршрут | planned | `theory/next-step-and-routing.md` | TODO | TODO | TODO |
| R6 AI-консьерж | planned | `theory/ai-concierge.md` | `adr/0003-ai-proxy.md` | TODO | TODO |
| R7 UX/motion, качество | planned | `theory/ux-motion.md`, `theory/testing-and-quality.md` | TODO | TODO | TODO |

## Документы
- `00_topic.md` — тема, цель, задачи, границы, критерии успеха.
- `01_requirements.md` — функциональные и нефункциональные требования.
- `02_domain_analysis.md` — предметная область: акторы, процессы, правила, модель.
- `02_analysis.md` — аналоги, технологии, выбор стека.
- `03_design.md` — архитектура, модель данных, сценарии, безопасность.
- `04_implementation.md` — карта реализации по блокам.
- `05_testing.md` — стратегия, матрица тестов, метрики.
- `06_deployment.md` — Firebase, CI, сборка, демо-среда.
- `07_conclusion.md` — результаты, ограничения, развитие.
- `08_readiness.md` — чек-лист готовности к первой фиче (P0).
- `adr/` — архитектурные решения.
- `theory/` — теоретические разделы по темам.
- `log/` — дневник работы и замеров.
- `traceability.md` — требования ↔ код ↔ тесты ↔ текст.

## Правила
1. Не писать «сделано», пока нет кода/теста/ссылки.
2. Источники проверять; непроверенное помечать `TODO: verify`.
3. Каждый блок обновляет свой theory-файл и traceability.
4. Замеры — с условиями (устройство, сеть, версия, данные).
5. Ограничения фиксировать сразу, а не вспоминать на защите.
6. Секреты и персональные данные в документы не попадают.

## Связанные skills
- `date-navigation-app` — правила кода и roadmap.
- `date-navigation-diploma` — шаблон текста, источники, защита.
