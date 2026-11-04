# UI/UX, анимации и структура экранов

## 1. Проблема и границы
Сейчас анимаций мало (камера, bottom sheet), структура экранов выросла
органически. Нужно больше анимаций и переработка структуры: карта, сессии,
чат, комната. В раздел входят: motion-токены, переходы, иерархия, состояния,
доступность. Не входят: полный редизайн бренда, сложные 3D-эффекты.

## 2. Теория (с источниками)
- Material 3: motion как часть системы; длительности/кривые, easing,
  shared axis, fade through.
- Принципы анимации: причинность, длительность, непрерывность, обратная связь;
  анимация не должна блокировать действие.
- Иерархия и когнитивная нагрузка: один главный экран, вторичные — вкладки/листы.
- Состояния: loading/empty/error/success; skeleton снижает perceived latency.
- Доступность: reduced motion, контраст, text scale, semantics, touch targets.
- Эвристики Нильсена: видимость статуса, обратная связь, консистентность.

Источники (проверить и дополнить):
- Material Design 3. Motion. URL: https://m3.material.io/styles/motion/overview
- Flutter. Animations. URL: https://docs.flutter.dev/ui/animations
- W3C. WCAG 2.2 Quick Reference. URL: https://www.w3.org/WAI/WCAG22/quickref/
- Nielsen, J. 10 Usability Heuristics. URL: https://www.nngroup.com/articles/ten-usability-heuristics/

## 3. Решение в проекте
- Токены движения в `core/theme/ui_tokens.dart`: длительности (fast/normal/
  slow), кривые (easeOutCubic и др.).
- Переходы: shared axis между вкладками, fade для смены состояния, Hero для
  карточек места, анимация камеры (уже есть) — унифицировать.
- Структура: bottom navigation (Карта / Сессии / Чаты / Профиль); комната —
  вкладки «Места / Чат / Маршрут / Настройки».
- Состояния: skeleton для списков, empty с действием, error с retry.
- Reduced motion: учитывать `MediaQuery.disableAnimations`.
- A11y: semantics для кнопок, контраст, минимальный touch target 48dp.

## 4. Реализация
- `core/theme/ui_tokens.dart` — токены.
- `presentation/pages/*` — переходы/структура.
- `presentation/widgets/*` — Hero, skeleton, empty/error.
- `core_ui/*` — общие компоненты.
- ARB — тексты состояний.

## 5. Проверка
- Ручной smoke: переходы, reduced motion, text scale 200%, тёмная тема.
- Widget: состояния экранов.
- Метрика: perceived latency (субъективно), число шагов до цели.
- A11y: контраст, semantics, фокус.

## 6. Ограничения и развитие
- Анимации не должны ухудшать батарею/производительность на слабых устройствах.
- Переработка структуры может сломать привычные сценарии; нужен smoke.
- В будущем: дизайн-система, haptics, адаптивные layout для планшетов.
