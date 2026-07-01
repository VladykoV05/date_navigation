import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/usecases/usecases.dart';
import 'repository_providers.dart';

part 'usecase_providers.g.dart';

@Riverpod(keepAlive: true)
CreateRoom createRoom(Ref ref) {
  return CreateRoom(ref.watch(roomSessionRepositoryProvider));
}

@Riverpod(keepAlive: true)
JoinRoom joinRoom(Ref ref) {
  return JoinRoom(ref.watch(roomSessionRepositoryProvider));
}

@Riverpod(keepAlive: true)
CompleteSession completeSession(Ref ref) {
  return CompleteSession(ref.watch(roomSessionRepositoryProvider));
}

@Riverpod(keepAlive: true)
WatchRoom watchRoom(Ref ref) {
  return WatchRoom(ref.watch(roomSessionRepositoryProvider));
}

@Riverpod(keepAlive: true)
UpdateLocation updateLocation(Ref ref) {
  return UpdateLocation(ref.watch(roomSessionRepositoryProvider));
}

@Riverpod(keepAlive: true)
VoteForPlace voteForPlace(Ref ref) {
  return VoteForPlace(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
ProposePlace proposePlace(Ref ref) {
  return ProposePlace(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
RespondToProposal respondToProposal(Ref ref) {
  return RespondToProposal(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
SaveMeetingSnapshot saveMeetingSnapshot(Ref ref) {
  return SaveMeetingSnapshot(ref.watch(meetingSnapshotRepositoryProvider));
}

@Riverpod(keepAlive: true)
BuildDateScenarios buildDateScenarios(Ref ref) {
  return const BuildDateScenarios();
}

@Riverpod(keepAlive: true)
SaveSelectedScenario saveSelectedScenario(Ref ref) {
  return SaveSelectedScenario(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
SaveMeetingFormat saveMeetingFormat(Ref ref) {
  return SaveMeetingFormat(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
ConfirmMeetingFormat confirmMeetingFormat(Ref ref) {
  return ConfirmMeetingFormat(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
RequestMeetingRevote requestMeetingRevote(Ref ref) {
  return RequestMeetingRevote(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
RespondMeetingRevote respondMeetingRevote(Ref ref) {
  return RespondMeetingRevote(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
SaveSearchRadius saveSearchRadius(Ref ref) {
  return SaveSearchRadius(ref.watch(roomVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
GeocodeAddress geocodeAddress(Ref ref) {
  return GeocodeAddress(ref.watch(geocodingRepositoryProvider));
}

@Riverpod(keepAlive: true)
FindMeetingPoint findMeetingPoint(Ref ref) {
  return FindMeetingPoint(ref.watch(meetingRepositoryProvider));
}
