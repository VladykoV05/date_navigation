import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/usecases.dart';
import 'repository_providers.dart';

final createRoomProvider = Provider<CreateRoom>((ref) {
  return CreateRoom(ref.watch(roomSessionRepositoryProvider));
});

final joinRoomProvider = Provider<JoinRoom>((ref) {
  return JoinRoom(ref.watch(roomSessionRepositoryProvider));
});

final completeSessionProvider = Provider<CompleteSession>((ref) {
  return CompleteSession(ref.watch(roomSessionRepositoryProvider));
});

final watchRoomProvider = Provider<WatchRoom>((ref) {
  return WatchRoom(ref.watch(roomSessionRepositoryProvider));
});

final watchRecentHistoryProvider = Provider<WatchRecentHistory>((ref) {
  return WatchRecentHistory(ref.watch(meetingHistoryRepositoryProvider));
});

final watchFavoritesProvider = Provider<WatchFavorites>((ref) {
  return WatchFavorites(ref.watch(userFavoritesRepositoryProvider));
});

final watchFrequentAddressesProvider = Provider<WatchFrequentAddresses>((ref) {
  return WatchFrequentAddresses(ref.watch(userAddressMemoryRepositoryProvider));
});

final updateLocationProvider = Provider<UpdateLocation>((ref) {
  return UpdateLocation(ref.watch(roomSessionRepositoryProvider));
});

final voteForPlaceProvider = Provider<VoteForPlace>((ref) {
  return VoteForPlace(ref.watch(roomVotingRepositoryProvider));
});

final proposePlaceProvider = Provider<ProposePlace>((ref) {
  return ProposePlace(ref.watch(roomVotingRepositoryProvider));
});

final respondToProposalProvider = Provider<RespondToProposal>((ref) {
  return RespondToProposal(ref.watch(roomVotingRepositoryProvider));
});

final upsertFavoriteProvider = Provider<UpsertFavorite>((ref) {
  return UpsertFavorite(ref.watch(userFavoritesRepositoryProvider));
});

final removeFavoriteProvider = Provider<RemoveFavorite>((ref) {
  return RemoveFavorite(ref.watch(userFavoritesRepositoryProvider));
});

final rememberAddressProvider = Provider<RememberAddress>((ref) {
  return RememberAddress(ref.watch(userAddressMemoryRepositoryProvider));
});

final removeRememberedAddressProvider = Provider<RemoveRememberedAddress>((
  ref,
) {
  return RemoveRememberedAddress(
    ref.watch(userAddressMemoryRepositoryProvider),
  );
});

final saveMeetingSnapshotProvider = Provider<SaveMeetingSnapshot>((ref) {
  return SaveMeetingSnapshot(ref.watch(meetingSnapshotRepositoryProvider));
});

final buildDateScenariosProvider = Provider<BuildDateScenarios>((_) {
  return const BuildDateScenarios();
});

final saveSelectedScenarioProvider = Provider<SaveSelectedScenario>((ref) {
  return SaveSelectedScenario(ref.watch(roomVotingRepositoryProvider));
});

final saveMeetingFormatProvider = Provider<SaveMeetingFormat>((ref) {
  return SaveMeetingFormat(ref.watch(roomVotingRepositoryProvider));
});

final confirmMeetingFormatProvider = Provider<ConfirmMeetingFormat>((ref) {
  return ConfirmMeetingFormat(ref.watch(roomVotingRepositoryProvider));
});

final requestMeetingRevoteProvider = Provider<RequestMeetingRevote>((ref) {
  return RequestMeetingRevote(ref.watch(roomVotingRepositoryProvider));
});

final respondMeetingRevoteProvider = Provider<RespondMeetingRevote>((ref) {
  return RespondMeetingRevote(ref.watch(roomVotingRepositoryProvider));
});

final saveSearchRadiusProvider = Provider<SaveSearchRadius>((ref) {
  return SaveSearchRadius(ref.watch(roomVotingRepositoryProvider));
});

final geocodeAddressProvider = Provider<GeocodeAddress>((ref) {
  return GeocodeAddress(ref.watch(geocodingRepositoryProvider));
});

final findMeetingPointProvider = Provider<FindMeetingPoint>((ref) {
  return FindMeetingPoint(ref.watch(meetingRepositoryProvider));
});
