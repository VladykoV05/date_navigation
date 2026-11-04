import 'package:date_navigation/core/search/search_region.dart';
import 'package:date_navigation/core/search/search_region_preferences.dart';
import 'package:date_navigation/features/date_navigation/presentation/view_data/place_view_data.dart';
import 'package:date_navigation/features/date_navigation/presentation/widgets/room_control_panel.dart';
import 'package:date_navigation/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedSearchRegionController extends SearchRegionController {
  @override
  Future<SearchRegion> build() async => SearchRegion.minsk;
}

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
    VoidCallback? onUseCurrentLocation,
  }) {
    return ProviderScope(
      overrides: [
        searchRegionControllerProvider.overrideWith(
          _FixedSearchRegionController.new,
        ),
      ],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: RoomControlPanel(
              roomId: 'ROOM42',
              isLoading: false,
              isGeocoding: false,
              isLocating: false,
              isCalculatingMeeting: false,
              isLoadingRoomAction: false,
              addressController: TextEditingController(),
              onAddressSubmit: () {},
              onUseCurrentLocation: onUseCurrentLocation ?? () {},
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
              onExpandRadiusAndRetry: () {},
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
      ),
    );
  }

  testWidgets('invokes current location callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      buildPanel(
        onMeetingFormatsChanged: (_) {},
        onMeetingFormatConfirmed: (_) {},
        onUseCurrentLocation: () => tapped = true,
      ),
    );

    final button = find.text('Моя точка');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

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

    expect(find.text('Моя точка'), findsOneWidget);
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
