import 'room_meeting_format_repository.dart';
import 'room_place_voting_repository.dart';
import 'room_scenario_repository.dart';

/// Facade kept for shared impl wiring; prefer narrow ports in use cases.
abstract interface class RoomVotingRepository
    implements
        RoomPlaceVotingRepository,
        RoomMeetingFormatRepository,
        RoomScenarioRepository {}
