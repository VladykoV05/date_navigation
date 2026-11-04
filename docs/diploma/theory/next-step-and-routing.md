# «Куда дальше» и маршрут в приложении

## 1. Проблема и границы
После выбора заведения встреча не заканчивается: нужен следующий шаг (прогулка,
десерт, видовая точка). Сейчас приложение умеет находить равноудалённое место и
строить polyline, но не предлагает «что дальше» и в UI опирается на deeplink.
В раздел входят: подбор следующего места, сценарий из шагов, маршрут между
шагами, ETA. Не входят: бронирование, расписание, общественный транспорт.

## 2. Теория (с источниками)
- Рекомендации: content-based (формат/тип/рейтинг), diversity (не два бара
  подряд), distance/time budget.
- Пространственный поиск: кандидаты вокруг точки; haversine для расстояния,
  OSRM — для времени в пути.
- Маршрутизация: граф дорог, Dijkstra/A*; OSRM использует предобработку
  (Contraction Hierarchies / MLD) для быстрых запросов. Polyline — компактное
  кодирование геометрии.
- ETA зависит от профиля (driving/walking/cycling), трафика и качества данных;
  demo OSRM — только driving.
- Многошаговый сценарий: последовательность мест, время между ними, запас.
- Ограничения: opening_hours, закрытые места, сезонность — данные OSM неполны.

Источники (проверить и дополнить):
- OSRM API. URL: https://project-osrm.org/docs/v5.24.0/api/
- OSRM FAQ (алгоритмы). URL: https://project-osrm.org/docs/v5.24.0/faq/
- OSM Wiki. Key:opening_hours. URL: https://wiki.openstreetmap.org/wiki/Key:opening_hours
- Ricci, F. et al. Recommender Systems Handbook — указать издание.

## 3. Решение в проекте
- `NextStepService`: после `finalChoice` берёт кандидатов вокруг заведения,
  исключает текущее место, фильтрует по формату/типу, считает расстояние/ETA,
  ранжирует с бонусом за разнообразие; возвращает 3 варианта с причиной.
- UI: блок «Куда дальше?» с карточками; добавить шаг в `selectedScenario`.
- Маршрут: `RoutePlan` с legs (участник → место, место → следующий шаг),
  distance, duration, geometry, steps.
- OSRM: `route` с `steps=true`, `overview=full`, `geometries=polyline`;
  кэш; fallback — прямая линия + haversine.
- Внешняя навигация остаётся кнопкой «Открыть в картах».

Альтернативы: только deeplink (не решает «куда дальше»); Google Directions
(цена/ключ); свой OSRM (хостинг).

## 4. Реализация
- `domain/services/next_step_service.dart`.
- `domain/entities/route_plan.dart` (legs, steps, ETA).
- `data/datasources/remote/osrm_remote_data_source.dart` — steps/legs.
- `presentation/pages/route_page.dart`, `widgets/next_step_cards.dart`.
- `application/runtime/meeting_planner_runtime.dart` — контекст кандидатов.
- `selectedScenario` — сохранение шага.

## 5. Проверка
- 10 сценариев: relevance/diversity (экспертная шкала 1–5).
- ETA vs фактическое время (тестовый маршрут).
- Fallback: OSRM 500/timeout → прямая линия, UI не пустой.
- Кэш: повторный маршрут быстрее.
- Ручной smoke: выбрать место → 3 варианта → добавить → маршрут.

## 6. Ограничения и развитие
- OSRM demo — driving; для прогулки ETA может быть нерелевантен.
- OSM opening_hours неполны; «открыто сейчас» — stretch.
- Нет оптимизации порядка нескольких шагов (TSP) — stretch.
- В будущем: пешие/транспортные профили, бронирование, расписание.
