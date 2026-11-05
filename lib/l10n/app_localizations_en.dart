// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Date Navigator';

  @override
  String get signInTitle => 'Meeting planner';

  @override
  String get signInSubtitle =>
      'Sign in with Google to save favorites and continue meetings faster.';

  @override
  String get signInButton => 'Sign in with Google';

  @override
  String get signInLoading => 'Signing in...';

  @override
  String get welcomeTitle => 'Ready to meet?';

  @override
  String get welcomeSubtitle =>
      'Create a room, share the code with a friend, and enter your addresses.\nWe will suggest convenient places near the midpoint.';

  @override
  String get welcomeCreateMeeting => 'Create meeting';

  @override
  String get welcomeJoinByCode => 'Join with code';

  @override
  String get waitSecondParticipant =>
      'Waiting for the second participant...\nAsk your partner to enter the room code and submit an address.';

  @override
  String get pickSameFormatFirst =>
      'Agree on the same meeting format first — place discovery unlocks after that.';

  @override
  String get formatNotMatchedPlaceDisabled =>
      'Place selection is unavailable until formats match.';

  @override
  String get noResultsInCategory =>
      'No results in this subcategory yet.\nPick another chip or reset the filter.';

  @override
  String get noResultsInRadius =>
      'No results in the current radius yet.\nIncrease search radius or tap Retry.';

  @override
  String get sessionCompletedHint =>
      'Session completed. You can create a new room.';

  @override
  String get sessionExpiredHint =>
      'Session expired. Create a new room to continue.';

  @override
  String get unstableNetworkShowingCached =>
      'Network is unstable. Showing the latest available results.';

  @override
  String get sessionCompletedBanner =>
      'Session completed. You can leave and create a new room.';

  @override
  String get sessionExpiredBanner =>
      'Session expired. Create a new room to continue.';

  @override
  String get leaveRoomTitle => 'Leave the room?';

  @override
  String get leaveRoomMessage =>
      'You will leave the room on this device and return to the start screen.';

  @override
  String get leaveRoomConfirm => 'Yes, leave';

  @override
  String get leaveRoomButton => 'Leave room';

  @override
  String get sessionClosedActionsDisabled =>
      'Session completed. Actions are disabled.';

  @override
  String get sessionExpiredActionsDisabled =>
      'Session expired. Actions are disabled.';

  @override
  String get loadingGeocoding => 'Checking address...';

  @override
  String get loadingMeeting => 'Finding meeting point and places...';

  @override
  String get loadingNearbyPlaces =>
      'Finding places near the meeting point... Usually takes 10-15 seconds.';

  @override
  String get loadingRoomSync => 'Updating room...';

  @override
  String get loadingGeneric => 'Loading...';

  @override
  String get otherAddressesLabel => 'Other addresses';

  @override
  String get clearOtherAddressesTitle => 'Clear other addresses?';

  @override
  String get clearOtherAddressesMessage =>
      'All addresses in this list will be removed.';

  @override
  String get clearAllAddressesLabel => 'Clear all';

  @override
  String get clearLabel => 'Clear';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get deleteAddressTooltip => 'Delete address';

  @override
  String get confirmMyFormatChoiceLabel => 'Confirm my choice';

  @override
  String get yesLabel => 'Yes';

  @override
  String get noLabel => 'No';

  @override
  String get okLabel => 'OK';

  @override
  String get openLabel => 'Open';

  @override
  String get rejectLabel => 'Reject';

  @override
  String get acceptLabel => 'Accept';

  @override
  String get focusPointMissing => 'Enter your address first';

  @override
  String get notEnoughPoints => 'Not enough points on the map';

  @override
  String get partnerRadiusSuggestTitle => 'Partner suggests radius';

  @override
  String partnerRadiusSuggestPrompt(int radius) {
    return 'Change search radius to $radius m?';
  }

  @override
  String get partnerRadiusAcceptLabel => 'Yes, accept';

  @override
  String partnerRadiusReminder(int radius) {
    return 'Partner still suggests $radius m';
  }

  @override
  String creatorChangedRadius(int radius) {
    return 'Creator changed radius to $radius m';
  }

  @override
  String get partnerPlaceSuggestTitle => 'Partner suggested a place';

  @override
  String proposalPlaceLabel(String place) {
    return 'Place: $place';
  }

  @override
  String proposalTypeLabel(String type) {
    return 'Type: $type';
  }

  @override
  String proposalAddressLabel(String address) {
    return 'Address: $address';
  }

  @override
  String get proposalAcceptQuestion => 'Accept?';

  @override
  String get meetingRevoteRequestTitle => 'Revote request';

  @override
  String get meetingRevoteRequestPrompt =>
      'Your partner wants to change the meeting format. Allow revote?';

  @override
  String get formatStatusSelectBoth =>
      'Pick formats. When they overlap, confirm one.';

  @override
  String get formatStatusNoCommon => 'No overlap yet. Add a matching format.';

  @override
  String get formatStatusReadyToConfirm => 'Common formats found. Confirm one.';

  @override
  String get formatStatusRevoteRequestedByMe =>
      'Revote request sent. Waiting for partner response.';

  @override
  String get formatStatusRevoteRequestedByPartner =>
      'Partner requests a format revote.';

  @override
  String formatStatusAgreed(String format) {
    return 'Format agreed: $format';
  }

  @override
  String formatStatusConfirmedByMe(String format) {
    return 'You confirmed: $format. Waiting for partner.';
  }

  @override
  String formatStatusRevotingNow(String format) {
    return 'Revote in progress. Current: $format.';
  }

  @override
  String get formatConfirmationMissing => 'not confirmed';

  @override
  String formatConfirmationLine(String my, String partner) {
    return 'You: $my • Partner: $partner';
  }

  @override
  String get formatDraftResetPrompt =>
      'Your selected format is no longer common. Reset and pick again?';

  @override
  String roomCodeLabel(String code) {
    return 'CODE: $code';
  }

  @override
  String get venueAgreedTitle => 'Venue agreed';

  @override
  String get dateAssistantTitle => 'Date Assistant';

  @override
  String get commonFormatsTitle => 'Common formats (pick one)';

  @override
  String get formatChangedTitle => 'Format selection changed';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingSlide1Title => 'Create a room';

  @override
  String get onboardingSlide1Body =>
      'Generate a code and share it with your partner to join the same session.';

  @override
  String get onboardingSlide2Title => 'Agree on format';

  @override
  String get onboardingSlide2Body =>
      'Pick a shared meeting format: food, walk, activity, or culture.';

  @override
  String get onboardingSlide3Title => 'Find a place';

  @override
  String get onboardingSlide3Body =>
      'Enter addresses and the app will suggest a meeting point and nearby places.';

  @override
  String addressDeleteUndoMessage(int seconds) {
    return 'Address will be deleted in $seconds seconds';
  }

  @override
  String addressesDeleteUndoMessage(int seconds) {
    return 'Addresses will be deleted in $seconds seconds';
  }

  @override
  String get undoLabel => 'Undo';

  @override
  String signInError(String message) {
    return 'Sign-in error: $message';
  }

  @override
  String signInGenericError(String error) {
    return 'Google sign-in failed: $error';
  }

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get accountMenuTooltip => 'Account';

  @override
  String get accountMenuCabinet => 'Profile';

  @override
  String get accountMenuLogout => 'Sign out';

  @override
  String get accountMenuLanguage => 'Language';

  @override
  String get accountFallbackTitle => 'Account';

  @override
  String get accountTitle => 'Profile';

  @override
  String get accountTabFavorites => 'Favorites';

  @override
  String get accountTabHistory => 'History';

  @override
  String get accountUserFallback => 'User';

  @override
  String get accountFavoritesEmpty => 'Favorites are empty';

  @override
  String get accountHistoryEmpty => 'Meeting history is empty';

  @override
  String get addressNotSpecified => 'Address not specified';

  @override
  String get removeFromFavoritesTooltip => 'Remove from favorites';

  @override
  String get timeUnknown => 'Time unknown';

  @override
  String get coordinatesNotSaved => 'Coordinates not saved';

  @override
  String get openOnMap => 'Open on map';

  @override
  String get typeNotSpecified => 'Type not specified';

  @override
  String get addressNotSaved => 'Address not saved';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get alreadyInFavorites => 'Already in favorites';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get userNotAuthenticated => 'User is not signed in';

  @override
  String get favoritesLoadFailed => 'Failed to load favorites';

  @override
  String get historyLoadFailed => 'Failed to load history';

  @override
  String get joinRoomTitle => 'Enter code';

  @override
  String get joinRoomCodeLabel => 'Room code';

  @override
  String get joinRoomCodeHint => '4 digits, e.g. 1234';

  @override
  String get joinRoomCodeHelper => 'Enter the code your partner sent';

  @override
  String get joinRoomSubmit => 'Join';

  @override
  String get mapActionsLabel => 'Map actions';

  @override
  String get mapShowAllTooltip => 'Show all';

  @override
  String get mapResetBearingTooltip => 'Reset rotation';

  @override
  String get mapCenterOnMeTooltip => 'Center on me';

  @override
  String get mapMarkerMe => 'Me';

  @override
  String get mapMarkerPartner => 'Partner';

  @override
  String get mapMarkerCenter => 'Center';

  @override
  String get mapMarkerPlaces => 'Places';

  @override
  String get searchRadiusLabel => 'Search radius';

  @override
  String metersShort(int meters) {
    return '$meters m';
  }

  @override
  String kilometersShort(String km) {
    return '$km km';
  }

  @override
  String get meetingPlacesTitle => 'Meeting places';

  @override
  String get retryLabel => 'Retry';

  @override
  String get dismissLabel => 'Dismiss';

  @override
  String get createNewRoom => 'Create new room';

  @override
  String get addressFieldLabel => 'Address';

  @override
  String get addressFieldHint => 'e.g. Minsk, Nezavisimosti 10';

  @override
  String get addressFieldHelper =>
      'Enter a precise address. For Belarus, Russian/Belarusian names or transliteration work best (OSM often has no English street names).';

  @override
  String get frequentAddressesTitle => 'Frequent addresses';

  @override
  String get meetingFormatFood => 'Coffee or dinner';

  @override
  String get meetingFormatCulture => 'Culture and experiences';

  @override
  String get meetingFormatWalk => 'Just a walk';

  @override
  String get meetingFormatActive => 'Active format';

  @override
  String get placeTypeBar => 'Bar';

  @override
  String get placeTypeRestaurant => 'Restaurant';

  @override
  String get placeTypeFastFood => 'Fast food';

  @override
  String get placeTypeCafe => 'Cafe';

  @override
  String get placeTypeCinema => 'Cinema';

  @override
  String get placeTypeCulture => 'Culture';

  @override
  String get placeTypeTheatre => 'Theatre';

  @override
  String get placeTypePark => 'Park';

  @override
  String get placeTypeViewpoint => 'Viewpoint';

  @override
  String get placeTypeSport => 'Sport';

  @override
  String get placeTypePool => 'Pool';

  @override
  String get placeTypeIceRink => 'Ice rink';

  @override
  String get placeTypeActive => 'Activity';

  @override
  String get placeTypeFallback => 'Place';

  @override
  String get chipAll => 'All';

  @override
  String get chipCafe => 'Cafe';

  @override
  String get chipRestaurants => 'Restaurants';

  @override
  String get chipCinema => 'Cinema';

  @override
  String get chipMuseums => 'Museums';

  @override
  String get chipGalleries => 'Galleries';

  @override
  String get chipTheatres => 'Theatres';

  @override
  String get chipParks => 'Parks';

  @override
  String get chipViewpoints => 'Viewpoints';

  @override
  String get chipFitness => 'Fitness';

  @override
  String get chipSportsCentre => 'Sports centre';

  @override
  String get chipPool => 'Pool';

  @override
  String get chipIceRink => 'Ice rink';

  @override
  String get chipRackets => 'Rackets';

  @override
  String get chipTeamSports => 'Team sports';

  @override
  String get chipClimbing => 'Climbing';

  @override
  String get chipDance => 'Dance';

  @override
  String get chipYoga => 'Yoga';

  @override
  String get proposePlace => 'Propose';

  @override
  String get placeProposedToPartner => 'Place proposed to partner';

  @override
  String get distanceForYou => 'You';

  @override
  String get distanceForPartner => 'Partner';

  @override
  String get routeLabel => 'Route';

  @override
  String distanceLine(String who, String dist) {
    return 'Distance: $who, $dist';
  }

  @override
  String placeSemanticsLabel(String name) {
    return 'Place $name';
  }

  @override
  String get placeSemanticsHint => 'Opens place details';

  @override
  String get removeVote => 'Remove vote';

  @override
  String get castVote => 'Vote';

  @override
  String get loadingBestPlaces => 'Finding the best places...';

  @override
  String get scenarioPlanTitle => 'Final meeting plan';

  @override
  String scenarioRoomLabel(String roomId) {
    return 'Room #$roomId';
  }

  @override
  String scenarioDuration(int minutes) {
    return 'Duration: $minutes min';
  }

  @override
  String scenarioAnchor(String name) {
    return 'Meeting point: $name';
  }

  @override
  String get scenarioSteps => 'Steps';

  @override
  String minutesShort(int minutes) {
    return '($minutes min)';
  }

  @override
  String get sharePlan => 'Share plan';

  @override
  String get openFinalPlan => 'Open final plan';

  @override
  String sharePlanHeader(String roomId) {
    return 'Meeting plan in room #$roomId';
  }

  @override
  String sharePlanDuration(int minutes) {
    return 'Duration: $minutes min';
  }

  @override
  String sharePlanPlace(String name) {
    return 'Place: $name';
  }

  @override
  String sharePlanAddress(String address) {
    return 'Address: $address';
  }

  @override
  String get sharePlanSteps => 'Steps:';

  @override
  String get sharePlanFooter => 'Created in Date Navigator';

  @override
  String get failureTimeout =>
      'The server is taking too long. Try again in a few seconds.';

  @override
  String get failureRateLimit => 'Too many requests. Wait a bit and try again.';

  @override
  String get failureNetwork =>
      'Network or access problem. Check your internet and try again.';

  @override
  String get failureParse => 'Unexpected server response. Please try again.';

  @override
  String get failureGeneric => 'Something went wrong. Please try again.';

  @override
  String get failureAddressNotFound => 'Address not found';

  @override
  String get failureLocationServiceDisabled => 'Location services are disabled';

  @override
  String get failureLocationPermissionDenied => 'Location permission denied';

  @override
  String get failureLocationPermissionDeniedForever =>
      'Location permission is blocked in settings';

  @override
  String get failureLocationUnavailable => 'Could not get your location';

  @override
  String get failureLocationTimeout => 'Location request timed out';

  @override
  String get useCurrentLocationLabel => 'Use my location';

  @override
  String get useCurrentLocationLoading => 'Locating...';

  @override
  String get failureRoomNotFound => 'Room not found';

  @override
  String get failureRoomCodeExists => 'A room with this code already exists';

  @override
  String get failureRoomFull => 'Room is already full';

  @override
  String get failureMeetingPointCalc => 'Could not calculate the meeting point';

  @override
  String get failureFormatMustBeCommon =>
      'Pick a format from the shared options only';

  @override
  String get failureSessionAlreadyEnded => 'Room session has already ended';

  @override
  String get failureOnlyCreatorCanEnd =>
      'Only the room creator can end the session';

  @override
  String scenarioTitleFood(int variant, String placeName) {
    return 'Coffee or dinner plan #$variant at $placeName';
  }

  @override
  String scenarioTitleCulture(int variant) {
    return 'Culture evening #$variant';
  }

  @override
  String scenarioTitleWalk(int variant) {
    return 'Walk plan #$variant';
  }

  @override
  String scenarioTitleActive(int variant) {
    return 'Active plan #$variant';
  }

  @override
  String get scenarioDescFood =>
      'Flexible format: grab coffee or have dinner in one place.';

  @override
  String get scenarioDescCulture =>
      'Experience format: cinema, exhibition, or an atmospheric cultural venue.';

  @override
  String get scenarioDescWalk =>
      'Calm format without a venue: a walk in a park or along the embankment.';

  @override
  String get scenarioDescActive => 'Dynamic format: a sporty or active meetup.';

  @override
  String get scenarioStepGatherVenue => 'Meet at the venue';

  @override
  String get scenarioStepGatherVenueDesc =>
      'Meet up and pick a comfortable table.';

  @override
  String get scenarioStepFoodTalk => 'Food and conversation';

  @override
  String get scenarioStepFoodTalkDesc =>
      'Coffee break or a full dinner — whatever fits the mood.';

  @override
  String get scenarioStepMeetCulture => 'Meet at the location';

  @override
  String get scenarioStepMeetCultureDesc =>
      'Meet at the chosen cultural place.';

  @override
  String get scenarioStepMainCulture => 'Main part';

  @override
  String get scenarioStepMainCultureDesc =>
      'Spend time together and share impressions.';

  @override
  String get scenarioStepMeetWalk => 'Meet at the start point';

  @override
  String get scenarioStepMeetWalkDesc =>
      'Gather at a convenient point near the route.';

  @override
  String get scenarioStepWalk => 'Walk';

  @override
  String get scenarioStepWalkDesc =>
      'Walk through the park or embankment and talk.';

  @override
  String get scenarioStepGatherActive => 'Meet at the location';

  @override
  String get scenarioStepGatherActiveDesc =>
      'Meet up and get ready for the activity.';

  @override
  String get scenarioStepActive => 'Active part';

  @override
  String get scenarioStepActiveDesc => 'Shared activity at a comfortable pace.';

  @override
  String get failureCreateRoomRetry =>
      'Could not create the room. Please try again.';

  @override
  String get failureCreateRoomFailed => 'Could not create the room';

  @override
  String get failureJoinRoom => 'Could not join the room';

  @override
  String get failureRoomCodeEmpty => 'Room code is empty';

  @override
  String get failureRoomCorrupt => 'Room data is corrupted';

  @override
  String get failureCreatorUnresolved => 'Could not resolve the room creator';

  @override
  String get failureNotRoomMember => 'You are not a participant of this room';

  @override
  String get failureUpdateLocation => 'Could not update location';

  @override
  String get failureCompleteSession => 'Could not complete the session';

  @override
  String get failurePickFormatBeforePlace =>
      'Agree on the final format before choosing a place';

  @override
  String get failureFormatNotSelected => 'Final meeting format is not selected';

  @override
  String get failureVotingClosed => 'Voting is closed after the final choice';

  @override
  String get failureVote => 'Could not submit the vote';

  @override
  String get failureFinalPlaceAlreadyChosen => 'Final place is already chosen';

  @override
  String get failureProposePlace => 'Could not propose the place';

  @override
  String get failureRespondProposal => 'Could not respond to the proposal';

  @override
  String get failureSyncResults => 'Could not sync results';

  @override
  String get failureSaveScenario => 'Could not save the meeting scenario';

  @override
  String get failureSaveFormat => 'Could not save the meeting format';

  @override
  String get failureRevoteAlreadyRequested =>
      'A revote request has already been sent';

  @override
  String get failureRequestRevote => 'Could not request a format revote';

  @override
  String get failureCannotConfirmOwnRevote =>
      'You cannot confirm your own revote request';

  @override
  String get failureProcessRevote => 'Could not process the revote request';

  @override
  String get failureConfirmFormat => 'Could not confirm the meeting format';

  @override
  String get failureSaveRadius => 'Could not save the search radius';

  @override
  String get failureSaveFavorite => 'Could not save favorite';

  @override
  String get failureDeleteFavorite => 'Could not remove favorite';

  @override
  String get failureSaveAddress => 'Could not save address';

  @override
  String get failureDeleteAddress => 'Could not delete address';

  @override
  String get failureSaveMeetingHistory => 'Could not save meeting history';

  @override
  String get failureServiceUnavailable => 'Service temporarily unavailable';

  @override
  String get failurePermissionDenied => 'Permission denied for this operation';

  @override
  String get failureGeocodingTimeout => 'Geocoding timed out';

  @override
  String get failureGeocodingRateLimit => 'Too many geocoding requests';

  @override
  String get failureGeocodingHttp => 'Geocoding request failed';

  @override
  String get failureGeocodingUnknown => 'Could not geocode the address';

  @override
  String get failureRoomStream =>
      'Lost connection to the room. Check your network.';

  @override
  String get failureRoutingTimeout => 'Route calculation timed out';

  @override
  String get failureRoutingFailed =>
      'Could not build a route between the addresses';

  @override
  String get presenceWaitingPartnerJoin =>
      'Waiting for your partner to join.\nShare the invite link or room code.';

  @override
  String get presenceWaitingPartnerAddress =>
      'Partner joined. Waiting for their address.';

  @override
  String get presenceWaitingYourAddress => 'Enter your address to continue.';

  @override
  String get presenceWaitingYourFormats =>
      'Pick meeting formats you are open to.';

  @override
  String get presenceWaitingPartnerFormats =>
      'Waiting for partner to pick meeting formats.';

  @override
  String get presenceWaitingYourFormatConfirm =>
      'Confirm a shared meeting format.';

  @override
  String get presenceWaitingPartnerFormatConfirm =>
      'Waiting for partner to confirm the format.';

  @override
  String get routingDegradedBanner =>
      'Route service is unavailable. Showing a simplified midpoint — tap Retry for a full route.';

  @override
  String get failureActionEditAddress =>
      'Edit the address and try again, or tap Retry.';

  @override
  String get failureActionResubscribeRoom =>
      'Tap Retry to reconnect to the room.';

  @override
  String get failureActionRetryMeeting =>
      'Tap Retry to recalculate the meeting point.';

  @override
  String get shareInviteLabel => 'Share invite';

  @override
  String shareInviteMessage(String code, String link) {
    return 'Join my Date Navigation room with code $code:\n$link';
  }

  @override
  String get inviteInvalidTitle => 'Invite unavailable';

  @override
  String get inviteInvalidMessage =>
      'This invite code is invalid or expired. Ask for a new code.';

  @override
  String get searchRegionLabel => 'Search region';

  @override
  String get searchRegionGlobal => 'Worldwide';

  @override
  String get searchRegionMinsk => 'Minsk';

  @override
  String get noResultsInRadiusHint =>
      'Try increasing the search radius, clearing the category filter, or changing the meeting format.';

  @override
  String get showAllCategoriesLabel => 'Show all categories';

  @override
  String get increaseRadiusHint => 'Increase radius and retry';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyBody =>
      'Date Navigation stores your account profile, room participation, favorites, and meeting history in Firebase to sync collaborative planning.\n\nAddresses and coordinates are written only to rooms you join. You can delete your account and associated personal data from the Profile screen.\n\nLocation services are used only when you submit an address for geocoding. Analytics and crash diagnostics are collected in release builds.';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountMessage =>
      'This permanently deletes your Firebase account, favorites, history, and address memory. Rooms you created are not force-deleted for the partner.';

  @override
  String get deleteAccountConfirm => 'Delete account';

  @override
  String get deleteAccountButton => 'Delete account';

  @override
  String get deleteAccountFailed =>
      'Could not delete the account. Sign in again and retry.';

  @override
  String get storeReadyChecklistNote =>
      'Permissions: Internet only. No continuous GPS tracking. Data safety: account + room sync via Firebase.';

  @override
  String get openSessionsTitle => 'Open sessions';

  @override
  String get openSessionsCreate => 'Create session';

  @override
  String get openSessionsRefresh => 'Refresh';

  @override
  String get openSessionsEmpty =>
      'No open sessions yet. Create one and invite people.';

  @override
  String get openSessionsLoadFailed => 'Could not load open sessions';

  @override
  String get openSessionsCapacity => 'Max people';

  @override
  String get openSessionNoEvent => 'Open session';

  @override
  String openSessionMembers(int count, int capacity) {
    return '$count of $capacity';
  }

  @override
  String get openSessionJoin => 'Join';

  @override
  String get openSessionFull => 'Full';

  @override
  String get openSessionsEvent => 'Event';

  @override
  String get openSessionsEventNone => 'No event';

  @override
  String get openSessionsEventsUnavailable =>
      'Event catalog is unavailable. Create a session without an event.';

  @override
  String get openEventRoute => 'Route to event';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatInputHint => 'Message';

  @override
  String get chatSend => 'Send';

  @override
  String get chatEmpty => 'No messages yet';

  @override
  String get chatLoadFailed => 'Could not load messages';

  @override
  String get chatSendFailed => 'Could not send message';

  @override
  String get chatOpen => 'Chat';

  @override
  String get chatLoadOlder => 'Load older';

  @override
  String get systemParticipantJoined => 'Participant joined';

  @override
  String get systemFormatConfirmed => 'Meeting format confirmed';

  @override
  String get systemPlaceSelected => 'Place selected';

  @override
  String get openSessionTabParticipants => 'Participants';

  @override
  String get openSessionTabPlan => 'Plan';

  @override
  String get openSessionTabChat => 'Chat';

  @override
  String get openSessionEnterAddress => 'Enter address';

  @override
  String get openSessionAddressSheetTitle => 'Your address';

  @override
  String get openSessionAddressSheetHint =>
      'The address is needed so participants can see your point';

  @override
  String get openSessionParticipantSelf => 'You';

  @override
  String get openSessionParticipantHost => 'Host';

  @override
  String openSessionParticipantNumber(Object number) {
    return 'Participant $number';
  }

  @override
  String get openSessionAddressSet => 'address set';

  @override
  String get openSessionAddressNotSet => 'address not set';

  @override
  String get openSessionLeave => 'Leave';

  @override
  String get openSessionPlanFromEvent => 'Event';

  @override
  String get openSessionEmptyParticipants => 'Nobody here yet';
}
