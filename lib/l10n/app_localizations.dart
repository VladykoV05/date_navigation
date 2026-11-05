import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Date Navigator'**
  String get appTitle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Meeting planner'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google to save favorites and continue meetings faster.'**
  String get signInSubtitle;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInButton;

  /// No description provided for @signInLoading.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signInLoading;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to meet?'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a room, share the code with a friend, and enter your addresses.\nWe will suggest convenient places near the midpoint.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeCreateMeeting.
  ///
  /// In en, this message translates to:
  /// **'Create meeting'**
  String get welcomeCreateMeeting;

  /// No description provided for @welcomeJoinByCode.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get welcomeJoinByCode;

  /// No description provided for @waitSecondParticipant.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the second participant...\nAsk your partner to enter the room code and submit an address.'**
  String get waitSecondParticipant;

  /// No description provided for @pickSameFormatFirst.
  ///
  /// In en, this message translates to:
  /// **'Agree on the same meeting format first — place discovery unlocks after that.'**
  String get pickSameFormatFirst;

  /// No description provided for @formatNotMatchedPlaceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Place selection is unavailable until formats match.'**
  String get formatNotMatchedPlaceDisabled;

  /// No description provided for @noResultsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No results in this subcategory yet.\nPick another chip or reset the filter.'**
  String get noResultsInCategory;

  /// No description provided for @noResultsInRadius.
  ///
  /// In en, this message translates to:
  /// **'No results in the current radius yet.\nIncrease search radius or tap Retry.'**
  String get noResultsInRadius;

  /// No description provided for @sessionCompletedHint.
  ///
  /// In en, this message translates to:
  /// **'Session completed. You can create a new room.'**
  String get sessionCompletedHint;

  /// No description provided for @sessionExpiredHint.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Create a new room to continue.'**
  String get sessionExpiredHint;

  /// No description provided for @unstableNetworkShowingCached.
  ///
  /// In en, this message translates to:
  /// **'Network is unstable. Showing the latest available results.'**
  String get unstableNetworkShowingCached;

  /// No description provided for @sessionCompletedBanner.
  ///
  /// In en, this message translates to:
  /// **'Session completed. You can leave and create a new room.'**
  String get sessionCompletedBanner;

  /// No description provided for @sessionExpiredBanner.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Create a new room to continue.'**
  String get sessionExpiredBanner;

  /// No description provided for @leaveRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave the room?'**
  String get leaveRoomTitle;

  /// No description provided for @leaveRoomMessage.
  ///
  /// In en, this message translates to:
  /// **'You will leave the room on this device and return to the start screen.'**
  String get leaveRoomMessage;

  /// No description provided for @leaveRoomConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, leave'**
  String get leaveRoomConfirm;

  /// No description provided for @leaveRoomButton.
  ///
  /// In en, this message translates to:
  /// **'Leave room'**
  String get leaveRoomButton;

  /// No description provided for @sessionClosedActionsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Session completed. Actions are disabled.'**
  String get sessionClosedActionsDisabled;

  /// No description provided for @sessionExpiredActionsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Actions are disabled.'**
  String get sessionExpiredActionsDisabled;

  /// No description provided for @loadingGeocoding.
  ///
  /// In en, this message translates to:
  /// **'Checking address...'**
  String get loadingGeocoding;

  /// No description provided for @loadingMeeting.
  ///
  /// In en, this message translates to:
  /// **'Finding meeting point and places...'**
  String get loadingMeeting;

  /// No description provided for @loadingNearbyPlaces.
  ///
  /// In en, this message translates to:
  /// **'Finding places near the meeting point... Usually takes 10-15 seconds.'**
  String get loadingNearbyPlaces;

  /// No description provided for @loadingRoomSync.
  ///
  /// In en, this message translates to:
  /// **'Updating room...'**
  String get loadingRoomSync;

  /// No description provided for @loadingGeneric.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingGeneric;

  /// No description provided for @otherAddressesLabel.
  ///
  /// In en, this message translates to:
  /// **'Other addresses'**
  String get otherAddressesLabel;

  /// No description provided for @clearOtherAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear other addresses?'**
  String get clearOtherAddressesTitle;

  /// No description provided for @clearOtherAddressesMessage.
  ///
  /// In en, this message translates to:
  /// **'All addresses in this list will be removed.'**
  String get clearOtherAddressesMessage;

  /// No description provided for @clearAllAddressesLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllAddressesLabel;

  /// No description provided for @clearLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @deleteAddressTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete address'**
  String get deleteAddressTooltip;

  /// No description provided for @confirmMyFormatChoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm my choice'**
  String get confirmMyFormatChoiceLabel;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @okLabel.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okLabel;

  /// No description provided for @openLabel.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLabel;

  /// No description provided for @rejectLabel.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectLabel;

  /// No description provided for @acceptLabel.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptLabel;

  /// No description provided for @focusPointMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter your address first'**
  String get focusPointMissing;

  /// No description provided for @notEnoughPoints.
  ///
  /// In en, this message translates to:
  /// **'Not enough points on the map'**
  String get notEnoughPoints;

  /// No description provided for @partnerRadiusSuggestTitle.
  ///
  /// In en, this message translates to:
  /// **'Partner suggests radius'**
  String get partnerRadiusSuggestTitle;

  /// No description provided for @partnerRadiusSuggestPrompt.
  ///
  /// In en, this message translates to:
  /// **'Change search radius to {radius} m?'**
  String partnerRadiusSuggestPrompt(int radius);

  /// No description provided for @partnerRadiusAcceptLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes, accept'**
  String get partnerRadiusAcceptLabel;

  /// No description provided for @partnerRadiusReminder.
  ///
  /// In en, this message translates to:
  /// **'Partner still suggests {radius} m'**
  String partnerRadiusReminder(int radius);

  /// No description provided for @creatorChangedRadius.
  ///
  /// In en, this message translates to:
  /// **'Creator changed radius to {radius} m'**
  String creatorChangedRadius(int radius);

  /// No description provided for @partnerPlaceSuggestTitle.
  ///
  /// In en, this message translates to:
  /// **'Partner suggested a place'**
  String get partnerPlaceSuggestTitle;

  /// No description provided for @proposalPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Place: {place}'**
  String proposalPlaceLabel(String place);

  /// No description provided for @proposalTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String proposalTypeLabel(String type);

  /// No description provided for @proposalAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address: {address}'**
  String proposalAddressLabel(String address);

  /// No description provided for @proposalAcceptQuestion.
  ///
  /// In en, this message translates to:
  /// **'Accept?'**
  String get proposalAcceptQuestion;

  /// No description provided for @meetingRevoteRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Revote request'**
  String get meetingRevoteRequestTitle;

  /// No description provided for @meetingRevoteRequestPrompt.
  ///
  /// In en, this message translates to:
  /// **'Your partner wants to change the meeting format. Allow revote?'**
  String get meetingRevoteRequestPrompt;

  /// No description provided for @formatStatusSelectBoth.
  ///
  /// In en, this message translates to:
  /// **'Pick formats. When they overlap, confirm one.'**
  String get formatStatusSelectBoth;

  /// No description provided for @formatStatusNoCommon.
  ///
  /// In en, this message translates to:
  /// **'No overlap yet. Add a matching format.'**
  String get formatStatusNoCommon;

  /// No description provided for @formatStatusReadyToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Common formats found. Confirm one.'**
  String get formatStatusReadyToConfirm;

  /// No description provided for @formatStatusRevoteRequestedByMe.
  ///
  /// In en, this message translates to:
  /// **'Revote request sent. Waiting for partner response.'**
  String get formatStatusRevoteRequestedByMe;

  /// No description provided for @formatStatusRevoteRequestedByPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner requests a format revote.'**
  String get formatStatusRevoteRequestedByPartner;

  /// No description provided for @formatStatusAgreed.
  ///
  /// In en, this message translates to:
  /// **'Format agreed: {format}'**
  String formatStatusAgreed(String format);

  /// No description provided for @formatStatusConfirmedByMe.
  ///
  /// In en, this message translates to:
  /// **'You confirmed: {format}. Waiting for partner.'**
  String formatStatusConfirmedByMe(String format);

  /// No description provided for @formatStatusRevotingNow.
  ///
  /// In en, this message translates to:
  /// **'Revote in progress. Current: {format}.'**
  String formatStatusRevotingNow(String format);

  /// No description provided for @formatConfirmationMissing.
  ///
  /// In en, this message translates to:
  /// **'not confirmed'**
  String get formatConfirmationMissing;

  /// No description provided for @formatConfirmationLine.
  ///
  /// In en, this message translates to:
  /// **'You: {my} • Partner: {partner}'**
  String formatConfirmationLine(String my, String partner);

  /// No description provided for @formatDraftResetPrompt.
  ///
  /// In en, this message translates to:
  /// **'Your selected format is no longer common. Reset and pick again?'**
  String get formatDraftResetPrompt;

  /// No description provided for @roomCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'CODE: {code}'**
  String roomCodeLabel(String code);

  /// No description provided for @venueAgreedTitle.
  ///
  /// In en, this message translates to:
  /// **'Venue agreed'**
  String get venueAgreedTitle;

  /// No description provided for @dateAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Date Assistant'**
  String get dateAssistantTitle;

  /// No description provided for @commonFormatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Common formats (pick one)'**
  String get commonFormatsTitle;

  /// No description provided for @formatChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Format selection changed'**
  String get formatChangedTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Create a room'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Generate a code and share it with your partner to join the same session.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Agree on format'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'Pick a shared meeting format: food, walk, activity, or culture.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Find a place'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Enter addresses and the app will suggest a meeting point and nearby places.'**
  String get onboardingSlide3Body;

  /// No description provided for @addressDeleteUndoMessage.
  ///
  /// In en, this message translates to:
  /// **'Address will be deleted in {seconds} seconds'**
  String addressDeleteUndoMessage(int seconds);

  /// No description provided for @addressesDeleteUndoMessage.
  ///
  /// In en, this message translates to:
  /// **'Addresses will be deleted in {seconds} seconds'**
  String addressesDeleteUndoMessage(int seconds);

  /// No description provided for @undoLabel.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoLabel;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in error: {message}'**
  String signInError(String message);

  /// No description provided for @signInGenericError.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed: {error}'**
  String signInGenericError(String error);

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @accountMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountMenuTooltip;

  /// No description provided for @accountMenuCabinet.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get accountMenuCabinet;

  /// No description provided for @accountMenuLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountMenuLogout;

  /// No description provided for @accountMenuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountMenuLanguage;

  /// No description provided for @accountFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountFallbackTitle;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get accountTitle;

  /// No description provided for @accountTabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get accountTabFavorites;

  /// No description provided for @accountTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get accountTabHistory;

  /// No description provided for @accountUserFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get accountUserFallback;

  /// No description provided for @accountFavoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Favorites are empty'**
  String get accountFavoritesEmpty;

  /// No description provided for @accountHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Meeting history is empty'**
  String get accountHistoryEmpty;

  /// No description provided for @addressNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Address not specified'**
  String get addressNotSpecified;

  /// No description provided for @removeFromFavoritesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavoritesTooltip;

  /// No description provided for @timeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Time unknown'**
  String get timeUnknown;

  /// No description provided for @coordinatesNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Coordinates not saved'**
  String get coordinatesNotSaved;

  /// No description provided for @openOnMap.
  ///
  /// In en, this message translates to:
  /// **'Open on map'**
  String get openOnMap;

  /// No description provided for @typeNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Type not specified'**
  String get typeNotSpecified;

  /// No description provided for @addressNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Address not saved'**
  String get addressNotSaved;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @alreadyInFavorites.
  ///
  /// In en, this message translates to:
  /// **'Already in favorites'**
  String get alreadyInFavorites;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User is not signed in'**
  String get userNotAuthenticated;

  /// No description provided for @favoritesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load favorites'**
  String get favoritesLoadFailed;

  /// No description provided for @historyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get historyLoadFailed;

  /// No description provided for @joinRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get joinRoomTitle;

  /// No description provided for @joinRoomCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Room code'**
  String get joinRoomCodeLabel;

  /// No description provided for @joinRoomCodeHint.
  ///
  /// In en, this message translates to:
  /// **'4 digits, e.g. 1234'**
  String get joinRoomCodeHint;

  /// No description provided for @joinRoomCodeHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter the code your partner sent'**
  String get joinRoomCodeHelper;

  /// No description provided for @joinRoomSubmit.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinRoomSubmit;

  /// No description provided for @mapActionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Map actions'**
  String get mapActionsLabel;

  /// No description provided for @mapShowAllTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get mapShowAllTooltip;

  /// No description provided for @mapResetBearingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reset rotation'**
  String get mapResetBearingTooltip;

  /// No description provided for @mapCenterOnMeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Center on me'**
  String get mapCenterOnMeTooltip;

  /// No description provided for @mapMarkerMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get mapMarkerMe;

  /// No description provided for @mapMarkerPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get mapMarkerPartner;

  /// No description provided for @mapMarkerCenter.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get mapMarkerCenter;

  /// No description provided for @mapMarkerPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get mapMarkerPlaces;

  /// No description provided for @searchRadiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Search radius'**
  String get searchRadiusLabel;

  /// No description provided for @metersShort.
  ///
  /// In en, this message translates to:
  /// **'{meters} m'**
  String metersShort(int meters);

  /// No description provided for @kilometersShort.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String kilometersShort(String km);

  /// No description provided for @meetingPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Meeting places'**
  String get meetingPlacesTitle;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @dismissLabel.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismissLabel;

  /// No description provided for @createNewRoom.
  ///
  /// In en, this message translates to:
  /// **'Create new room'**
  String get createNewRoom;

  /// No description provided for @addressFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressFieldLabel;

  /// No description provided for @addressFieldHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Minsk, Nezavisimosti 10'**
  String get addressFieldHint;

  /// No description provided for @addressFieldHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter a precise address. For Belarus, Russian/Belarusian names or transliteration work best (OSM often has no English street names).'**
  String get addressFieldHelper;

  /// No description provided for @frequentAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequent addresses'**
  String get frequentAddressesTitle;

  /// No description provided for @meetingFormatFood.
  ///
  /// In en, this message translates to:
  /// **'Coffee or dinner'**
  String get meetingFormatFood;

  /// No description provided for @meetingFormatCulture.
  ///
  /// In en, this message translates to:
  /// **'Culture and experiences'**
  String get meetingFormatCulture;

  /// No description provided for @meetingFormatWalk.
  ///
  /// In en, this message translates to:
  /// **'Just a walk'**
  String get meetingFormatWalk;

  /// No description provided for @meetingFormatActive.
  ///
  /// In en, this message translates to:
  /// **'Active format'**
  String get meetingFormatActive;

  /// No description provided for @placeTypeBar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get placeTypeBar;

  /// No description provided for @placeTypeRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get placeTypeRestaurant;

  /// No description provided for @placeTypeFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast food'**
  String get placeTypeFastFood;

  /// No description provided for @placeTypeCafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get placeTypeCafe;

  /// No description provided for @placeTypeCinema.
  ///
  /// In en, this message translates to:
  /// **'Cinema'**
  String get placeTypeCinema;

  /// No description provided for @placeTypeCulture.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get placeTypeCulture;

  /// No description provided for @placeTypeTheatre.
  ///
  /// In en, this message translates to:
  /// **'Theatre'**
  String get placeTypeTheatre;

  /// No description provided for @placeTypePark.
  ///
  /// In en, this message translates to:
  /// **'Park'**
  String get placeTypePark;

  /// No description provided for @placeTypeViewpoint.
  ///
  /// In en, this message translates to:
  /// **'Viewpoint'**
  String get placeTypeViewpoint;

  /// No description provided for @placeTypeSport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get placeTypeSport;

  /// No description provided for @placeTypePool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get placeTypePool;

  /// No description provided for @placeTypeIceRink.
  ///
  /// In en, this message translates to:
  /// **'Ice rink'**
  String get placeTypeIceRink;

  /// No description provided for @placeTypeActive.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get placeTypeActive;

  /// No description provided for @placeTypeFallback.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get placeTypeFallback;

  /// No description provided for @chipAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get chipAll;

  /// No description provided for @chipCafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get chipCafe;

  /// No description provided for @chipRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get chipRestaurants;

  /// No description provided for @chipCinema.
  ///
  /// In en, this message translates to:
  /// **'Cinema'**
  String get chipCinema;

  /// No description provided for @chipMuseums.
  ///
  /// In en, this message translates to:
  /// **'Museums'**
  String get chipMuseums;

  /// No description provided for @chipGalleries.
  ///
  /// In en, this message translates to:
  /// **'Galleries'**
  String get chipGalleries;

  /// No description provided for @chipTheatres.
  ///
  /// In en, this message translates to:
  /// **'Theatres'**
  String get chipTheatres;

  /// No description provided for @chipParks.
  ///
  /// In en, this message translates to:
  /// **'Parks'**
  String get chipParks;

  /// No description provided for @chipViewpoints.
  ///
  /// In en, this message translates to:
  /// **'Viewpoints'**
  String get chipViewpoints;

  /// No description provided for @chipFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get chipFitness;

  /// No description provided for @chipSportsCentre.
  ///
  /// In en, this message translates to:
  /// **'Sports centre'**
  String get chipSportsCentre;

  /// No description provided for @chipPool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get chipPool;

  /// No description provided for @chipIceRink.
  ///
  /// In en, this message translates to:
  /// **'Ice rink'**
  String get chipIceRink;

  /// No description provided for @chipRackets.
  ///
  /// In en, this message translates to:
  /// **'Rackets'**
  String get chipRackets;

  /// No description provided for @chipTeamSports.
  ///
  /// In en, this message translates to:
  /// **'Team sports'**
  String get chipTeamSports;

  /// No description provided for @chipClimbing.
  ///
  /// In en, this message translates to:
  /// **'Climbing'**
  String get chipClimbing;

  /// No description provided for @chipDance.
  ///
  /// In en, this message translates to:
  /// **'Dance'**
  String get chipDance;

  /// No description provided for @chipYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get chipYoga;

  /// No description provided for @proposePlace.
  ///
  /// In en, this message translates to:
  /// **'Propose'**
  String get proposePlace;

  /// No description provided for @placeProposedToPartner.
  ///
  /// In en, this message translates to:
  /// **'Place proposed to partner'**
  String get placeProposedToPartner;

  /// No description provided for @distanceForYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get distanceForYou;

  /// No description provided for @distanceForPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get distanceForPartner;

  /// No description provided for @routeLabel.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get routeLabel;

  /// No description provided for @distanceLine.
  ///
  /// In en, this message translates to:
  /// **'Distance: {who}, {dist}'**
  String distanceLine(String who, String dist);

  /// No description provided for @placeSemanticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Place {name}'**
  String placeSemanticsLabel(String name);

  /// No description provided for @placeSemanticsHint.
  ///
  /// In en, this message translates to:
  /// **'Opens place details'**
  String get placeSemanticsHint;

  /// No description provided for @removeVote.
  ///
  /// In en, this message translates to:
  /// **'Remove vote'**
  String get removeVote;

  /// No description provided for @castVote.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get castVote;

  /// No description provided for @loadingBestPlaces.
  ///
  /// In en, this message translates to:
  /// **'Finding the best places...'**
  String get loadingBestPlaces;

  /// No description provided for @scenarioPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Final meeting plan'**
  String get scenarioPlanTitle;

  /// No description provided for @scenarioRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room #{roomId}'**
  String scenarioRoomLabel(String roomId);

  /// No description provided for @scenarioDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {minutes} min'**
  String scenarioDuration(int minutes);

  /// No description provided for @scenarioAnchor.
  ///
  /// In en, this message translates to:
  /// **'Meeting point: {name}'**
  String scenarioAnchor(String name);

  /// No description provided for @scenarioSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get scenarioSteps;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'({minutes} min)'**
  String minutesShort(int minutes);

  /// No description provided for @sharePlan.
  ///
  /// In en, this message translates to:
  /// **'Share plan'**
  String get sharePlan;

  /// No description provided for @openFinalPlan.
  ///
  /// In en, this message translates to:
  /// **'Open final plan'**
  String get openFinalPlan;

  /// No description provided for @sharePlanHeader.
  ///
  /// In en, this message translates to:
  /// **'Meeting plan in room #{roomId}'**
  String sharePlanHeader(String roomId);

  /// No description provided for @sharePlanDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {minutes} min'**
  String sharePlanDuration(int minutes);

  /// No description provided for @sharePlanPlace.
  ///
  /// In en, this message translates to:
  /// **'Place: {name}'**
  String sharePlanPlace(String name);

  /// No description provided for @sharePlanAddress.
  ///
  /// In en, this message translates to:
  /// **'Address: {address}'**
  String sharePlanAddress(String address);

  /// No description provided for @sharePlanSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps:'**
  String get sharePlanSteps;

  /// No description provided for @sharePlanFooter.
  ///
  /// In en, this message translates to:
  /// **'Created in Date Navigator'**
  String get sharePlanFooter;

  /// No description provided for @failureTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server is taking too long. Try again in a few seconds.'**
  String get failureTimeout;

  /// No description provided for @failureRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Wait a bit and try again.'**
  String get failureRateLimit;

  /// No description provided for @failureNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network or access problem. Check your internet and try again.'**
  String get failureNetwork;

  /// No description provided for @failureParse.
  ///
  /// In en, this message translates to:
  /// **'Unexpected server response. Please try again.'**
  String get failureParse;

  /// No description provided for @failureGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get failureGeneric;

  /// No description provided for @failureAddressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get failureAddressNotFound;

  /// No description provided for @failureLocationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get failureLocationServiceDisabled;

  /// No description provided for @failureLocationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get failureLocationPermissionDenied;

  /// No description provided for @failureLocationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked in settings'**
  String get failureLocationPermissionDeniedForever;

  /// No description provided for @failureLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location'**
  String get failureLocationUnavailable;

  /// No description provided for @failureLocationTimeout.
  ///
  /// In en, this message translates to:
  /// **'Location request timed out'**
  String get failureLocationTimeout;

  /// No description provided for @useCurrentLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useCurrentLocationLabel;

  /// No description provided for @useCurrentLocationLoading.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get useCurrentLocationLoading;

  /// No description provided for @failureRoomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get failureRoomNotFound;

  /// No description provided for @failureRoomCodeExists.
  ///
  /// In en, this message translates to:
  /// **'A room with this code already exists'**
  String get failureRoomCodeExists;

  /// No description provided for @failureRoomFull.
  ///
  /// In en, this message translates to:
  /// **'Room is already full'**
  String get failureRoomFull;

  /// No description provided for @failureMeetingPointCalc.
  ///
  /// In en, this message translates to:
  /// **'Could not calculate the meeting point'**
  String get failureMeetingPointCalc;

  /// No description provided for @failureFormatMustBeCommon.
  ///
  /// In en, this message translates to:
  /// **'Pick a format from the shared options only'**
  String get failureFormatMustBeCommon;

  /// No description provided for @failureSessionAlreadyEnded.
  ///
  /// In en, this message translates to:
  /// **'Room session has already ended'**
  String get failureSessionAlreadyEnded;

  /// No description provided for @failureOnlyCreatorCanEnd.
  ///
  /// In en, this message translates to:
  /// **'Only the room creator can end the session'**
  String get failureOnlyCreatorCanEnd;

  /// No description provided for @scenarioTitleFood.
  ///
  /// In en, this message translates to:
  /// **'Coffee or dinner plan #{variant} at {placeName}'**
  String scenarioTitleFood(int variant, String placeName);

  /// No description provided for @scenarioTitleCulture.
  ///
  /// In en, this message translates to:
  /// **'Culture evening #{variant}'**
  String scenarioTitleCulture(int variant);

  /// No description provided for @scenarioTitleWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk plan #{variant}'**
  String scenarioTitleWalk(int variant);

  /// No description provided for @scenarioTitleActive.
  ///
  /// In en, this message translates to:
  /// **'Active plan #{variant}'**
  String scenarioTitleActive(int variant);

  /// No description provided for @scenarioDescFood.
  ///
  /// In en, this message translates to:
  /// **'Flexible format: grab coffee or have dinner in one place.'**
  String get scenarioDescFood;

  /// No description provided for @scenarioDescCulture.
  ///
  /// In en, this message translates to:
  /// **'Experience format: cinema, exhibition, or an atmospheric cultural venue.'**
  String get scenarioDescCulture;

  /// No description provided for @scenarioDescWalk.
  ///
  /// In en, this message translates to:
  /// **'Calm format without a venue: a walk in a park or along the embankment.'**
  String get scenarioDescWalk;

  /// No description provided for @scenarioDescActive.
  ///
  /// In en, this message translates to:
  /// **'Dynamic format: a sporty or active meetup.'**
  String get scenarioDescActive;

  /// No description provided for @scenarioStepGatherVenue.
  ///
  /// In en, this message translates to:
  /// **'Meet at the venue'**
  String get scenarioStepGatherVenue;

  /// No description provided for @scenarioStepGatherVenueDesc.
  ///
  /// In en, this message translates to:
  /// **'Meet up and pick a comfortable table.'**
  String get scenarioStepGatherVenueDesc;

  /// No description provided for @scenarioStepFoodTalk.
  ///
  /// In en, this message translates to:
  /// **'Food and conversation'**
  String get scenarioStepFoodTalk;

  /// No description provided for @scenarioStepFoodTalkDesc.
  ///
  /// In en, this message translates to:
  /// **'Coffee break or a full dinner — whatever fits the mood.'**
  String get scenarioStepFoodTalkDesc;

  /// No description provided for @scenarioStepMeetCulture.
  ///
  /// In en, this message translates to:
  /// **'Meet at the location'**
  String get scenarioStepMeetCulture;

  /// No description provided for @scenarioStepMeetCultureDesc.
  ///
  /// In en, this message translates to:
  /// **'Meet at the chosen cultural place.'**
  String get scenarioStepMeetCultureDesc;

  /// No description provided for @scenarioStepMainCulture.
  ///
  /// In en, this message translates to:
  /// **'Main part'**
  String get scenarioStepMainCulture;

  /// No description provided for @scenarioStepMainCultureDesc.
  ///
  /// In en, this message translates to:
  /// **'Spend time together and share impressions.'**
  String get scenarioStepMainCultureDesc;

  /// No description provided for @scenarioStepMeetWalk.
  ///
  /// In en, this message translates to:
  /// **'Meet at the start point'**
  String get scenarioStepMeetWalk;

  /// No description provided for @scenarioStepMeetWalkDesc.
  ///
  /// In en, this message translates to:
  /// **'Gather at a convenient point near the route.'**
  String get scenarioStepMeetWalkDesc;

  /// No description provided for @scenarioStepWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get scenarioStepWalk;

  /// No description provided for @scenarioStepWalkDesc.
  ///
  /// In en, this message translates to:
  /// **'Walk through the park or embankment and talk.'**
  String get scenarioStepWalkDesc;

  /// No description provided for @scenarioStepGatherActive.
  ///
  /// In en, this message translates to:
  /// **'Meet at the location'**
  String get scenarioStepGatherActive;

  /// No description provided for @scenarioStepGatherActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Meet up and get ready for the activity.'**
  String get scenarioStepGatherActiveDesc;

  /// No description provided for @scenarioStepActive.
  ///
  /// In en, this message translates to:
  /// **'Active part'**
  String get scenarioStepActive;

  /// No description provided for @scenarioStepActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Shared activity at a comfortable pace.'**
  String get scenarioStepActiveDesc;

  /// No description provided for @failureCreateRoomRetry.
  ///
  /// In en, this message translates to:
  /// **'Could not create the room. Please try again.'**
  String get failureCreateRoomRetry;

  /// No description provided for @failureCreateRoomFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the room'**
  String get failureCreateRoomFailed;

  /// No description provided for @failureJoinRoom.
  ///
  /// In en, this message translates to:
  /// **'Could not join the room'**
  String get failureJoinRoom;

  /// No description provided for @failureRoomCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Room code is empty'**
  String get failureRoomCodeEmpty;

  /// No description provided for @failureRoomCorrupt.
  ///
  /// In en, this message translates to:
  /// **'Room data is corrupted'**
  String get failureRoomCorrupt;

  /// No description provided for @failureCreatorUnresolved.
  ///
  /// In en, this message translates to:
  /// **'Could not resolve the room creator'**
  String get failureCreatorUnresolved;

  /// No description provided for @failureNotRoomMember.
  ///
  /// In en, this message translates to:
  /// **'You are not a participant of this room'**
  String get failureNotRoomMember;

  /// No description provided for @failureUpdateLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not update location'**
  String get failureUpdateLocation;

  /// No description provided for @failureCompleteSession.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the session'**
  String get failureCompleteSession;

  /// No description provided for @failurePickFormatBeforePlace.
  ///
  /// In en, this message translates to:
  /// **'Agree on the final format before choosing a place'**
  String get failurePickFormatBeforePlace;

  /// No description provided for @failureFormatNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Final meeting format is not selected'**
  String get failureFormatNotSelected;

  /// No description provided for @failureVotingClosed.
  ///
  /// In en, this message translates to:
  /// **'Voting is closed after the final choice'**
  String get failureVotingClosed;

  /// No description provided for @failureVote.
  ///
  /// In en, this message translates to:
  /// **'Could not submit the vote'**
  String get failureVote;

  /// No description provided for @failureFinalPlaceAlreadyChosen.
  ///
  /// In en, this message translates to:
  /// **'Final place is already chosen'**
  String get failureFinalPlaceAlreadyChosen;

  /// No description provided for @failureProposePlace.
  ///
  /// In en, this message translates to:
  /// **'Could not propose the place'**
  String get failureProposePlace;

  /// No description provided for @failureRespondProposal.
  ///
  /// In en, this message translates to:
  /// **'Could not respond to the proposal'**
  String get failureRespondProposal;

  /// No description provided for @failureSyncResults.
  ///
  /// In en, this message translates to:
  /// **'Could not sync results'**
  String get failureSyncResults;

  /// No description provided for @failureSaveScenario.
  ///
  /// In en, this message translates to:
  /// **'Could not save the meeting scenario'**
  String get failureSaveScenario;

  /// No description provided for @failureSaveFormat.
  ///
  /// In en, this message translates to:
  /// **'Could not save the meeting format'**
  String get failureSaveFormat;

  /// No description provided for @failureRevoteAlreadyRequested.
  ///
  /// In en, this message translates to:
  /// **'A revote request has already been sent'**
  String get failureRevoteAlreadyRequested;

  /// No description provided for @failureRequestRevote.
  ///
  /// In en, this message translates to:
  /// **'Could not request a format revote'**
  String get failureRequestRevote;

  /// No description provided for @failureCannotConfirmOwnRevote.
  ///
  /// In en, this message translates to:
  /// **'You cannot confirm your own revote request'**
  String get failureCannotConfirmOwnRevote;

  /// No description provided for @failureProcessRevote.
  ///
  /// In en, this message translates to:
  /// **'Could not process the revote request'**
  String get failureProcessRevote;

  /// No description provided for @failureConfirmFormat.
  ///
  /// In en, this message translates to:
  /// **'Could not confirm the meeting format'**
  String get failureConfirmFormat;

  /// No description provided for @failureSaveRadius.
  ///
  /// In en, this message translates to:
  /// **'Could not save the search radius'**
  String get failureSaveRadius;

  /// No description provided for @failureSaveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Could not save favorite'**
  String get failureSaveFavorite;

  /// No description provided for @failureDeleteFavorite.
  ///
  /// In en, this message translates to:
  /// **'Could not remove favorite'**
  String get failureDeleteFavorite;

  /// No description provided for @failureSaveAddress.
  ///
  /// In en, this message translates to:
  /// **'Could not save address'**
  String get failureSaveAddress;

  /// No description provided for @failureDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Could not delete address'**
  String get failureDeleteAddress;

  /// No description provided for @failureSaveMeetingHistory.
  ///
  /// In en, this message translates to:
  /// **'Could not save meeting history'**
  String get failureSaveMeetingHistory;

  /// No description provided for @failureServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable'**
  String get failureServiceUnavailable;

  /// No description provided for @failurePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied for this operation'**
  String get failurePermissionDenied;

  /// No description provided for @failureGeocodingTimeout.
  ///
  /// In en, this message translates to:
  /// **'Geocoding timed out'**
  String get failureGeocodingTimeout;

  /// No description provided for @failureGeocodingRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many geocoding requests'**
  String get failureGeocodingRateLimit;

  /// No description provided for @failureGeocodingHttp.
  ///
  /// In en, this message translates to:
  /// **'Geocoding request failed'**
  String get failureGeocodingHttp;

  /// No description provided for @failureGeocodingUnknown.
  ///
  /// In en, this message translates to:
  /// **'Could not geocode the address'**
  String get failureGeocodingUnknown;

  /// No description provided for @failureRoomStream.
  ///
  /// In en, this message translates to:
  /// **'Lost connection to the room. Check your network.'**
  String get failureRoomStream;

  /// No description provided for @failureRoutingTimeout.
  ///
  /// In en, this message translates to:
  /// **'Route calculation timed out'**
  String get failureRoutingTimeout;

  /// No description provided for @failureRoutingFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not build a route between the addresses'**
  String get failureRoutingFailed;

  /// No description provided for @presenceWaitingPartnerJoin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your partner to join.\nShare the invite link or room code.'**
  String get presenceWaitingPartnerJoin;

  /// No description provided for @presenceWaitingPartnerAddress.
  ///
  /// In en, this message translates to:
  /// **'Partner joined. Waiting for their address.'**
  String get presenceWaitingPartnerAddress;

  /// No description provided for @presenceWaitingYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address to continue.'**
  String get presenceWaitingYourAddress;

  /// No description provided for @presenceWaitingYourFormats.
  ///
  /// In en, this message translates to:
  /// **'Pick meeting formats you are open to.'**
  String get presenceWaitingYourFormats;

  /// No description provided for @presenceWaitingPartnerFormats.
  ///
  /// In en, this message translates to:
  /// **'Waiting for partner to pick meeting formats.'**
  String get presenceWaitingPartnerFormats;

  /// No description provided for @presenceWaitingYourFormatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm a shared meeting format.'**
  String get presenceWaitingYourFormatConfirm;

  /// No description provided for @presenceWaitingPartnerFormatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Waiting for partner to confirm the format.'**
  String get presenceWaitingPartnerFormatConfirm;

  /// No description provided for @routingDegradedBanner.
  ///
  /// In en, this message translates to:
  /// **'Route service is unavailable. Showing a simplified midpoint — tap Retry for a full route.'**
  String get routingDegradedBanner;

  /// No description provided for @failureActionEditAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit the address and try again, or tap Retry.'**
  String get failureActionEditAddress;

  /// No description provided for @failureActionResubscribeRoom.
  ///
  /// In en, this message translates to:
  /// **'Tap Retry to reconnect to the room.'**
  String get failureActionResubscribeRoom;

  /// No description provided for @failureActionRetryMeeting.
  ///
  /// In en, this message translates to:
  /// **'Tap Retry to recalculate the meeting point.'**
  String get failureActionRetryMeeting;

  /// No description provided for @shareInviteLabel.
  ///
  /// In en, this message translates to:
  /// **'Share invite'**
  String get shareInviteLabel;

  /// No description provided for @shareInviteMessage.
  ///
  /// In en, this message translates to:
  /// **'Join my Date Navigation room with code {code}:\n{link}'**
  String shareInviteMessage(String code, String link);

  /// No description provided for @inviteInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite unavailable'**
  String get inviteInvalidTitle;

  /// No description provided for @inviteInvalidMessage.
  ///
  /// In en, this message translates to:
  /// **'This invite code is invalid or expired. Ask for a new code.'**
  String get inviteInvalidMessage;

  /// No description provided for @searchRegionLabel.
  ///
  /// In en, this message translates to:
  /// **'Search region'**
  String get searchRegionLabel;

  /// No description provided for @searchRegionGlobal.
  ///
  /// In en, this message translates to:
  /// **'Worldwide'**
  String get searchRegionGlobal;

  /// No description provided for @searchRegionMinsk.
  ///
  /// In en, this message translates to:
  /// **'Minsk'**
  String get searchRegionMinsk;

  /// No description provided for @noResultsInRadiusHint.
  ///
  /// In en, this message translates to:
  /// **'Try increasing the search radius, clearing the category filter, or changing the meeting format.'**
  String get noResultsInRadiusHint;

  /// No description provided for @showAllCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Show all categories'**
  String get showAllCategoriesLabel;

  /// No description provided for @increaseRadiusHint.
  ///
  /// In en, this message translates to:
  /// **'Increase radius and retry'**
  String get increaseRadiusHint;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'Date Navigation stores your account profile, room participation, favorites, and meeting history in Firebase to sync collaborative planning.\n\nAddresses and coordinates are written only to rooms you join. You can delete your account and associated personal data from the Profile screen.\n\nLocation services are used only when you submit an address for geocoding. Analytics and crash diagnostics are collected in release builds.'**
  String get privacyBody;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your Firebase account, favorites, history, and address memory. Rooms you created are not force-deleted for the partner.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the account. Sign in again and retry.'**
  String get deleteAccountFailed;

  /// No description provided for @storeReadyChecklistNote.
  ///
  /// In en, this message translates to:
  /// **'Permissions: Internet only. No continuous GPS tracking. Data safety: account + room sync via Firebase.'**
  String get storeReadyChecklistNote;

  /// No description provided for @openSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Open sessions'**
  String get openSessionsTitle;

  /// No description provided for @openSessionsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create session'**
  String get openSessionsCreate;

  /// No description provided for @openSessionsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get openSessionsRefresh;

  /// No description provided for @openSessionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No open sessions yet. Create one and invite people.'**
  String get openSessionsEmpty;

  /// No description provided for @openSessionsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load open sessions'**
  String get openSessionsLoadFailed;

  /// No description provided for @openSessionsCapacity.
  ///
  /// In en, this message translates to:
  /// **'Max people'**
  String get openSessionsCapacity;

  /// No description provided for @openSessionNoEvent.
  ///
  /// In en, this message translates to:
  /// **'Open session'**
  String get openSessionNoEvent;

  /// No description provided for @openSessionMembers.
  ///
  /// In en, this message translates to:
  /// **'{count} of {capacity}'**
  String openSessionMembers(int count, int capacity);

  /// No description provided for @openSessionJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get openSessionJoin;

  /// No description provided for @openSessionFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get openSessionFull;

  /// No description provided for @openSessionsEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get openSessionsEvent;

  /// No description provided for @openSessionsEventNone.
  ///
  /// In en, this message translates to:
  /// **'No event'**
  String get openSessionsEventNone;

  /// No description provided for @openSessionsEventsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Event catalog is unavailable. Create a session without an event.'**
  String get openSessionsEventsUnavailable;

  /// No description provided for @openEventRoute.
  ///
  /// In en, this message translates to:
  /// **'Route to event'**
  String get openEventRoute;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get chatInputHint;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatEmpty;

  /// No description provided for @chatLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load messages'**
  String get chatLoadFailed;

  /// No description provided for @chatSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send message'**
  String get chatSendFailed;

  /// No description provided for @chatOpen.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatOpen;

  /// No description provided for @chatLoadOlder.
  ///
  /// In en, this message translates to:
  /// **'Load older'**
  String get chatLoadOlder;

  /// No description provided for @systemParticipantJoined.
  ///
  /// In en, this message translates to:
  /// **'Participant joined'**
  String get systemParticipantJoined;

  /// No description provided for @systemFormatConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Meeting format confirmed'**
  String get systemFormatConfirmed;

  /// No description provided for @systemPlaceSelected.
  ///
  /// In en, this message translates to:
  /// **'Place selected'**
  String get systemPlaceSelected;

  /// No description provided for @openSessionTabParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get openSessionTabParticipants;

  /// No description provided for @openSessionTabPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get openSessionTabPlan;

  /// No description provided for @openSessionTabChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get openSessionTabChat;

  /// No description provided for @openSessionEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get openSessionEnterAddress;

  /// No description provided for @openSessionAddressSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Your address'**
  String get openSessionAddressSheetTitle;

  /// No description provided for @openSessionAddressSheetHint.
  ///
  /// In en, this message translates to:
  /// **'The address is needed so participants can see your point'**
  String get openSessionAddressSheetHint;

  /// No description provided for @openSessionParticipantSelf.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get openSessionParticipantSelf;

  /// No description provided for @openSessionParticipantHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get openSessionParticipantHost;

  /// No description provided for @openSessionParticipantNumber.
  ///
  /// In en, this message translates to:
  /// **'Participant {number}'**
  String openSessionParticipantNumber(Object number);

  /// No description provided for @openSessionAddressSet.
  ///
  /// In en, this message translates to:
  /// **'address set'**
  String get openSessionAddressSet;

  /// No description provided for @openSessionAddressNotSet.
  ///
  /// In en, this message translates to:
  /// **'address not set'**
  String get openSessionAddressNotSet;

  /// No description provided for @openSessionLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get openSessionLeave;

  /// No description provided for @openSessionPlanFromEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get openSessionPlanFromEvent;

  /// No description provided for @openSessionEmptyParticipants.
  ///
  /// In en, this message translates to:
  /// **'Nobody here yet'**
  String get openSessionEmptyParticipants;

  /// No description provided for @openSessionParticipantMember.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get openSessionParticipantMember;

  /// No description provided for @failureLeaveRoom.
  ///
  /// In en, this message translates to:
  /// **'Could not leave the session. Try again.'**
  String get failureLeaveRoom;

  /// No description provided for @systemParticipantLeft.
  ///
  /// In en, this message translates to:
  /// **'Participant left'**
  String get systemParticipantLeft;

  /// No description provided for @openSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get openSessionComplete;

  /// No description provided for @openSessionCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'End the session?'**
  String get openSessionCompleteTitle;

  /// No description provided for @openSessionCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'The chat becomes read-only and joining is closed.'**
  String get openSessionCompleteBody;

  /// No description provided for @openSessionCompleteAction.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get openSessionCompleteAction;

  /// No description provided for @openSessionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get openSessionCancel;

  /// No description provided for @chatReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Session ended: read-only'**
  String get chatReadOnlyHint;

  /// No description provided for @openSessionClosedHint.
  ///
  /// In en, this message translates to:
  /// **'Session ended. Chat is read-only, joining is closed.'**
  String get openSessionClosedHint;

  /// No description provided for @failureHostAlone.
  ///
  /// In en, this message translates to:
  /// **'You are the only participant. End the session to leave.'**
  String get failureHostAlone;

  /// No description provided for @openSessionHostAlone.
  ///
  /// In en, this message translates to:
  /// **'To leave, end the session: you are the only participant'**
  String get openSessionHostAlone;

  /// No description provided for @systemHostTransferred.
  ///
  /// In en, this message translates to:
  /// **'Host transferred to a participant'**
  String get systemHostTransferred;

  /// No description provided for @openSessionExpiredHint.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Chat is read-only, joining is closed.'**
  String get openSessionExpiredHint;

  /// No description provided for @profileEditName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get profileEditName;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileNameLabel;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'How others see you'**
  String get profileNameHint;

  /// No description provided for @profilePhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo from gallery'**
  String get profilePhotoGallery;

  /// No description provided for @profilePhotoPreset.
  ///
  /// In en, this message translates to:
  /// **'Built-in avatar'**
  String get profilePhotoPreset;

  /// No description provided for @profilePhotoGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google photo'**
  String get profilePhotoGoogle;

  /// No description provided for @profileAvatarTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the photo. Choose another one.'**
  String get profileAvatarTooLarge;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the profile'**
  String get profileSaveError;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileChooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose an avatar'**
  String get profileChooseAvatar;

  /// No description provided for @planNextStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Next place'**
  String get planNextStepTitle;

  /// No description provided for @planNotChosen.
  ///
  /// In en, this message translates to:
  /// **'No place chosen yet'**
  String get planNotChosen;

  /// No description provided for @planSuggestButton.
  ///
  /// In en, this message translates to:
  /// **'Suggest a place'**
  String get planSuggestButton;

  /// No description provided for @planSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get planSuggestionsTitle;

  /// No description provided for @planChooseButton.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get planChooseButton;

  /// No description provided for @planChosenLabel.
  ///
  /// In en, this message translates to:
  /// **'Chosen'**
  String get planChosenLabel;

  /// No description provided for @planEmptySuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions yet'**
  String get planEmptySuggestions;

  /// No description provided for @planRadiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Radius from the event'**
  String get planRadiusLabel;

  /// No description provided for @planRadiusOption.
  ///
  /// In en, this message translates to:
  /// **'{meters} m'**
  String planRadiusOption(Object meters);

  /// No description provided for @planSuggestNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Place name'**
  String get planSuggestNameLabel;

  /// No description provided for @planSuggestAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get planSuggestAddressLabel;

  /// No description provided for @planSuggestSubmit.
  ///
  /// In en, this message translates to:
  /// **'Suggest'**
  String get planSuggestSubmit;

  /// No description provided for @planAddressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get planAddressNotFound;

  /// No description provided for @planTooFar.
  ///
  /// In en, this message translates to:
  /// **'The place is farther than {meters} m from the event venue'**
  String planTooFar(Object meters);

  /// No description provided for @planSuggestLimit.
  ///
  /// In en, this message translates to:
  /// **'You can suggest at most 5 places per hour'**
  String get planSuggestLimit;

  /// No description provided for @planSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the plan. Try again.'**
  String get planSaveFailed;

  /// No description provided for @planProposedBy.
  ///
  /// In en, this message translates to:
  /// **'from {name}'**
  String planProposedBy(Object name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
