import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/deep_links/invite_deep_link_controller.dart';
import '../../../../core/di/app_services_di.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/ui_tokens.dart';
import '../../../../core/utils/show_notification.dart';
import '../../../../core_ui/core_ui.dart';
import '../mappers/geo_map_mapper.dart';
import '../mappers/place_view_mapper.dart';
import '../view_data/place_view_data.dart';
import '../../domain/entities/voting_decisions.dart';
import '../widgets/date_navigation_account_menu.dart';
import '../widgets/date_navigation_map_consumer_section.dart';
import '../widgets/date_navigation_map_overlay.dart';
import '../widgets/date_navigation_room_body_consumer_section.dart';
import '../widgets/date_navigation_status_banners.dart';
import '../widgets/join_room_dialog.dart';
import '../widgets/place_actions_sheet.dart';
import '../controllers/date_navigation_controller.dart';
import '../coordinators/date_navigation_page_side_effects.dart';
import '../providers/date_navigation_provider.dart';
import '../providers/meeting_favorites_provider.dart';
import '../../application/state/date_navigation_state.dart';
import '../../domain/value_objects/geo_coordinate.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _consumePendingInviteLink();
    });
  }

  void _consumePendingInviteLink() {
    if (!mounted) return;
    final code = ref
        .read(inviteDeepLinkControllerProvider.notifier)
        .takePendingCode();
    if (code == null) return;
    final hasRoom =
        ref.read(dateNavigationControllerProvider).room.roomId != null;
    if (hasRoom) return;
    unawaited(
      showJoinRoomDialog(
        context: context,
        initialCode: code,
        onJoinCode: (joinCode) {
          ref
              .read(dateNavigationControllerProvider.notifier)
              .joinRoom(joinCode);
        },
      ),
    );
  }

  void _onStateChanged(
    DateNavigationState? previous,
    DateNavigationState next,
  ) {
    if (!mounted) return;
    DateNavigationPageSideEffects(
      onFailure: (failure) {
        _showInfoSnackBar(context.l10n.localizeFailure(failure));
      },
      onCreatorChangedRadius: (radius) {
        _showInfoSnackBar(context.l10n.creatorChangedRadius(radius));
      },
      onPeerRadiusSuggestion: (radius) {
        _radiusSuggestionReminderTimer?.cancel();
        unawaited(_showPeerRadiusSuggestionDialog(radius));
      },
      onPartnerProposal: ({required placeName, placeAddress, placeType}) {
        unawaited(
          _showProposalDecisionDialog(
            placeName: placeName,
            placeAddress: placeAddress,
            placeType: placeType,
          ),
        );
      },
      onPartnerRevoteRequest: () {
        unawaited(_showMeetingRevoteDecisionDialog());
      },
      onFocusMyPoint: (state) {
        final point = state.myPoint(state.room.isCreator);
        if (point != null) _focusOnAddressPoint(point);
      },
      onFocusCenter: (state) {
        final center = state.meeting.centerPoint;
        if (center != null) _focusOnCenter(center);
      },
      onFocusFinalVenue: (state) {
        final place = state.meeting.finalChoicePlace;
        if (place != null) {
          _focusOnChosenVenue(PlaceViewMapper.fromPlace(place));
        }
      },
    ).handle(previous, next);
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
    ref.listen<String?>(inviteDeepLinkControllerProvider, (previous, next) {
      if (next != null && next != previous) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _consumePendingInviteLink();
        });
      }
    });
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

  void _showPlaceDetails(PlaceViewData place) {
    final state = ref.read(dateNavigationControllerProvider);
    final myPoint = state.myPoint(state.room.isCreator);
    final partnerPoint = state.partnerPoint(state.room.isCreator);
    final venueLocked =
        state.meeting.finalChoiceName != null &&
        state.meeting.finalChoiceName!.isNotEmpty;
    final isFavorite = ref.read(
      meetingFavoritesControllerProvider.select(
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
      navigationService: ref.read(navigationServiceProvider),
      canProposePlace: !venueLocked,
      onToggleFavorite: () async {
        await ref
            .read(meetingFavoritesControllerProvider.notifier)
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
            .proposePlace(PlaceViewMapper.toPlace(place));
      },
    );
  }

  String _loadingMessageFromFlags({
    required bool isGeocoding,
    required bool isCalculatingMeeting,
    required bool isLoadingRoomAction,
  }) {
    final l10n = context.l10n;
    if (isGeocoding) return l10n.loadingGeocoding;
    if (isCalculatingMeeting) return l10n.loadingMeeting;
    if (isLoadingRoomAction) return l10n.loadingRoomSync;
    return l10n.loadingGeneric;
  }
}

enum _DialogType { peerRadiusSuggestion, partnerPlaceProposal, meetingRevote }
