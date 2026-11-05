import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/analytics_di.dart';
import '../../../../core/di/app_services_di.dart';
import '../../../../core/error/result.dart';
import '../../../user_profile/user_profile.dart';
import '../../di/date_navigation_di.dart';
import '../../application/services/address_submission_service.dart';
import '../../application/services/date_assistant_service.dart';
import '../../application/services/location_submission_service.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../application/services/meeting_execution_service.dart';
import '../../application/services/room_interaction_service.dart';
import '../../application/services/room_lifecycle_service.dart';
import '../../domain/usecases/open_room_usecases.dart';

final addressSubmissionServiceProvider = Provider<AddressSubmissionService>(
  (ref) => AddressSubmissionService(
    geocodeAddress: ref.watch(geocodeAddressProvider),
    updateLocation: ref.watch(updateLocationProvider),
    rememberAddress: ref.watch(profileRememberUserAddressProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final eventsProvider = FutureProvider.autoDispose<List<RoomEventSnapshot>>((
  ref,
) async {
  final result = await ref
      .watch(eventsProxyDataSourceProvider)
      .searchEvents(limit: 10);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final locationSubmissionServiceProvider = Provider<LocationSubmissionService>(
  (ref) => LocationSubmissionService(
    locationService: ref.watch(locationServiceProvider),
    updateLocation: ref.watch(updateLocationProvider),
  ),
);

final roomLifecycleServiceProvider = Provider<RoomLifecycleService>(
  (ref) => RoomLifecycleService(
    createRoom: ref.watch(createRoomProvider),
    completeSession: ref.watch(completeSessionProvider),
    leaveOpenRoom: ref.watch(leaveOpenRoomProvider),
    joinRoom: ref.watch(joinRoomProvider),
    createOpenRoom: CreateOpenRoom(ref.watch(roomSessionRepositoryProvider)),
    joinOpenRoom: JoinOpenRoom(ref.watch(roomSessionRepositoryProvider)),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final roomInteractionServiceProvider = Provider<RoomInteractionService>(
  (ref) => RoomInteractionService(
    voteForPlace: ref.watch(voteForPlaceProvider),
    proposePlace: ref.watch(proposePlaceProvider),
    respondToProposal: ref.watch(respondToProposalProvider),
    recordMeetingHistory: ref.watch(profileRecordMeetingHistoryProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final meetingExecutionServiceProvider = Provider<MeetingExecutionService>(
  (ref) => MeetingExecutionService(
    findMeetingPoint: ref.watch(findMeetingPointProvider),
    saveMeetingSnapshot: ref.watch(saveMeetingSnapshotProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);

final dateAssistantServiceProvider = Provider<DateAssistantService>(
  (ref) => DateAssistantService(
    // Resolve at call time so locale-driven catalog updates do not recreate
    // DateNavigationController (which would wipe the active room session).
    buildDateScenarios: () => ref.read(buildDateScenariosProvider),
    saveMeetingFormat: ref.watch(saveMeetingFormatProvider),
    confirmMeetingFormat: ref.watch(confirmMeetingFormatProvider),
    requestMeetingRevote: ref.watch(requestMeetingRevoteProvider),
    respondMeetingRevote: ref.watch(respondMeetingRevoteProvider),
    saveSelectedScenario: ref.watch(saveSelectedScenarioProvider),
    analytics: ref.watch(analyticsServiceProvider),
  ),
);
