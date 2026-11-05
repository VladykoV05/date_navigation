/// Stable machine-readable failure codes.
/// UI maps them to localized strings via [AppCopy.localizeFailure].
abstract final class FailureCodes {
  static const userNotAuthenticated = 'user_not_authenticated';
  static const favoritesLoadFailed = 'favorites_load_failed';
  static const historyLoadFailed = 'history_load_failed';
  static const deleteAccountFailed = 'delete_account_failed';

  static const addressNotFound = 'address_not_found';
  static const saveAddressFailed = 'save_address_failed';
  static const deleteAddressFailed = 'delete_address_failed';

  static const roomNotFound = 'room_not_found';
  static const roomCodeExists = 'room_code_exists';
  static const roomCodeEmpty = 'room_code_empty';
  static const createRoomFailed = 'create_room_failed';
  static const createRoomRetry = 'create_room_retry';
  static const joinRoomFailed = 'join_room_failed';
  static const roomFull = 'room_full';
  static const roomCorrupt = 'room_corrupt';
  static const roomNotOpen = 'room_not_open';
  static const eventSourceUnavailable = 'event_source_unavailable';
  static const chatSendFailed = 'chat_send_failed';
  static const chatReadFailed = 'chat_read_failed';
  static const chatLoadFailed = 'chat_load_failed';
  static const roomCapacityInvalid = 'room_capacity_invalid';
  static const creatorUnresolved = 'creator_unresolved';
  static const notRoomMember = 'not_room_member';
  static const updateLocationFailed = 'update_location_failed';
  static const onlyCreatorCanEnd = 'only_creator_can_end';
  static const completeSessionFailed = 'complete_session_failed';
  static const leaveRoomFailed = 'leave_room_failed';
  static const profileSaveFailed = 'profile_save_failed';
  static const hostAlone = 'host_alone';

  static const meetingPointCalcFailed = 'meeting_point_calc_failed';
  static const formatMustBeCommon = 'format_must_be_common';
  static const formatNotSelected = 'format_not_selected';
  static const sessionAlreadyEnded = 'session_already_ended';
  static const pickFormatBeforePlace = 'pick_format_before_place';

  static const votingClosed = 'voting_closed';
  static const voteFailed = 'vote_failed';
  static const finalPlaceAlreadyChosen = 'final_place_already_chosen';
  static const proposePlaceFailed = 'propose_place_failed';
  static const respondProposalFailed = 'respond_proposal_failed';
  static const syncResultsFailed = 'sync_results_failed';
  static const saveScenarioFailed = 'save_scenario_failed';
  static const saveFormatFailed = 'save_format_failed';
  static const revoteAlreadyRequested = 'revote_already_requested';
  static const requestRevoteFailed = 'request_revote_failed';
  static const cannotConfirmOwnRevote = 'cannot_confirm_own_revote';
  static const processRevoteFailed = 'process_revote_failed';
  static const confirmFormatFailed = 'confirm_format_failed';
  static const saveRadiusFailed = 'save_radius_failed';

  static const saveFavoriteFailed = 'save_favorite_failed';
  static const deleteFavoriteFailed = 'delete_favorite_failed';
  static const saveMeetingHistoryFailed = 'save_meeting_history_failed';

  static const serviceUnavailable = 'service_unavailable';
  static const permissionDenied = 'permission_denied';
  static const geocodingTimeout = 'geocoding_timeout';
  static const geocodingRateLimit = 'geocoding_rate_limit';
  static const geocodingHttp = 'geocoding_http';
  static const geocodingUnknown = 'geocoding_unknown';

  static const roomStreamFailed = 'room_stream_failed';
  static const routingTimeout = 'routing_timeout';
  static const routingFailed = 'routing_failed';

  static const locationServiceDisabled = 'location_service_disabled';
  static const locationPermissionDenied = 'location_permission_denied';
  static const locationPermissionDeniedForever =
      'location_permission_denied_forever';
  static const locationUnavailable = 'location_unavailable';
  static const locationTimeout = 'location_timeout';
}
