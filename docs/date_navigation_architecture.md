# Date Navigation Architecture (Ownership)

This document defines clear ownership boundaries for the presentation orchestration
layer to keep `DateNavigationController` thin and predictable.

## Controller Role

`DateNavigationController` is responsible for:

- wiring user intents to usecases/coordinators,
- sequencing async operations,
- writing final state updates,
- handling high-level retry/error flow.

It should not own feature-specific business rules if those rules can be isolated.

## Coordinator Ownership

- `MeetingGuardCoordinator`
  - session/format preconditions.
- `RoomActionsCoordinator`
  - room lifecycle state transitions (`create/join/leave/complete`).
- `MeetingInteractionCoordinator`
  - interaction result mapping (`vote/propose/respond/format/scenario`).
- `MeetingStateCoordinator`
  - applying meeting success and scenario synchronization.
- `PartnerFallbackCoordinator`
  - partner-side fallback recalculation policy and state application.
- `RoomSyncCoordinator`
  - mapping room document snapshot to local state.
- `RoomSyncReactionCoordinator`
  - decision matrix for post-sync actions.
- `RoomSyncOrchestrator`
  - sync plan assembly from sync outcome + reaction action.
- `MeetingPlannerCoordinator`
  - request sequencing, cache keys, filtered/ranked places.
- `RecalculatePolicyCoordinator`
  - recalc throttling and early-stop policy.

## Data Layer Contracts

- `PlacesRemoteDataSource` delegates candidate resolution to
  `PlaceDiscoveryPipeline`.
- `PlaceQualityService` handles usability filter, ranking and dedupe.
- `CacheService` owns places/route/geocode cache keys and TTL logic.

## Rule of Thumb

When adding a new product behavior:

1. Put reusable rule/policy into a dedicated coordinator/service.
2. Keep controller methods as orchestration scripts.
3. Add/extend unit tests around the extracted component first.
