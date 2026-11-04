# Тестирование и качество

## 1. Проблема и границы
Диплом требует доказательств, а не «работает у меня». Нужна стратегия тестов
для слоёв, Firestore rules и UI, а также эксперименты с метриками. В раздел
входят: пирамида тестов, rules-тесты, CI, метрики, угрозы валидности.
Не входят: нагрузочное тестирование промышленного масштаба, security-аудит.

## 2. Теория (с источниками)
- Пирамида тестов: много unit, меньше integration, мало E2E; стоимость и
  скорость обратно пропорциональны уровню.
- Contract-тесты rules: проверяют не только код, но и политику доступа.
- Flaky-тесты: изоляция, детерминированные данные, контроль времени/сети.
- Покрытие — индикатор, не цель; важнее покрытие рисков и правил.
- Эксперимент: гипотеза, условия, метрика, результат, угрозы валидности.
- Внешние API: mock/запись ответов, тесты деградации.

Источники (проверить и дополнить):
- Flutter. Testing overview. URL: https://docs.flutter.dev/testing/overview
- Firebase. Rules unit testing. URL: https://firebase.google.com/docs/rules/unit-tests
- Google Testing Blog. Test Sizes. URL: https://testing.googleblog.com/2010/12/test-sizes.html
- Wohlin, C. Experimentation in Software Engineering — указать издание.

## 3. Решение в проекте
- Unit: политики, редьюсеры, мапперы, ранжирование.
- Application: сценарии с fake-репозиториями.
- Data: HTTP-клиенты с mock, кэш, деградация.
- Rules: contract + emulator (`@firebase/rules-unit-testing`) в CI.
- Widget: состояния экранов, чат, форматы.
- Manual: 2–3 устройства, permissions, realtime.
- CI: analyze + test; отдельный job для rules.
- Метрики: см. `05_testing.md`; логи в `docs/diploma/log/`.

## 4. Реализация
- `test/*` — существующие 24 файла; расширять по блокам.
- `test/firestore_rules_contract_test.dart` — текстовые контракты.
- `scripts/` — emulator suite (R2).
- `.github/workflows/ci.yml` — job.
- `docs/diploma/05_testing.md` — матрица и результаты.

## 5. Проверка
- `flutter analyze` и `flutter test` — зелёные.
- Rules emulator — все кейсы из матрицы.
- Smoke — чек-лист на 2–3 устройствах.
- Метрики — с условиями и числами.

## 6. Ограничения и развитие
- Нет полного E2E-фреймворка; ручной smoke.
- Внешние API нестабильны; тесты с mock, но реальное поведение может отличаться.
- Малая выборка для экспериментов; оценка субъективна.
- В будущем: golden-тесты, integration_test, нагрузочные сценарии.
