import '../../../../core/error/result.dart';
import '../../domain/entities/open_plan.dart';
import '../../domain/repositories/open_plan_repository.dart';
import '../datasources/remote/open_plan_remote_data_source.dart';

class OpenPlanRepositoryImpl implements OpenPlanRepository {
  OpenPlanRepositoryImpl(this._remote);

  final OpenPlanRemoteDataSource _remote;

  @override
  Stream<List<PlaceSuggestion>> watchSuggestions(String roomId) =>
      _remote.watchSuggestions(roomId);

  @override
  Future<Result<void>> suggestPlace({
    required String roomId,
    required String userId,
    required String name,
    String? address,
    required double lat,
    required double lon,
  }) => _remote.suggestPlace(
    roomId: roomId,
    userId: userId,
    name: name,
    address: address,
    lat: lat,
    lon: lon,
  );

  @override
  Future<Result<void>> chooseSuggestion({
    required String roomId,
    required String suggestionId,
    required String placeName,
    String? placeAddress,
    required double lat,
    required double lon,
    required String hostUid,
  }) => _remote.chooseSuggestion(
    roomId: roomId,
    suggestionId: suggestionId,
    placeName: placeName,
    placeAddress: placeAddress,
    lat: lat,
    lon: lon,
    hostUid: hostUid,
  );

  @override
  Future<Result<void>> setPlanRadius({
    required String roomId,
    required int meters,
  }) => _remote.setPlanRadius(roomId: roomId, meters: meters);
}
