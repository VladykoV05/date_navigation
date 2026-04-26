import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/meeting_interaction_coordinator.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const coordinator = MeetingInteractionCoordinator();

  test(
    'onMeetingFormatsSubmitted updates own formats and keeps matching confirmations',
    () {
      final state = const DateNavigationState(
        isCreator: true,
        creatorMeetingFormats: [MeetingFormat.food, MeetingFormat.culture],
        partnerMeetingFormats: [MeetingFormat.culture, MeetingFormat.walkOnly],
        creatorSelectedMeetingFormat: MeetingFormat.culture,
        partnerSelectedMeetingFormat: MeetingFormat.culture,
        selectedMeetingFormat: MeetingFormat.culture,
      );

      final next = coordinator.onMeetingFormatsSubmitted(
        state,
        formats: {MeetingFormat.food, MeetingFormat.culture},
      );

      expect(next.creatorMeetingFormats, [
        MeetingFormat.food,
        MeetingFormat.culture,
      ]);
      expect(next.partnerMeetingFormats, [
        MeetingFormat.culture,
        MeetingFormat.walkOnly,
      ]);
      expect(next.creatorSelectedMeetingFormat, MeetingFormat.culture);
      expect(next.partnerSelectedMeetingFormat, MeetingFormat.culture);
      expect(next.selectedMeetingFormat, MeetingFormat.culture);
    },
  );

  test(
    'onMeetingFormatsSubmitted clears selected format when no longer common',
    () {
      final state = const DateNavigationState(
        isCreator: true,
        creatorMeetingFormats: [MeetingFormat.food, MeetingFormat.culture],
        partnerMeetingFormats: [MeetingFormat.culture],
        creatorSelectedMeetingFormat: MeetingFormat.culture,
        partnerSelectedMeetingFormat: MeetingFormat.culture,
        selectedMeetingFormat: MeetingFormat.culture,
      );

      final next = coordinator.onMeetingFormatsSubmitted(
        state,
        formats: {MeetingFormat.food},
      );

      expect(next.creatorMeetingFormats, [MeetingFormat.food]);
      expect(next.creatorSelectedMeetingFormat, isNull);
      expect(next.partnerSelectedMeetingFormat, MeetingFormat.culture);
      expect(next.selectedMeetingFormat, isNull);
    },
  );

  test('onMeetingFormatConfirmed only accepts format from common list', () {
    const state = DateNavigationState(
      isCreator: true,
      creatorMeetingFormats: [MeetingFormat.food, MeetingFormat.culture],
      partnerMeetingFormats: [MeetingFormat.walkOnly, MeetingFormat.culture],
    );

    final valid = coordinator.onMeetingFormatConfirmed(
      state,
      format: MeetingFormat.culture,
    );
    final invalid = coordinator.onMeetingFormatConfirmed(
      state,
      format: MeetingFormat.food,
    );

    expect(valid.creatorSelectedMeetingFormat, MeetingFormat.culture);
    expect(valid.partnerSelectedMeetingFormat, isNull);
    expect(valid.selectedMeetingFormat, isNull);
    expect(invalid.selectedMeetingFormat, isNull);
  });
}
