import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../state/date_navigation_state.dart';
import 'meeting_planner_coordinator.dart';
import 'room_document_mapper.dart';

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
  const RoomSyncCoordinator(this._roomMapper);

  final RoomDocumentMapper _roomMapper;

  RoomSyncOutcome buildOutcome({
    required DateNavigationState currentState,
    required Map<String, dynamic> roomData,
    required String userId,
    required MeetingPlannerCoordinator meetingPlanner,
  }) {
    final nextPoint1 = _roomMapper.parseLatLng(roomData['point1']);
    final nextPoint2 = _roomMapper.parseLatLng(roomData['point2']);
    final proposalRaw = Map<String, dynamic>.from(roomData['proposal'] ?? {});
    final votesRaw = Map<String, dynamic>.from(roomData['votes'] ?? {});
    final votes = votesRaw.map((key, value) => MapEntry(key, value.toString()));
    final snapshotRaw = Map<String, dynamic>.from(
      roomData['meetingSnapshot'] ?? const <String, dynamic>{},
    );
    final meetingRevoteRequestRaw = Map<String, dynamic>.from(
      roomData['meetingRevoteRequest'] ?? const <String, dynamic>{},
    );

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

    final creatorUid = (roomData['creatorUid'] ?? '').toString();
    final isCreator = creatorUid == userId;
    final snapshotCenter = _roomMapper.parseLatLng(snapshotRaw['center']);
    final snapshotPlaces = _roomMapper.parsePlaces(snapshotRaw['places']);
    final snapshotRoute = _roomMapper.parseRoutePoints(
      snapshotRaw['routePoints'],
    );
    final snapshotUpdatedAt = _roomMapper.parseUpdatedAt(
      snapshotRaw['updatedAt'],
    );
    final selectedScenario = _roomMapper.parseSelectedScenario(
      roomData['selectedScenario'],
    );
    final hasSnapshot = snapshotCenter != null && snapshotPlaces.isNotEmpty;
    final snapshotRadius = (snapshotRaw['searchRadius'] as num?)?.toInt();
    final rawSessionStatus = (roomData['sessionStatus'] ?? 'active').toString();
    final expiresAtRaw = roomData['expiresAt'];
    final expiresAt = expiresAtRaw is Timestamp ? expiresAtRaw.toDate() : null;
    final isExpiredByTime =
        rawSessionStatus == 'active' &&
        expiresAt != null &&
        expiresAt.isBefore(DateTime.now());
    final sessionStatus = isExpiredByTime ? 'expired' : rawSessionStatus;
    final creatorMeetingFormats = _parseMeetingFormats(
      formatsRaw: roomData['creatorMeetingFormats'],
      legacyRaw: roomData['creatorMeetingFormat'],
    );
    final partnerMeetingFormats = _parseMeetingFormats(
      formatsRaw: roomData['partnerMeetingFormats'],
      legacyRaw: roomData['partnerMeetingFormat'],
    );
    final legacySelectedMeetingFormat = _parseMeetingFormat(
      roomData['selectedMeetingFormat'],
    );
    final creatorSelectedMeetingFormat =
        _parseMeetingFormat(roomData['creatorSelectedMeetingFormat']) ??
        legacySelectedMeetingFormat;
    final partnerSelectedMeetingFormat =
        _parseMeetingFormat(roomData['partnerSelectedMeetingFormat']) ??
        legacySelectedMeetingFormat;
    final agreedMeetingFormat =
        creatorSelectedMeetingFormat != null &&
            creatorSelectedMeetingFormat == partnerSelectedMeetingFormat
        ? creatorSelectedMeetingFormat
        : null;
    final lastAgreedMeetingFormat =
        agreedMeetingFormat ?? currentState.lastAgreedMeetingFormat;
    final snapshotMeetingFormat = _parseMeetingFormat(snapshotRaw['meetingFormat']);
    final snapshotMatchesFormat =
        agreedMeetingFormat != null &&
        snapshotMeetingFormat != null &&
        snapshotMeetingFormat == agreedMeetingFormat;
    final syncedRadius = snapshotRadius != null && snapshotRadius > 0
        ? snapshotRadius.toDouble()
        : currentState.searchRadius;
    final creatorSearchRadius = (roomData['creatorSearchRadius'] as num?)
        ?.toInt();
    final partnerSearchRadius = (roomData['partnerSearchRadius'] as num?)
        ?.toInt();
    final creatorRadiusUpdatedAt = _parseTimestamp(
      roomData['creatorSearchRadiusUpdatedAt'],
    );
    final partnerRadiusUpdatedAt = _parseTimestamp(
      roomData['partnerSearchRadiusUpdatedAt'],
    );
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
    final meetingRevoteRequestByRole = meetingRevoteRequestRaw['requestedBy']
        ?.toString();
    final meetingRevoteRequestStatus = meetingRevoteRequestRaw['status']
        ?.toString();

    final finalChoiceName = _roomMapper.nonEmptyTrimmed(
      roomData['finalChoice'],
    );
    final lookupForFinalChoice = <Place>[
      ...snapshotPlaces,
      ...currentState.foundPlaces,
    ];
    final resolvedFinalPlace = finalChoiceName == null
        ? null
        : _roomMapper.placeFromFinalChoiceDoc(
            roomData,
            finalChoiceName,
            lookupForFinalChoice,
          );
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
      final formatChanged = currentState.selectedMeetingFormat != agreedMeetingFormat;
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
      proposalPlaceName: proposalRaw['placeName']?.toString(),
      proposalPlaceAddress: proposalRaw['placeAddress']?.toString(),
      proposalPlaceType: proposalRaw['placeType']?.toString(),
      proposalByRole: proposalRaw['proposedBy']?.toString(),
      proposalStatus: proposalRaw['status']?.toString(),
      votesByUser: votes,
      voteCounts: _roomMapper.buildVoteCounts(votes),
      centerPoint: nextCenter,
      foundPlaces: nextFound,
      routePoints: nextRoute,
      filteredPlaces: nextFiltered,
      searchRadius: resolvedSearchRadius,
      creatorChangedRadiusTo: null,
      peerSuggestedRadius: venueLocked ? null : peerSuggestedRadius,
      peerSuggestedMeetingFormat: null,
      errorMessage: venueLocked || hasSnapshot
          ? null
          : currentState.lastFailure,
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

  MeetingFormat? _parseMeetingFormat(dynamic raw) {
    final value = (raw ?? '').toString().trim();
    if (value.isEmpty) return null;
    return MeetingFormat.fromWireValue(value);
  }

  List<MeetingFormat> _parseMeetingFormats({
    required dynamic formatsRaw,
    required dynamic legacyRaw,
  }) {
    final parsed = <MeetingFormat>[];
    if (formatsRaw is List) {
      for (final value in formatsRaw) {
        final format = _parseMeetingFormat(value);
        if (format != null && !parsed.contains(format)) {
          parsed.add(format);
        }
      }
    }
    if (parsed.isNotEmpty) return _sortFormats(parsed);
    final legacyFormat = _parseMeetingFormat(legacyRaw);
    if (legacyFormat == null) return const [];
    return [legacyFormat];
  }

  DateTime? _parseTimestamp(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    return null;
  }

  List<MeetingFormat> _sortFormats(List<MeetingFormat> values) {
    final sorted = List<MeetingFormat>.from(values);
    sorted.sort((a, b) => a.index.compareTo(b.index));
    return sorted;
  }
}
