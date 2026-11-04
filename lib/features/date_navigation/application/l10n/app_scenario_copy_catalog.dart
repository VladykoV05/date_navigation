import 'dart:ui';

import '../../../../core/l10n/app_copy.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place_type.dart';
import '../../domain/services/scenario_copy_catalog.dart';

class AppScenarioCopyCatalog implements ScenarioCopyCatalog {
  AppScenarioCopyCatalog(Locale locale)
    : _l10n = lookupAppLocalizations(locale);

  final AppLocalizations _l10n;

  @override
  String title({
    required MeetingFormat format,
    required int variant,
    required String placeName,
  }) {
    return switch (format) {
      MeetingFormat.food => _l10n.scenarioTitleFood(variant, placeName),
      MeetingFormat.culture => _l10n.scenarioTitleCulture(variant),
      MeetingFormat.walkOnly => _l10n.scenarioTitleWalk(variant),
      MeetingFormat.active => _l10n.scenarioTitleActive(variant),
    };
  }

  @override
  String description(MeetingFormat format) {
    return switch (format) {
      MeetingFormat.food => _l10n.scenarioDescFood,
      MeetingFormat.culture => _l10n.scenarioDescCulture,
      MeetingFormat.walkOnly => _l10n.scenarioDescWalk,
      MeetingFormat.active => _l10n.scenarioDescActive,
    };
  }

  @override
  (String title, String description) step({
    required MeetingFormat format,
    required int stepIndex,
  }) {
    return switch (format) {
      MeetingFormat.food =>
        stepIndex == 0
            ? (_l10n.scenarioStepGatherVenue, _l10n.scenarioStepGatherVenueDesc)
            : (_l10n.scenarioStepFoodTalk, _l10n.scenarioStepFoodTalkDesc),
      MeetingFormat.culture =>
        stepIndex == 0
            ? (_l10n.scenarioStepMeetCulture, _l10n.scenarioStepMeetCultureDesc)
            : (
                _l10n.scenarioStepMainCulture,
                _l10n.scenarioStepMainCultureDesc,
              ),
      MeetingFormat.walkOnly =>
        stepIndex == 0
            ? (_l10n.scenarioStepMeetWalk, _l10n.scenarioStepMeetWalkDesc)
            : (_l10n.scenarioStepWalk, _l10n.scenarioStepWalkDesc),
      MeetingFormat.active =>
        stepIndex == 0
            ? (
                _l10n.scenarioStepGatherActive,
                _l10n.scenarioStepGatherActiveDesc,
              )
            : (_l10n.scenarioStepActive, _l10n.scenarioStepActiveDesc),
    };
  }
}

extension DateNavigationCopy on AppLocalizations {
  String chipLabelFor(PlaceType? placeType) =>
      chipLabelForWire(placeType?.wireValue);
}
