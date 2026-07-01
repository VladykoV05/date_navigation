import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/presentation/state_transitions/meeting_interaction_transitions.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const coordinator = MeetingInteractionTransitions();

  test(
    'onMeetingFormatsSubmitted updates own formats and keeps matching confirmations',
    () {
      final state = const DateNavigationState(
        room: RoomSessionState(isCreator: true),
        meeting: MeetingPlanningState(
          creatorMeetingFormats: [MeetingFormat.food, MeetingFormat.culture],
          partnerMeetingFormats: [
            MeetingFormat.culture,
            MeetingFormat.walkOnly,
          ],
          creatorSelectedMeetingFormat: MeetingFormat.culture,
          partnerSelectedMeetingFormat: MeetingFormat.culture,
          selectedMeetingFormat: MeetingFormat.culture,
        ),
      );

      final next = coordinator.onMeetingFormatsSubmitted(
        state,
        formats: {MeetingFormat.food, MeetingFormat.culture},
      );

      expect(next.meeting.creatorMeetingFormats, [
        MeetingFormat.food,
        MeetingFormat.culture,
      ]);
      expect(next.meeting.partnerMeetingFormats, [
        MeetingFormat.culture,
        MeetingFormat.walkOnly,
      ]);
      expect(next.meeting.creatorSelectedMeetingFormat, MeetingFormat.culture);
      expect(next.meeting.partnerSelectedMeetingFormat, MeetingFormat.culture);
      expect(next.meeting.selectedMeetingFormat, MeetingFormat.culture);
    },
  );

  test(
    'onMeetingFormatsSubmitted clears selected format when no longer common',
    () {
      final state = const DateNavigationState(
        room: RoomSessionState(isCreator: true),
        meeting: MeetingPlanningState(
          creatorMeetingFormats: [MeetingFormat.food, MeetingFormat.culture],
          partnerMeetingFormats: [MeetingFormat.culture],
          creatorSelectedMeetingFormat: MeetingFormat.culture,
          partnerSelectedMeetingFormat: MeetingFormat.culture,
          selectedMeetingFormat: MeetingFormat.culture,
        ),
      );

      final next = coordinator.onMeetingFormatsSubmitted(
        state,
        formats: {MeetingFormat.food},
      );

      expect(next.meeting.creatorMeetingFormats, [MeetingFormat.food]);
      expect(next.meeting.creatorSelectedMeetingFormat, isNull);
      expect(next.meeting.partnerSelectedMeetingFormat, MeetingFormat.culture);
      expect(next.meeting.selectedMeetingFormat, isNull);
    },
  );

  test('onMeetingFormatConfirmed only accepts format from common list', () {
    const state = DateNavigationState(
      room: RoomSessionState(isCreator: true),
      meeting: MeetingPlanningState(
        creatorMeetingFormats: [MeetingFormat.food, MeetingFormat.culture],
        partnerMeetingFormats: [MeetingFormat.walkOnly, MeetingFormat.culture],
      ),
    );

    final valid = coordinator.onMeetingFormatConfirmed(
      state,
      format: MeetingFormat.culture,
    );
    final invalid = coordinator.onMeetingFormatConfirmed(
      state,
      format: MeetingFormat.food,
    );

    expect(valid.meeting.creatorSelectedMeetingFormat, MeetingFormat.culture);
    expect(valid.meeting.partnerSelectedMeetingFormat, isNull);
    expect(valid.meeting.selectedMeetingFormat, isNull);
    expect(invalid.meeting.selectedMeetingFormat, isNull);
  });
}
