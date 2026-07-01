import 'package:date_navigation/features/date_navigation/presentation/view_data/place_view_data.dart';
import 'package:date_navigation/features/date_navigation/presentation/widgets/room_control_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildPanel({
    required ValueChanged<Set<MeetingFormatView>> onMeetingFormatsChanged,
    required ValueChanged<MeetingFormatView> onMeetingFormatConfirmed,
    List<MeetingFormatView> creatorMeetingFormats = const [],
    List<MeetingFormatView> partnerMeetingFormats = const [],
    List<MeetingFormatView> commonMeetingFormats = const [],
    MeetingFormatView? mySelectedMeetingFormat,
    MeetingFormatView? partnerSelectedMeetingFormat,
    MeetingFormatView? selectedMeetingFormat,
    MeetingFormatView? lastAgreedMeetingFormat,
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
            places: const <PlaceViewData>[],
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
            sessionStatus: SessionStatusView.active,
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
    MeetingFormatView? confirmed;
    await tester.pumpWidget(
      buildPanel(
        creatorMeetingFormats: const [
          MeetingFormatView.food,
          MeetingFormatView.culture,
        ],
        partnerMeetingFormats: const [
          MeetingFormatView.walkOnly,
          MeetingFormatView.culture,
        ],
        commonMeetingFormats: const [MeetingFormatView.culture],
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

    expect(confirmed, MeetingFormatView.culture);
  });

  testWidgets('tapping own format chip updates selected formats', (
    tester,
  ) async {
    Set<MeetingFormatView>? last;
    await tester.pumpWidget(
      buildPanel(
        creatorMeetingFormats: const [MeetingFormatView.food],
        onMeetingFormatsChanged: (formats) => last = formats,
        onMeetingFormatConfirmed: (_) {},
      ),
    );

    final myChip = find.text('Культура и впечатления').first;
    await tester.ensureVisible(myChip);
    await tester.tap(myChip);
    await tester.pumpAndSettle();

    expect(last, isNotNull);
    expect(last!.contains(MeetingFormatView.food), isTrue);
    expect(last!.contains(MeetingFormatView.culture), isTrue);
  });
}
