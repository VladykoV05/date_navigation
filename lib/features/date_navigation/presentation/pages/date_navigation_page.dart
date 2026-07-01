import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/failure.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/theme/ui_tokens.dart';
import '../../../../core/utils/place_type_localizer.dart';
import '../../../../core/utils/show_notification.dart';
import '../../../user_profile/user_profile.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../widgets/date_navigation_account_menu.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/date_navigation_map_consumer_section.dart';
import '../widgets/date_navigation_map_overlay.dart';
import '../widgets/date_navigation_room_body_consumer_section.dart';
import '../widgets/date_navigation_status_banners.dart';
import '../widgets/join_room_dialog.dart';
import '../widgets/place_actions_sheet.dart';
import '../widgets/ui_copy.dart';
import '../controllers/date_navigation_controller.dart';
import '../providers/date_navigation_provider.dart';
import '../state/date_navigation_state.dart';

part 'date_navigation_page_dialogs.dart';
part 'date_navigation_page_map.dart';
part 'date_navigation_page_layout.dart';

class DateNavigationPage extends ConsumerStatefulWidget {
  const DateNavigationPage({super.key});

  @override
  ConsumerState<DateNavigationPage> createState() => _DateNavigationPageState();
}

class _DateNavigationPageState extends ConsumerState<DateNavigationPage>
    with TickerProviderStateMixin {
  static const double _sheetMaxNoRoom = 0.4;
  static const double _sheetMaxNoCards = 0.5;
  static const double _sheetMaxWithCards = 0.9;
  static const double _sheetUpperClamp = 0.95;
  static const EdgeInsets _fitAllPointsPadding = EdgeInsets.only(
    top: 90,
    left: 40,
    right: 40,
    bottom: 260,
  );
  static const int _radiusSuggestionReminderSeconds = 45;
  static const double _coordEpsilon = 0.0000001;
  static const double _zoomRotationEpsilon = 0.0001;
  static const double _addressFocusZoom = 14.5;
  static const double _centerFocusZoom = 13.8;
  static const double _finalVenueZoom = 16.2;
  static const double _sheetMinChildSize = 0.15;
  static const double _sheetInitialChildSize = 0.35;
  static const double _accountMenuInset = 14;
  static const int _sheetAnimationMs = 180;
  static const double _sheetCornerRadius = 24;
  static const double _dragHandleVerticalMargin = 12;
  static const double _dragHandleWidth = 40;
  static const double _dragHandleHeight = 4;
  static const double _sheetClampEpsilon = 0.005;
  static const double _sheetClampUpperBound = 1.0;

  final _addressCtrl = TextEditingController();
  final _mapController = MapController();
  final _sheetController = DraggableScrollableController();
  final _navigationService = NavigationService();
  ProviderSubscription<DateNavigationState>? _stateSubscription;
  late final AnimationController _mapAnimationController;
  double _lastSheetMaxSize = 0.5;
  double _lastSheetExtent = _sheetInitialChildSize;
  bool _isSubmittingAddress = false;
  final Set<_DialogType> _activeDialogs = <_DialogType>{};
  Timer? _radiusSuggestionReminderTimer;

  @override
  void initState() {
    super.initState();
    _mapAnimationController = AnimationController(vsync: this);
    _stateSubscription = ref.listenManual(
      dateNavigationControllerProvider,
      _onStateChanged,
    );
  }

  void _onStateChanged(
    DateNavigationState? previous,
    DateNavigationState next,
  ) {
    if (!mounted) return;
    _handleFailureNotifications(previous, next);
    _handlePartnerSuggestions(previous, next);
    _handleMapFocusReactions(previous, next);
  }

  void _handleFailureNotifications(
    DateNavigationState? previous,
    DateNavigationState next,
  ) {
    if (next.ui.lastFailure != null &&
        next.ui.lastFailure != previous?.ui.lastFailure) {
      _showInfoSnackBar(_humanizeFailure(next.ui.lastFailure!));
    }
    if (next.meeting.creatorChangedRadiusTo != null &&
        next.meeting.creatorChangedRadiusTo !=
            previous?.meeting.creatorChangedRadiusTo &&
        !next.room.isCreator) {
      _showInfoSnackBar(
        UiCopy.creatorChangedRadius.replaceAll(
          '{radius}',
          '${next.meeting.creatorChangedRadiusTo}',
        ),
      );
    }
  }

  void _handlePartnerSuggestions(
    DateNavigationState? previous,
    DateNavigationState next,
  ) {
    final nextPeerSuggestedRadius = next.meeting.peerSuggestedRadius;
    final prevPeerSuggestedRadius = previous?.meeting.peerSuggestedRadius;
    if (nextPeerSuggestedRadius != null &&
        nextPeerSuggestedRadius > 0 &&
        nextPeerSuggestedRadius != prevPeerSuggestedRadius) {
      _radiusSuggestionReminderTimer?.cancel();
      unawaited(_showPeerRadiusSuggestionDialog(nextPeerSuggestedRadius));
    }

    final myRole = next.room.isCreator ? 'creator' : 'partner';
    final isPendingPartnerProposal =
        next.voting.proposalPlaceName != null &&
        (next.voting.proposalStatus?.isPending ?? false) &&
        next.meeting.finalChoiceName == null &&
        next.voting.proposalByRole != myRole;
    final proposalJustChanged =
        next.voting.proposalPlaceName != previous?.voting.proposalPlaceName ||
        next.voting.proposalStatus != previous?.voting.proposalStatus ||
        next.voting.proposalByRole != previous?.voting.proposalByRole;
    if (isPendingPartnerProposal && proposalJustChanged) {
      unawaited(
        _showProposalDecisionDialog(
          placeName: next.voting.proposalPlaceName!,
          placeAddress: next.voting.proposalPlaceAddress,
          placeType: next.voting.proposalPlaceType,
        ),
      );
    }

    final isPendingPartnerRevoteRequest =
        (next.meeting.meetingRevoteRequestStatus?.isPending ?? false) &&
        next.meeting.meetingRevoteRequestByRole != null &&
        next.meeting.meetingRevoteRequestByRole != myRole;
    final revoteRequestJustChanged =
        next.meeting.meetingRevoteRequestStatus !=
            previous?.meeting.meetingRevoteRequestStatus ||
        next.meeting.meetingRevoteRequestByRole !=
            previous?.meeting.meetingRevoteRequestByRole;
    if (isPendingPartnerRevoteRequest && revoteRequestJustChanged) {
      unawaited(_showMeetingRevoteDecisionDialog());
    }
  }

  void _handleMapFocusReactions(
    DateNavigationState? previous,
    DateNavigationState next,
  ) {
    final hasAllPoints =
        next.room.point1 != null &&
        next.room.point2 != null &&
        next.meeting.centerPoint != null;
    final myPrevPoint = previous?.myPoint(previous.room.isCreator);
    final myNextPoint = next.myPoint(next.room.isCreator);
    final myPointChanged =
        myNextPoint != null &&
        (myPrevPoint == null ||
            myPrevPoint.latitude != myNextPoint.latitude ||
            myPrevPoint.longitude != myNextPoint.longitude);
    if (myPointChanged && next.meeting.centerPoint == null) {
      _focusOnAddressPoint(myNextPoint);
    }
    if (hasAllPoints &&
        next.meeting.centerPoint != previous?.meeting.centerPoint) {
      _focusOnCenter(next.meeting.centerPoint!);
    }
    final nextFinalChoicePlace = next.meeting.finalChoicePlace;
    final prevFinalChoicePlace = previous?.meeting.finalChoicePlace;
    final nextChoice = next.meeting.finalChoiceName;
    final prevChoice = previous?.meeting.finalChoiceName;
    if (nextFinalChoicePlace != null &&
        (prevFinalChoicePlace == null ||
            prevFinalChoicePlace.lat != nextFinalChoicePlace.lat ||
            prevFinalChoicePlace.lon != nextFinalChoicePlace.lon ||
            prevChoice != nextChoice)) {
      _focusOnChosenVenue(nextFinalChoicePlace);
    }
  }

  @override
  void dispose() {
    _radiusSuggestionReminderTimer?.cancel();
    _mapAnimationController.dispose();
    _stateSubscription?.close();
    _addressCtrl.dispose();
    _mapController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(dateNavigationControllerProvider.notifier);
    final rawSheetMaxChildSize = ref.watch(
      dateNavigationControllerProvider.select((s) {
        final hasRoom = s.room.roomId != null;
        if (!hasRoom) return _sheetMaxNoRoom;

        final venueLocked = s.meeting.finalChoiceName?.isNotEmpty ?? false;
        final hasPlaceCards = venueLocked
            ? s.meeting.finalChoicePlace != null
            : s.meeting.filteredPlaces.isNotEmpty;
        return hasPlaceCards ? _sheetMaxWithCards : _sheetMaxNoCards;
      }),
    );
    final sheetMaxChildSize = rawSheetMaxChildSize.clamp(
      _sheetMinChildSize + 0.05,
      _sheetUpperClamp,
    );
    _stabilizeSheetExtent(sheetMaxChildSize);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          unawaited(_handleBackNavigation());
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: _buildPageBody(controller, sheetMaxChildSize),
      ),
    );
  }

  Future<void> _submitAddress(DateNavigationController controller) async {
    if (_isSubmittingAddress) return;
    final text = _addressCtrl.text.trim();
    if (text.isEmpty) return;
    _isSubmittingAddress = true;
    try {
      final success = await controller.submitMyAddress(text);
      if (success) {
        _addressCtrl.clear();
      }
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    } finally {
      _isSubmittingAddress = false;
    }
  }

  void _onAddressSuggestionSelected({
    required DateNavigationController controller,
    required String address,
  }) {
    if (_isSubmittingAddress) return;
    _addressCtrl.text = address;
    _addressCtrl.selection = TextSelection.collapsed(offset: address.length);
    FocusScope.of(context).unfocus();
    unawaited(_submitAddress(controller));
  }

  void _showJoinDialog() {
    showJoinRoomDialog(
      context: context,
      onJoinCode: (code) {
        ref.read(dateNavigationControllerProvider.notifier).joinRoom(code);
      },
    );
  }

  void _showPlaceDetails(Place place) {
    final state = ref.read(dateNavigationControllerProvider);
    final myPoint = state.myPoint(state.room.isCreator);
    final partnerPoint = state.partnerPoint(state.room.isCreator);
    final venueLocked =
        state.meeting.finalChoiceName != null &&
        state.meeting.finalChoiceName!.isNotEmpty;
    final isFavorite = ref.read(
      favoritesControllerProvider.select(
        (state) => state.containsPlace(
          placeName: place.name,
          lat: place.lat,
          lon: place.lon,
        ),
      ),
    );

    showPlaceActionsSheet(
      context: context,
      place: place,
      myPoint: myPoint,
      partnerPoint: partnerPoint,
      isFavorite: isFavorite,
      navigationService: _navigationService,
      canProposePlace: !venueLocked,
      onToggleFavorite: () async {
        await ref
            .read(favoritesControllerProvider.notifier)
            .toggleFavorite(
              placeName: place.name,
              placeAddress: place.address,
              placeType: place.type,
              lat: place.lat,
              lon: place.lon,
            );
      },
      onProposePlace: () async {
        await ref
            .read(dateNavigationControllerProvider.notifier)
            .proposePlace(place);
      },
    );
  }

  String _loadingMessageFromFlags({
    required bool isGeocoding,
    required bool isCalculatingMeeting,
    required bool isLoadingRoomAction,
  }) {
    if (isGeocoding) return UiCopy.loadingGeocoding;
    if (isCalculatingMeeting) return UiCopy.loadingMeeting;
    if (isLoadingRoomAction) return UiCopy.loadingRoomSync;
    return UiCopy.loadingGeneric;
  }

  String _humanizeFailure(Failure failure) {
    return switch (failure) {
      TimeoutFailure() =>
        'Сервер долго отвечает. Попробуй ещё раз через пару секунд.',
      RateLimitFailure() =>
        'Слишком много запросов. Подожди немного и повтори.',
      NetworkFailure() =>
        'Проблема с сетью или доступом. Проверь интернет и попробуй снова.',
      ParseFailure() =>
        'Получили неожиданный ответ сервера. Попробуй повторить.',
      UnknownFailure() => failure.message,
    };
  }
}

enum _DialogType { peerRadiusSuggestion, partnerPlaceProposal, meetingRevote }
