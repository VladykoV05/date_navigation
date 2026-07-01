import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/place.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/room_status.dart';
import 'package:date_navigation/features/date_navigation/presentation/widgets/room_control_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildPanel({
    required ValueChanged<Set<MeetingFormat>> onMeetingFormatsChanged,
    required ValueChanged<MeetingFormat> onMeetingFormatConfirmed,
    List<MeetingFormat> creatorMeetingFormats = const [],
    List<MeetingFormat> partnerMeetingFormats = const [],
    List<MeetingFormat> commonMeetingFormats = const [],
    MeetingFormat? mySelectedMeetingFormat,
    MeetingFormat? partnerSelectedMeetingFormat,
    MeetingFormat? selectedMeetingFormat,
    MeetingFormat? lastAgreedMeetingFormat,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: RoomControlPanel(
            roomId: 'ROOM42',
            isLoading: false,
            isGeocoding: false,
            isCalculatingMeeting: false,
            isLoadingRoomAction: false,
            addressController: TextEditingController(),
            onAddressSubmit: () {},
            recentAddresses: const [],
            onAddressSuggestionSelected: (_) {},
            onAddressSuggestionDeleted: (_) async {},
            onAddressSuggestionsDeleted: (_) async {},
            places: const <Place>[],
            selectedType: null,
            onTypeChanged: (_) {},
            onPlaceTap: (_) {},
            myLocation: null,
            hasPartner: true,
            searchRadius: 500,
            onSearchRadiusChanged: (_) {},
            onSearchRadiusChangeEnd: () {},
            onRetryPlaces: () {},
            onVotePlace: (_) {},
            voteCounts: const {},
            myVotePlaceName: null,
            scoreForPlace: (_) => 0,
            isFavoritePlace: (_) => false,
            creatorMeetingFormats: creatorMeetingFormats,
            partnerMeetingFormats: partnerMeetingFormats,
            commonMeetingFormats: commonMeetingFormats,
            mySelectedMeetingFormat: mySelectedMeetingFormat,
            partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
            selectedMeetingFormat: selectedMeetingFormat,
            lastAgreedMeetingFormat: lastAgreedMeetingFormat,
            meetingRevoteRequestByRole: null,
            meetingRevoteRequestStatus: null,
            onMeetingFormatsChanged: onMeetingFormatsChanged,
            onMeetingFormatConfirmed: onMeetingFormatConfirmed,
            isSessionClosed: false,
            sessionStatus: SessionStatus.active,
            isCreator: true,
            onLeaveRoom: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('shows common formats section and confirms selected format', (
    tester,
  ) async {
    MeetingFormat? confirmed;
    await tester.pumpWidget(
      buildPanel(
        creatorMeetingFormats: const [
          MeetingFormat.food,
          MeetingFormat.culture,
        ],
        partnerMeetingFormats: const [
          MeetingFormat.walkOnly,
          MeetingFormat.culture,
        ],
        commonMeetingFormats: const [MeetingFormat.culture],
        mySelectedMeetingFormat: null,
        onMeetingFormatsChanged: (_) {},
        onMeetingFormatConfirmed: (format) => confirmed = format,
      ),
    );

    expect(find.text('Общие форматы (выберите один)'), findsOneWidget);
    final commonChip = find.text('Культура и впечатления').last;
    await tester.ensureVisible(commonChip);
    await tester.tap(commonChip);
    await tester.pumpAndSettle();
    expect(confirmed, isNull);

    await tester.tap(find.text('Подтвердить мой выбор'));
    await tester.pumpAndSettle();

    expect(confirmed, MeetingFormat.culture);
  });

  testWidgets('tapping own format chip updates selected formats', (
    tester,
  ) async {
    Set<MeetingFormat>? last;
    await tester.pumpWidget(
      buildPanel(
        creatorMeetingFormats: const [MeetingFormat.food],
        onMeetingFormatsChanged: (formats) => last = formats,
        onMeetingFormatConfirmed: (_) {},
      ),
    );

    final myChip = find.text('Культура и впечатления').first;
    await tester.ensureVisible(myChip);
    await tester.tap(myChip);
    await tester.pumpAndSettle();

    expect(last, isNotNull);
    expect(last!.contains(MeetingFormat.food), isTrue);
    expect(last!.contains(MeetingFormat.culture), isTrue);
  });
}
