import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../domain/entities/room_status.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import 'geo_coordinate_mapper.dart';

class RoomSnapshotMapper {
  const RoomSnapshotMapper();

  RoomSnapshot? fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (!document.exists || data == null) return null;
    return fromMap(document.id, data);
  }

  RoomSnapshot fromMap(String id, Map<String, dynamic> data) {
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

    return RoomSnapshot(
      id: id,
      creatorUid: (data['creatorUid'] ?? '').toString(),
      partnerUid: _nonEmptyTrimmed(data['partnerUid']),
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
    );
  }

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
    final parsed = DateScenario.fromMap(Map<String, dynamic>.from(raw));
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
