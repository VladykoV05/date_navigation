import 'package:date_navigation/features/date_navigation/application/runtime/meeting_planner_runtime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('queues and consumes meeting recalculation request once', () {
    final planner = MeetingPlannerRuntime();

    expect(planner.consumeMeetingRecalculateRequest(), isFalse);

    planner.requestMeetingRecalculate();

    expect(planner.consumeMeetingRecalculateRequest(), isTrue);
    expect(planner.consumeMeetingRecalculateRequest(), isFalse);
  });
}
