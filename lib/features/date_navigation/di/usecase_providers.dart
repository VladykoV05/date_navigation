import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/l10n/locale_provider.dart';
import '../domain/usecases/usecases.dart';
import '../application/l10n/app_scenario_copy_catalog.dart';
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
LeaveOpenRoom leaveOpenRoom(Ref ref) {
  return LeaveOpenRoom(ref.watch(roomSessionRepositoryProvider));
}

@Riverpod(keepAlive: true)
MarkOpenRoomExpired markOpenRoomExpired(Ref ref) {
  return MarkOpenRoomExpired(ref.watch(roomSessionRepositoryProvider));
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
  return VoteForPlace(ref.watch(roomPlaceVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
ProposePlace proposePlace(Ref ref) {
  return ProposePlace(ref.watch(roomPlaceVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
RespondToProposal respondToProposal(Ref ref) {
  return RespondToProposal(ref.watch(roomPlaceVotingRepositoryProvider));
}

@Riverpod(keepAlive: true)
SaveMeetingSnapshot saveMeetingSnapshot(Ref ref) {
  return SaveMeetingSnapshot(ref.watch(meetingSnapshotRepositoryProvider));
}

@Riverpod(keepAlive: true)
BuildDateScenarios buildDateScenarios(Ref ref) {
  final locale = ref.watch(appLocaleProvider).value ?? const Locale('ru');
  return BuildDateScenarios(AppScenarioCopyCatalog(locale));
}

@Riverpod(keepAlive: true)
SaveSelectedScenario saveSelectedScenario(Ref ref) {
  return SaveSelectedScenario(ref.watch(roomScenarioRepositoryProvider));
}

@Riverpod(keepAlive: true)
SaveMeetingFormat saveMeetingFormat(Ref ref) {
  return SaveMeetingFormat(ref.watch(roomMeetingFormatRepositoryProvider));
}

@Riverpod(keepAlive: true)
ConfirmMeetingFormat confirmMeetingFormat(Ref ref) {
  return ConfirmMeetingFormat(ref.watch(roomMeetingFormatRepositoryProvider));
}

@Riverpod(keepAlive: true)
RequestMeetingRevote requestMeetingRevote(Ref ref) {
  return RequestMeetingRevote(ref.watch(roomMeetingFormatRepositoryProvider));
}

@Riverpod(keepAlive: true)
RespondMeetingRevote respondMeetingRevote(Ref ref) {
  return RespondMeetingRevote(ref.watch(roomMeetingFormatRepositoryProvider));
}

@Riverpod(keepAlive: true)
SaveSearchRadius saveSearchRadius(Ref ref) {
  return SaveSearchRadius(ref.watch(roomMeetingFormatRepositoryProvider));
}

@Riverpod(keepAlive: true)
GeocodeAddress geocodeAddress(Ref ref) {
  return GeocodeAddress(ref.watch(geocodingRepositoryProvider));
}

@Riverpod(keepAlive: true)
FindMeetingPoint findMeetingPoint(Ref ref) {
  return FindMeetingPoint(ref.watch(meetingRepositoryProvider));
}
