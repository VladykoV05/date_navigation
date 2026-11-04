import '../../l10n/app_localizations.dart';
import '../error/failure.dart';
import '../error/failure_codes.dart';

/// Localizes failures and wire-value place/format labels without feature imports.
extension AppCopy on AppLocalizations {
  String meetingFormatWireLabel(String? wireValue) {
    return switch ((wireValue ?? '').trim().toLowerCase()) {
      'food' || 'coffee' || 'dinner' => meetingFormatFood,
      'culture' || 'walk_and_coffee' => meetingFormatCulture,
      'walk_only' => meetingFormatWalk,
      'active' => meetingFormatActive,
      _ => meetingFormatFood,
    };
  }

  String placeTypeLabelFromWire(String? rawType) {
    final type = (rawType ?? '').trim().toLowerCase().replaceAll(' ', '_');
    if (type.isEmpty) return placeTypeFallback;
    return switch (type) {
      'bar' || 'pub' || 'biergarten' => placeTypeBar,
      'restaurant' || 'diner' => placeTypeRestaurant,
      'fast_food' || 'food_court' => placeTypeFastFood,
      'cafe' || 'coffee_shop' => placeTypeCafe,
      'cinema' => placeTypeCinema,
      'museum' || 'gallery' => placeTypeCulture,
      'theatre' => placeTypeTheatre,
      'park' || 'garden' => placeTypePark,
      'viewpoint' => placeTypeViewpoint,
      'fitness_centre' || 'sports_centre' || 'sport' => placeTypeSport,
      'swimming_pool' => placeTypePool,
      'ice_rink' => placeTypeIceRink,
      'active_racket' ||
      'active_team' ||
      'active_climb' ||
      'active_dance' ||
      'active_mind_body' => placeTypeActive,
      _ => placeTypeFallback,
    };
  }

  String chipLabelForWire(String? wireValue) {
    if (wireValue == null || wireValue.trim().isEmpty) return chipAll;
    return switch (wireValue.trim().toLowerCase()) {
      'cafe' => chipCafe,
      'restaurant' => chipRestaurants,
      'cinema' => chipCinema,
      'museum' => chipMuseums,
      'gallery' => chipGalleries,
      'theatre' => chipTheatres,
      'park' => chipParks,
      'viewpoint' => chipViewpoints,
      'fitness_centre' => chipFitness,
      'sports_centre' => chipSportsCentre,
      'swimming_pool' => chipPool,
      'ice_rink' => chipIceRink,
      'active_racket' => chipRackets,
      'active_team' => chipTeamSports,
      'active_climb' => chipClimbing,
      'active_dance' => chipDance,
      'active_mind_body' => chipYoga,
      _ => placeTypeLabelFromWire(wireValue),
    };
  }

  String localizeFailure(Failure failure) {
    final byCode = _messageForCode(failure.message.trim());
    if (byCode != null) return byCode;

    return switch (failure) {
      TimeoutFailure() => failureTimeout,
      RateLimitFailure() => failureRateLimit,
      NetworkFailure() => failureNetwork,
      ParseFailure() => failureParse,
      UnknownFailure() => failureGeneric,
    };
  }

  String? _messageForCode(String code) {
    if (code.isEmpty) return null;
    return switch (code) {
      FailureCodes.userNotAuthenticated => userNotAuthenticated,
      FailureCodes.favoritesLoadFailed => favoritesLoadFailed,
      FailureCodes.historyLoadFailed => historyLoadFailed,
      FailureCodes.deleteAccountFailed => deleteAccountFailed,
      FailureCodes.addressNotFound => failureAddressNotFound,
      FailureCodes.locationServiceDisabled => failureLocationServiceDisabled,
      FailureCodes.locationPermissionDenied => failureLocationPermissionDenied,
      FailureCodes.locationPermissionDeniedForever =>
        failureLocationPermissionDeniedForever,
      FailureCodes.locationUnavailable => failureLocationUnavailable,
      FailureCodes.locationTimeout => failureLocationTimeout,
      FailureCodes.saveAddressFailed => failureSaveAddress,
      FailureCodes.deleteAddressFailed => failureDeleteAddress,
      FailureCodes.roomNotFound => failureRoomNotFound,
      FailureCodes.roomCodeExists => failureRoomCodeExists,
      FailureCodes.roomCodeEmpty => failureRoomCodeEmpty,
      FailureCodes.createRoomFailed => failureCreateRoomFailed,
      FailureCodes.createRoomRetry => failureCreateRoomRetry,
      FailureCodes.joinRoomFailed => failureJoinRoom,
      FailureCodes.roomFull => failureRoomFull,
      FailureCodes.roomCorrupt => failureRoomCorrupt,
      FailureCodes.creatorUnresolved => failureCreatorUnresolved,
      FailureCodes.notRoomMember => failureNotRoomMember,
      FailureCodes.updateLocationFailed => failureUpdateLocation,
      FailureCodes.onlyCreatorCanEnd => failureOnlyCreatorCanEnd,
      FailureCodes.completeSessionFailed => failureCompleteSession,
      FailureCodes.meetingPointCalcFailed => failureMeetingPointCalc,
      FailureCodes.formatMustBeCommon => failureFormatMustBeCommon,
      FailureCodes.formatNotSelected => failureFormatNotSelected,
      FailureCodes.sessionAlreadyEnded => failureSessionAlreadyEnded,
      FailureCodes.pickFormatBeforePlace => failurePickFormatBeforePlace,
      FailureCodes.votingClosed => failureVotingClosed,
      FailureCodes.voteFailed => failureVote,
      FailureCodes.finalPlaceAlreadyChosen => failureFinalPlaceAlreadyChosen,
      FailureCodes.proposePlaceFailed => failureProposePlace,
      FailureCodes.respondProposalFailed => failureRespondProposal,
      FailureCodes.syncResultsFailed => failureSyncResults,
      FailureCodes.saveScenarioFailed => failureSaveScenario,
      FailureCodes.saveFormatFailed => failureSaveFormat,
      FailureCodes.revoteAlreadyRequested => failureRevoteAlreadyRequested,
      FailureCodes.requestRevoteFailed => failureRequestRevote,
      FailureCodes.cannotConfirmOwnRevote => failureCannotConfirmOwnRevote,
      FailureCodes.processRevoteFailed => failureProcessRevote,
      FailureCodes.confirmFormatFailed => failureConfirmFormat,
      FailureCodes.saveRadiusFailed => failureSaveRadius,
      FailureCodes.saveFavoriteFailed => failureSaveFavorite,
      FailureCodes.deleteFavoriteFailed => failureDeleteFavorite,
      FailureCodes.saveMeetingHistoryFailed => failureSaveMeetingHistory,
      FailureCodes.serviceUnavailable => failureServiceUnavailable,
      FailureCodes.permissionDenied => failurePermissionDenied,
      FailureCodes.geocodingTimeout => failureGeocodingTimeout,
      FailureCodes.geocodingRateLimit => failureGeocodingRateLimit,
      FailureCodes.geocodingHttp => failureGeocodingHttp,
      FailureCodes.geocodingUnknown => failureGeocodingUnknown,
      FailureCodes.roomStreamFailed => failureRoomStream,
      FailureCodes.routingTimeout => failureRoutingTimeout,
      FailureCodes.routingFailed => failureRoutingFailed,
      _ => null,
    };
  }
}
