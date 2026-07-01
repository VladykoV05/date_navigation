import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/room_status.dart';
import '../view_data/place_view_data.dart';

class PlaceViewMapper {
  const PlaceViewMapper._();

  static PlaceViewData fromPlace(Place place) {
    return PlaceViewData(
      name: place.name,
      lat: place.lat,
      lon: place.lon,
      address: place.address,
      type: place.type,
      types: place.types,
    );
  }

  static List<PlaceViewData> fromPlaces(Iterable<Place> places) {
    return places.map(fromPlace).toList(growable: false);
  }

  static Place toPlace(PlaceViewData place) {
    return Place(
      name: place.name,
      lat: place.lat,
      lon: place.lon,
      address: place.address,
      type: place.type,
      types: place.types,
    );
  }

  static ScenarioViewData fromScenario(DateScenario scenario) {
    return ScenarioViewData(
      title: scenario.title,
      description: scenario.description,
      totalDurationMinutes: scenario.totalDurationMinutes,
      steps: scenario.steps
          .map(
            (step) => ScenarioStepViewData(
              title: step.title,
              etaMinutes: step.etaMinutes,
            ),
          )
          .toList(growable: false),
      anchorPlace: scenario.anchorPlace == null
          ? null
          : fromPlace(scenario.anchorPlace!),
    );
  }

  static MeetingFormatView fromMeetingFormat(MeetingFormat format) {
    return switch (format) {
      MeetingFormat.food => MeetingFormatView.food,
      MeetingFormat.culture => MeetingFormatView.culture,
      MeetingFormat.walkOnly => MeetingFormatView.walkOnly,
      MeetingFormat.active => MeetingFormatView.active,
    };
  }

  static MeetingFormat toMeetingFormat(MeetingFormatView format) {
    return switch (format) {
      MeetingFormatView.food => MeetingFormat.food,
      MeetingFormatView.culture => MeetingFormat.culture,
      MeetingFormatView.walkOnly => MeetingFormat.walkOnly,
      MeetingFormatView.active => MeetingFormat.active,
    };
  }

  static List<MeetingFormatView> fromMeetingFormats(
    Iterable<MeetingFormat> formats,
  ) {
    return formats.map(fromMeetingFormat).toList(growable: false);
  }

  static Set<MeetingFormat> toMeetingFormats(
    Iterable<MeetingFormatView> formats,
  ) {
    return formats.map(toMeetingFormat).toSet();
  }

  static SessionStatusView fromSessionStatus(SessionStatus status) {
    return switch (status) {
      SessionStatus.active => SessionStatusView.active,
      SessionStatus.completed => SessionStatusView.completed,
      SessionStatus.expired => SessionStatusView.expired,
    };
  }

  static RevoteRequestStatusView? fromRevoteRequestStatus(
    RevoteRequestStatus? status,
  ) {
    return switch (status) {
      RevoteRequestStatus.pending => RevoteRequestStatusView.pending,
      null => null,
    };
  }
}
