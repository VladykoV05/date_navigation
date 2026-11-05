import 'date_scenario.dart';
import 'date_vibe.dart';
import 'place.dart';
import 'room_status.dart';
import '../value_objects/geo_coordinate.dart';

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

  final GeoCoordinate? center;
  final List<Place> places;
  final List<GeoCoordinate> routePoints;
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

enum RoomType {
  private('private'),
  open('open');

  const RoomType(this.wireValue);

  final String wireValue;

  bool get isOpen => this == RoomType.open;

  static RoomType fromWireValue(Object? value) {
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'open' ? RoomType.open : RoomType.private;
  }
}

enum RoomVisibility {
  invite('invite'),
  public('public');

  const RoomVisibility(this.wireValue);

  final String wireValue;

  static RoomVisibility fromWireValue(Object? value) {
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'public'
        ? RoomVisibility.public
        : RoomVisibility.invite;
  }
}

enum RoomParticipantRole {
  host('host'),
  member('member');

  const RoomParticipantRole(this.wireValue);

  final String wireValue;

  static RoomParticipantRole fromWireValue(Object? value) {
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'host'
        ? RoomParticipantRole.host
        : RoomParticipantRole.member;
  }
}

class RoomParticipant {
  const RoomParticipant({
    required this.uid,
    this.role = RoomParticipantRole.member,
    this.point,
    this.searchRadius,
    this.meetingFormats = const [],
    this.selectedMeetingFormat,
    this.lastReadAt,
  });

  final String uid;
  final RoomParticipantRole role;
  final GeoCoordinate? point;
  final int? searchRadius;
  final List<MeetingFormat> meetingFormats;
  final MeetingFormat? selectedMeetingFormat;
  final DateTime? lastReadAt;
}

class RoomEventSnapshot {
  const RoomEventSnapshot({
    required this.id,
    required this.title,
    this.startsAt,
    this.venueName,
    this.address,
    this.lat,
    this.lon,
    this.imageUrl,
    this.sourceUrl,
    this.price,
    this.category,
    this.source,
  });

  final String id;
  final String title;
  final DateTime? startsAt;
  final String? venueName;
  final String? address;
  final double? lat;
  final double? lon;
  final String? imageUrl;
  final String? sourceUrl;
  final String? price;
  final String? category;
  final String? source;
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
    this.schemaVersion = 1,
    this.inviteCode,
    this.type = RoomType.private,
    this.visibility = RoomVisibility.invite,
    this.capacity = 2,
    this.hostUid = '',
    this.participants = const [],
    this.event,
  });

  final String id;
  final String? inviteCode;
  final String creatorUid;
  final String? partnerUid;
  final GeoCoordinate? point1;
  final GeoCoordinate? point2;
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
  final int schemaVersion;
  final RoomType type;
  final RoomVisibility visibility;
  final int capacity;
  final String hostUid;
  final List<RoomParticipant> participants;
  final RoomEventSnapshot? event;

  bool get isOpen => type.isOpen;
  String get effectiveHostUid => hostUid.isNotEmpty ? hostUid : creatorUid;
  List<String> get participantUids => participants
      .map((participant) => participant.uid)
      .toList(growable: false);

  RoomParticipant? participantByUid(String uid) {
    for (final participant in participants) {
      if (participant.uid == uid) return participant;
    }
    return null;
  }
}
