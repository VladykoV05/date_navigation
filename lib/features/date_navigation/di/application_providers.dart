import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/actions/proposal_actions.dart';
import '../application/actions/vote_scenario_actions.dart';
import '../application/policies/meeting_guard_policy.dart';
import '../application/state_transitions/meeting_interaction_transitions.dart';
import '../application/state_transitions/room_session_state_transitions.dart';

final meetingGuardPolicyProvider = Provider<MeetingGuardPolicy>(
  (ref) => const MeetingGuardPolicy(),
);

final proposalActionsProvider = Provider<ProposalActions>(
  (ref) => const ProposalActions(),
);

final voteScenarioActionsProvider = Provider<VoteScenarioActions>(
  (ref) => const VoteScenarioActions(),
);

final roomSessionStateTransitionsProvider =
    Provider<RoomSessionStateTransitions>(
      (ref) => const RoomSessionStateTransitions(),
    );

final meetingInteractionTransitionsProvider =
    Provider<MeetingInteractionTransitions>(
      (ref) => const MeetingInteractionTransitions(),
    );
