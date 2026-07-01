import 'package:latlong2/latlong.dart' as latlong;

import 'date_scenario.dart';
import 'date_vibe.dart';
import 'place.dart';
import 'room_status.dart';

class RoomProposalSnapshot {
  const RoomProposalSnapshot({
    this.placeName,
    this.placeAddress,
    this.placeType,
    this.proposedBy,
    this.status,
  });

  final String? placeName;
  final String? placeAddress;
  final String? placeType;
  final String? proposedBy;
  final ProposalStatus? status;
}

class RoomMeetingSnapshot {
  const RoomMeetingSnapshot({
    this.center,
    this.places = const [],
    this.routePoints = const [],
    this.updatedAt,
    this.searchRadius,
    this.meetingFormat,
  });

  final latlong.LatLng? center;
  final List<Place> places;
  final List<latlong.LatLng> routePoints;
  final DateTime? updatedAt;
  final int? searchRadius;
  final MeetingFormat? meetingFormat;

  bool get hasContent => center != null && places.isNotEmpty;
}

class RoomRevoteRequestSnapshot {
  const RoomRevoteRequestSnapshot({this.requestedBy, this.status});

  final String? requestedBy;
  final RevoteRequestStatus? status;
}

class RoomFinalChoiceSnapshot {
  const RoomFinalChoiceSnapshot({
    this.name,
    this.lat,
    this.lon,
    this.address,
    this.type,
  });

  final String? name;
  final double? lat;
  final double? lon;
  final String? address;
  final String? type;

  bool get isLocked => name != null;

  Place? resolvePlace(List<Place> lookup) {
    final choiceName = name;
    if (choiceName == null) return null;
    if (lat != null && lon != null) {
      return Place(
        name: choiceName,
        lat: lat!,
        lon: lon!,
        address: address,
        type: type,
      );
    }
    for (final place in lookup) {
      if (place.name == choiceName) return place;
    }
    return null;
  }
}

class RoomSnapshot {
  const RoomSnapshot({
    required this.id,
    required this.creatorUid,
    this.partnerUid,
    this.point1,
    this.point2,
    this.proposal = const RoomProposalSnapshot(),
    this.votes = const {},
    this.meetingSnapshot = const RoomMeetingSnapshot(),
    this.sessionStatus = SessionStatus.active,
    this.expiresAt,
    this.creatorMeetingFormats = const [],
    this.partnerMeetingFormats = const [],
    this.creatorSelectedMeetingFormat,
    this.partnerSelectedMeetingFormat,
    this.selectedScenario,
    this.creatorSearchRadius,
    this.partnerSearchRadius,
    this.creatorSearchRadiusUpdatedAt,
    this.partnerSearchRadiusUpdatedAt,
    this.meetingRevoteRequest = const RoomRevoteRequestSnapshot(),
    this.finalChoice = const RoomFinalChoiceSnapshot(),
  });

  final String id;
  final String creatorUid;
  final String? partnerUid;
  final latlong.LatLng? point1;
  final latlong.LatLng? point2;
  final RoomProposalSnapshot proposal;
  final Map<String, String> votes;
  final RoomMeetingSnapshot meetingSnapshot;
  final SessionStatus sessionStatus;
  final DateTime? expiresAt;
  final List<MeetingFormat> creatorMeetingFormats;
  final List<MeetingFormat> partnerMeetingFormats;
  final MeetingFormat? creatorSelectedMeetingFormat;
  final MeetingFormat? partnerSelectedMeetingFormat;
  final DateScenario? selectedScenario;
  final int? creatorSearchRadius;
  final int? partnerSearchRadius;
  final DateTime? creatorSearchRadiusUpdatedAt;
  final DateTime? partnerSearchRadiusUpdatedAt;
  final RoomRevoteRequestSnapshot meetingRevoteRequest;
  final RoomFinalChoiceSnapshot finalChoice;
}
