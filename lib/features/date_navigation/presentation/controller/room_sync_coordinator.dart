import 'package:latlong2/latlong.dart' as latlong;

import '../../domain/entities/place.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../domain/entities/room_status.dart';
import '../state/date_navigation_state.dart';
import 'meeting_planner_coordinator.dart';

class RoomSyncOutcome {
  const RoomSyncOutcome({
    required this.nextState,
    required this.pointsChanged,
    required this.isCreator,
    required this.venueLocked,
    required this.hasSnapshot,
    required this.snapshotUpdatedAt,
    required this.point1,
    required this.point2,
    required this.snapshotRadius,
    required this.snapshotMatchesFormat,
  });

  final DateNavigationState nextState;
  final bool pointsChanged;
  final bool isCreator;
  final bool venueLocked;
  final bool hasSnapshot;
  final DateTime? snapshotUpdatedAt;
  final latlong.LatLng? point1;
  final latlong.LatLng? point2;
  final int? snapshotRadius;
  final bool snapshotMatchesFormat;
}

class RoomSyncCoordinator {
  const RoomSyncCoordinator();

  RoomSyncOutcome buildOutcome({
    required DateNavigationState currentState,
    required RoomSnapshot roomSnapshot,
    required String userId,
    required MeetingPlannerCoordinator meetingPlanner,
  }) {
    final nextPoint1 = roomSnapshot.point1;
    final nextPoint2 = roomSnapshot.point2;
    final votes = roomSnapshot.votes;

    final filteredFromCurrent = meetingPlanner.computeFilteredPlaces(
      places: currentState.foundPlaces,
      point1: nextPoint1,
      point2: nextPoint2,
      selectedType: currentState.selectedType,
      centerPoint: currentState.centerPoint,
      searchRadius: currentState.searchRadius,
      meetingFormat: currentState.selectedMeetingFormat,
    );

    final oldPoint1 = currentState.point1;
    final oldPoint2 = currentState.point2;

    final isCreator = roomSnapshot.creatorUid == userId;
    final meetingSnapshot = roomSnapshot.meetingSnapshot;
    final snapshotCenter = meetingSnapshot.center;
    final snapshotPlaces = meetingSnapshot.places;
    final snapshotRoute = meetingSnapshot.routePoints;
    final snapshotUpdatedAt = meetingSnapshot.updatedAt;
    final selectedScenario = roomSnapshot.selectedScenario;
    final hasSnapshot = snapshotCenter != null && snapshotPlaces.isNotEmpty;
    final snapshotRadius = meetingSnapshot.searchRadius;
    final rawSessionStatus = roomSnapshot.sessionStatus;
    final expiresAt = roomSnapshot.expiresAt;
    final isExpiredByTime =
        rawSessionStatus.isActive &&
        expiresAt != null &&
        expiresAt.isBefore(DateTime.now());
    final sessionStatus = isExpiredByTime
        ? SessionStatus.expired
        : rawSessionStatus;
    final creatorMeetingFormats = roomSnapshot.creatorMeetingFormats;
    final partnerMeetingFormats = roomSnapshot.partnerMeetingFormats;
    final creatorSelectedMeetingFormat =
        roomSnapshot.creatorSelectedMeetingFormat;
    final partnerSelectedMeetingFormat =
        roomSnapshot.partnerSelectedMeetingFormat;
    final agreedMeetingFormat =
        creatorSelectedMeetingFormat != null &&
            creatorSelectedMeetingFormat == partnerSelectedMeetingFormat
        ? creatorSelectedMeetingFormat
        : null;
    final lastAgreedMeetingFormat =
        agreedMeetingFormat ?? currentState.lastAgreedMeetingFormat;
    final snapshotMeetingFormat = meetingSnapshot.meetingFormat;
    final snapshotMatchesFormat =
        agreedMeetingFormat != null &&
        snapshotMeetingFormat != null &&
        snapshotMeetingFormat == agreedMeetingFormat;
    final syncedRadius = snapshotRadius != null && snapshotRadius > 0
        ? snapshotRadius.toDouble()
        : currentState.searchRadius;
    final creatorSearchRadius = roomSnapshot.creatorSearchRadius;
    final partnerSearchRadius = roomSnapshot.partnerSearchRadius;
    final creatorRadiusUpdatedAt = roomSnapshot.creatorSearchRadiusUpdatedAt;
    final partnerRadiusUpdatedAt = roomSnapshot.partnerSearchRadiusUpdatedAt;
    final myPreferredRadius = (isCreator
        ? creatorSearchRadius
        : partnerSearchRadius);
    final peerPreferredRadius = (isCreator
        ? partnerSearchRadius
        : creatorSearchRadius);
    final myRadiusUpdatedAt = isCreator
        ? creatorRadiusUpdatedAt
        : partnerRadiusUpdatedAt;
    final peerRadiusUpdatedAt = isCreator
        ? partnerRadiusUpdatedAt
        : creatorRadiusUpdatedAt;
    final resolvedSearchRadius =
        myPreferredRadius != null && myPreferredRadius > 0
        ? myPreferredRadius.toDouble()
        : syncedRadius;
    final peerSuggestedRadius =
        peerPreferredRadius != null &&
            peerPreferredRadius > 0 &&
            peerPreferredRadius != resolvedSearchRadius.round() &&
            peerRadiusUpdatedAt != null &&
            (myRadiusUpdatedAt == null ||
                peerRadiusUpdatedAt.isAfter(myRadiusUpdatedAt))
        ? peerPreferredRadius
        : null;
    final meetingRevoteRequestByRole =
        roomSnapshot.meetingRevoteRequest.requestedBy;
    final meetingRevoteRequestStatus = roomSnapshot.meetingRevoteRequest.status;

    final finalChoiceName = roomSnapshot.finalChoice.name;
    final lookupForFinalChoice = <Place>[
      ...snapshotPlaces,
      ...currentState.foundPlaces,
    ];
    final resolvedFinalPlace = finalChoiceName == null
        ? null
        : roomSnapshot.finalChoice.resolvePlace(lookupForFinalChoice);
    final venueLocked = finalChoiceName != null;

    late final latlong.LatLng? nextCenter;
    late final List<Place> nextFound;
    late final List<latlong.LatLng> nextRoute;
    late final List<Place> nextFiltered;

    if (venueLocked) {
      nextCenter = hasSnapshot ? snapshotCenter : currentState.centerPoint;
      nextFound = const [];
      nextRoute = const [];
      nextFiltered = const [];
    } else if (agreedMeetingFormat == null) {
      // Пока формат не согласован, этап мест должен быть пустым.
      nextCenter = null;
      nextFound = const [];
      nextRoute = const [];
      nextFiltered = const [];
    } else if (hasSnapshot && snapshotMatchesFormat) {
      nextCenter = snapshotCenter;
      nextFound = snapshotPlaces;
      nextRoute = snapshotRoute;
      nextFiltered = meetingPlanner.computeFilteredPlaces(
        places: snapshotPlaces,
        point1: nextPoint1,
        point2: nextPoint2,
        selectedType: currentState.selectedType,
        centerPoint: snapshotCenter,
        // Use the user's resolved radius, not snapshot radius,
        // so UI immediately reflects radius decrease.
        searchRadius: resolvedSearchRadius,
        meetingFormat: agreedMeetingFormat,
      );
    } else {
      final formatChanged =
          currentState.selectedMeetingFormat != agreedMeetingFormat;
      if (formatChanged) {
        // Never keep stale places when agreed format changed.
        nextCenter = null;
        nextFound = const [];
        nextRoute = const [];
        nextFiltered = const [];
      } else {
        nextCenter = currentState.centerPoint;
        nextFound = currentState.foundPlaces;
        nextRoute = currentState.routePoints;
        nextFiltered = filteredFromCurrent;
      }
    }

    final pointsChanged =
        (nextPoint1?.latitude != oldPoint1?.latitude) ||
        (nextPoint1?.longitude != oldPoint1?.longitude) ||
        (nextPoint2?.latitude != oldPoint2?.latitude) ||
        (nextPoint2?.longitude != oldPoint2?.longitude);

    final nextState = currentState.copyWith(
      isCreator: isCreator,
      point1: nextPoint1,
      point2: nextPoint2,
      finalChoiceName: finalChoiceName,
      finalChoicePlace: venueLocked ? resolvedFinalPlace : null,
      proposalPlaceName: roomSnapshot.proposal.placeName,
      proposalPlaceAddress: roomSnapshot.proposal.placeAddress,
      proposalPlaceType: roomSnapshot.proposal.placeType,
      proposalByRole: roomSnapshot.proposal.proposedBy,
      proposalStatus: roomSnapshot.proposal.status,
      votesByUser: votes,
      voteCounts: _buildVoteCounts(votes),
      centerPoint: nextCenter,
      foundPlaces: nextFound,
      routePoints: nextRoute,
      filteredPlaces: nextFiltered,
      searchRadius: resolvedSearchRadius,
      creatorChangedRadiusTo: null,
      peerSuggestedRadius: venueLocked ? null : peerSuggestedRadius,
      peerSuggestedMeetingFormat: null,
      lastFailure: venueLocked || hasSnapshot ? null : currentState.lastFailure,
      failureOperation: venueLocked || hasSnapshot
          ? null
          : currentState.failureOperation,
      sessionStatus: sessionStatus,
      creatorMeetingFormats: creatorMeetingFormats,
      partnerMeetingFormats: partnerMeetingFormats,
      creatorSelectedMeetingFormat: creatorSelectedMeetingFormat,
      partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
      selectedMeetingFormat: agreedMeetingFormat,
      lastAgreedMeetingFormat: lastAgreedMeetingFormat,
      selectedScenario: selectedScenario,
      meetingRevoteRequestByRole: meetingRevoteRequestByRole,
      meetingRevoteRequestStatus: meetingRevoteRequestStatus,
    );

    return RoomSyncOutcome(
      nextState: nextState,
      pointsChanged: pointsChanged,
      isCreator: isCreator,
      venueLocked: venueLocked,
      hasSnapshot: hasSnapshot,
      snapshotUpdatedAt: snapshotUpdatedAt,
      point1: nextPoint1,
      point2: nextPoint2,
      snapshotRadius: snapshotRadius,
      snapshotMatchesFormat: snapshotMatchesFormat,
    );
  }

  Map<String, int> _buildVoteCounts(Map<String, String> votes) {
    final counts = <String, int>{};
    for (final placeName in votes.values) {
      counts[placeName] = (counts[placeName] ?? 0) + 1;
    }
    return counts;
  }
}
