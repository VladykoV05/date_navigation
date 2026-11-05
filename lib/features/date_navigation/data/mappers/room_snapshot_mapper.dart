import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../domain/entities/room_status.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import 'date_scenario_mapper.dart';
import 'geo_coordinate_mapper.dart';

class RoomSnapshotMapper {
  const RoomSnapshotMapper();

  RoomSnapshot? fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (!document.exists || data == null) return null;
    return fromMap(document.id, data);
  }

  RoomSnapshot fromMap(
    String id,
    Map<String, dynamic> data, {
    Map<String, Map<String, dynamic>> participantDocs = const {},
  }) {
    final snapshotRaw = Map<String, dynamic>.from(
      data['meetingSnapshot'] ?? const <String, dynamic>{},
    );
    final proposalRaw = Map<String, dynamic>.from(data['proposal'] ?? {});
    final votesRaw = Map<String, dynamic>.from(data['votes'] ?? {});
    final meetingRevoteRequestRaw = Map<String, dynamic>.from(
      data['meetingRevoteRequest'] ?? const <String, dynamic>{},
    );
    final legacySelectedMeetingFormat = _parseMeetingFormat(
      data['selectedMeetingFormat'],
    );
    final creatorUid = (data['creatorUid'] ?? '').toString();

    return RoomSnapshot(
      id: id,
      creatorUid: creatorUid,
      partnerUid: _nonEmptyTrimmed(data['partnerUid']),
      inviteCode: _nonEmptyTrimmed(data['inviteCode']),
      point1: _parseLatLng(data['point1']),
      point2: _parseLatLng(data['point2']),
      proposal: RoomProposalSnapshot(
        placeName: _nonEmptyTrimmed(proposalRaw['placeName']),
        placeAddress: _nonEmptyTrimmed(proposalRaw['placeAddress']),
        placeType: _nonEmptyTrimmed(proposalRaw['placeType']),
        proposedBy: _nonEmptyTrimmed(proposalRaw['proposedBy']),
        status: ProposalStatus.fromWireValue(proposalRaw['status']),
      ),
      votes: votesRaw.map((key, value) => MapEntry(key, value.toString())),
      meetingSnapshot: RoomMeetingSnapshot(
        center: _parseLatLng(snapshotRaw['center']),
        places: _parsePlaces(snapshotRaw['places']),
        routePoints: _parseRoutePoints(snapshotRaw['routePoints']),
        updatedAt: _parseTimestamp(snapshotRaw['updatedAt']),
        searchRadius: (snapshotRaw['searchRadius'] as num?)?.toInt(),
        meetingFormat: _parseMeetingFormat(snapshotRaw['meetingFormat']),
      ),
      sessionStatus: SessionStatus.fromWireValue(data['sessionStatus']),
      expiresAt: _parseTimestamp(data['expiresAt']),
      creatorMeetingFormats: _parseMeetingFormats(
        formatsRaw: data['creatorMeetingFormats'],
        legacyRaw: data['creatorMeetingFormat'],
      ),
      partnerMeetingFormats: _parseMeetingFormats(
        formatsRaw: data['partnerMeetingFormats'],
        legacyRaw: data['partnerMeetingFormat'],
      ),
      creatorSelectedMeetingFormat:
          _parseMeetingFormat(data['creatorSelectedMeetingFormat']) ??
          legacySelectedMeetingFormat,
      partnerSelectedMeetingFormat:
          _parseMeetingFormat(data['partnerSelectedMeetingFormat']) ??
          legacySelectedMeetingFormat,
      selectedScenario: _parseSelectedScenario(data['selectedScenario']),
      creatorSearchRadius: (data['creatorSearchRadius'] as num?)?.toInt(),
      partnerSearchRadius: (data['partnerSearchRadius'] as num?)?.toInt(),
      creatorSearchRadiusUpdatedAt: _parseTimestamp(
        data['creatorSearchRadiusUpdatedAt'],
      ),
      partnerSearchRadiusUpdatedAt: _parseTimestamp(
        data['partnerSearchRadiusUpdatedAt'],
      ),
      meetingRevoteRequest: RoomRevoteRequestSnapshot(
        requestedBy: _nonEmptyTrimmed(meetingRevoteRequestRaw['requestedBy']),
        status: RevoteRequestStatus.fromWireValue(
          meetingRevoteRequestRaw['status'],
        ),
      ),
      finalChoice: RoomFinalChoiceSnapshot(
        name: _nonEmptyTrimmed(data['finalChoice']),
        lat: (data['finalChoiceLat'] as num?)?.toDouble(),
        lon: (data['finalChoiceLon'] as num?)?.toDouble(),
        address: _nonEmptyTrimmed(data['finalChoiceAddress']),
        type: _nonEmptyTrimmed(data['finalChoiceType']),
      ),
      schemaVersion: (data['schemaVersion'] as num?)?.toInt() ?? 1,
      type: RoomType.fromWireValue(data['type']),
      visibility: RoomVisibility.fromWireValue(data['visibility']),
      capacity: (data['capacity'] as num?)?.toInt() ?? 2,
      hostUid: _nonEmptyTrimmed(data['hostUid']) ?? creatorUid,
      participants: _parseParticipants(data, participantDocs: participantDocs),
      event: _parseEvent(data['event']),
    );
  }

  static List<RoomParticipant> _parseParticipants(
    Map<String, dynamic> data, {
    Map<String, Map<String, dynamic>> participantDocs = const {},
  }) {
    if (participantDocs.isNotEmpty) {
      final hostUid =
          _nonEmptyTrimmed(data['hostUid']) ??
          (data['creatorUid'] ?? '').toString();
      final rawUids = data['participants'];
      final uids = rawUids is List
          ? rawUids.map((uid) => uid.toString()).toList(growable: false)
          : participantDocs.keys.toList(growable: false);
      return [
        for (final uid in uids)
          participantDocs.containsKey(uid)
              ? _participantFromDoc(uid, participantDocs[uid]!)
              : RoomParticipant(
                  uid: uid,
                  role: uid == hostUid
                      ? RoomParticipantRole.host
                      : RoomParticipantRole.member,
                ),
      ];
    }
    final raw = data['participants'];
    if (raw is List) {
      final parsed = <RoomParticipant>[];
      final hostUid =
          _nonEmptyTrimmed(data['hostUid']) ??
          (data['creatorUid'] ?? '').toString();
      for (final item in raw) {
        if (item is String) {
          final uid = _nonEmptyTrimmed(item);
          if (uid == null) continue;
          parsed.add(
            RoomParticipant(
              uid: uid,
              role: uid == hostUid
                  ? RoomParticipantRole.host
                  : RoomParticipantRole.member,
            ),
          );
          continue;
        }
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final uid = _nonEmptyTrimmed(map['uid']);
        if (uid == null) continue;
        parsed.add(_participantFromDoc(uid, map));
      }
      if (parsed.isNotEmpty) return parsed;
    }
    return _deriveParticipants(data);
  }

  static RoomParticipant _participantFromDoc(
    String uid,
    Map<String, dynamic> map,
  ) {
    return RoomParticipant(
      uid: uid,
      role: RoomParticipantRole.fromWireValue(map['role']),
      point: _parseLatLng(map['point']),
      searchRadius: (map['searchRadius'] as num?)?.toInt(),
      meetingFormats: _parseMeetingFormats(
        formatsRaw: map['meetingFormats'],
        legacyRaw: map['meetingFormat'],
      ),
      selectedMeetingFormat: _parseMeetingFormat(map['selectedMeetingFormat']),
      lastReadAt: _parseTimestamp(map['lastReadAt']),
    );
  }

  static List<RoomParticipant> _deriveParticipants(Map<String, dynamic> data) {
    final creatorUid = (data['creatorUid'] ?? '').toString();
    if (creatorUid.isEmpty) return const [];
    final partnerUid = _nonEmptyTrimmed(data['partnerUid']);
    return [
      RoomParticipant(
        uid: creatorUid,
        role: RoomParticipantRole.host,
        point: _parseLatLng(data['point1']),
        searchRadius: (data['creatorSearchRadius'] as num?)?.toInt(),
        meetingFormats: _parseMeetingFormats(
          formatsRaw: data['creatorMeetingFormats'],
          legacyRaw: data['creatorMeetingFormat'],
        ),
        selectedMeetingFormat: _parseMeetingFormat(
          data['creatorSelectedMeetingFormat'],
        ),
      ),
      if (partnerUid != null)
        RoomParticipant(
          uid: partnerUid,
          point: _parseLatLng(data['point2']),
          searchRadius: (data['partnerSearchRadius'] as num?)?.toInt(),
          meetingFormats: _parseMeetingFormats(
            formatsRaw: data['partnerMeetingFormats'],
            legacyRaw: data['partnerMeetingFormat'],
          ),
          selectedMeetingFormat: _parseMeetingFormat(
            data['partnerSelectedMeetingFormat'],
          ),
        ),
    ];
  }

  static RoomEventSnapshot? _parseEvent(dynamic raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    final id = _nonEmptyTrimmed(map['id']);
    final title = _nonEmptyTrimmed(map['title']);
    if (id == null || title == null) return null;
    return RoomEventSnapshot(
      id: id,
      title: title,
      startsAt: _parseTimestamp(map['startsAt']),
      venueName: _nonEmptyTrimmed(map['venueName']),
      address: _nonEmptyTrimmed(map['address']),
      lat: (map['lat'] as num?)?.toDouble(),
      lon: (map['lon'] as num?)?.toDouble(),
      imageUrl: _nonEmptyTrimmed(map['imageUrl']),
      sourceUrl: _nonEmptyTrimmed(map['sourceUrl']),
      price: _nonEmptyTrimmed(map['price']),
      category: _nonEmptyTrimmed(map['category']),
      source: _nonEmptyTrimmed(map['source']),
    );
  }

  static Map<String, dynamic> eventToWire(RoomEventSnapshot event) => {
    'id': event.id,
    'title': event.title,
    if (event.startsAt != null) 'startsAt': Timestamp.fromDate(event.startsAt!),
    if (event.venueName != null) 'venueName': event.venueName,
    if (event.address != null) 'address': event.address,
    if (event.lat != null) 'lat': event.lat,
    if (event.lon != null) 'lon': event.lon,
    if (event.imageUrl != null) 'imageUrl': event.imageUrl,
    if (event.sourceUrl != null) 'sourceUrl': event.sourceUrl,
    if (event.price != null) 'price': event.price,
    if (event.category != null) 'category': event.category,
    if (event.source != null) 'source': event.source,
  };

  static GeoCoordinate? _parseLatLng(dynamic raw) {
    return GeoCoordinateMapper.fromWireMap(raw);
  }

  static String? _nonEmptyTrimmed(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static DateTime? _parseTimestamp(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    return null;
  }

  static List<GeoCoordinate> _parseRoutePoints(dynamic raw) {
    return GeoCoordinateMapper.routePointsFromWireList(raw);
  }

  static List<Place> _parsePlaces(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (item) => Place(
            name: (item['name'] ?? '').toString(),
            lat: (item['lat'] as num?)?.toDouble() ?? 0.0,
            lon: (item['lon'] as num?)?.toDouble() ?? 0.0,
            address: item['address']?.toString(),
            type: item['type']?.toString(),
          ),
        )
        .where((place) => place.name.isNotEmpty)
        .toList(growable: false);
  }

  static DateScenario? _parseSelectedScenario(dynamic raw) {
    if (raw is! Map) return null;
    final parsed = DateScenarioMapper.fromFirestore(
      Map<String, dynamic>.from(raw),
    );
    return parsed.id.isEmpty ? null : parsed;
  }

  static MeetingFormat? _parseMeetingFormat(dynamic raw) {
    final value = (raw ?? '').toString().trim();
    if (value.isEmpty) return null;
    return MeetingFormat.fromWireValue(value);
  }

  static List<MeetingFormat> _parseMeetingFormats({
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

  static List<MeetingFormat> _sortFormats(List<MeetingFormat> values) {
    final sorted = List<MeetingFormat>.from(values);
    sorted.sort((a, b) => a.index.compareTo(b.index));
    return sorted;
  }
}
