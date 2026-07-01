# Date Navigation Architecture (Ownership)

This document defines clear ownership boundaries for the presentation layer to
keep `DateNavigationController` thin and predictable.

## Controller Role

`DateNavigationController` is responsible for:

- wiring user intents to use cases and focused presentation helpers,
- sequencing async operations,
- writing final state updates,
- handling high-level retry/error flow.

It should not own feature-specific business rules if those rules can be isolated.

## Presentation Ownership

- `MeetingGuardPolicy`
  - session/format preconditions.
- `RoomSessionStateTransitions`
  - room lifecycle state transitions (`create/join/leave/complete`).
- `MeetingInteractionTransitions`
  - interaction result mapping (`vote/propose/respond/format/scenario`).
- `MeetingStateTransitions`
  - applying meeting success and scenario synchronization.
- `PartnerFallbackFlow`
  - partner-side fallback eligibility.
- `PartnerFallbackResultResolver`
  - partner-side fallback result decisions.
- `RoomSnapshotReducer`
  - mapping room document snapshot to local state.
- `RoomSyncReactionPolicy`
  - decision matrix for post-sync actions.
- `RoomSyncOrchestrator`
  - sync plan assembly from sync outcome + reaction action.
- `MeetingPlannerRuntime`
  - request sequencing, cache keys, filtered/ranked places.
- `RecalculatePolicy`
  - recalc throttling and early-stop policy.

## Data Layer Contracts

- `PlacesRemoteDataSource` delegates candidate resolution to
  `PlaceDiscoveryPipeline`.
- `PlaceQualityService` handles usability filter, ranking and dedupe.
- `CacheService` owns places/route/geocode cache keys and TTL logic.

## Rule of Thumb

When adding a new product behavior:

1. Put reusable rule/policy into a dedicated policy, flow, transition, or service.
2. Keep controller methods as orchestration scripts.
3. Add/extend unit tests around the extracted component first.
