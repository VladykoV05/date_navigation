import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_codes.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/open_plan.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/open_plan_repository.dart';
import '../datasources/remote/open_plan_remote_data_source.dart';
import '../datasources/remote/places_remote_data_source.dart';

class OpenPlanRepositoryImpl implements OpenPlanRepository {
  OpenPlanRepositoryImpl(this._remote, this._places);

  final OpenPlanRemoteDataSource _remote;
  final PlacesRemoteDataSource _places;

  @override
  Future<Result<List<Place>>> searchNearbyPlaces({
    required double lat,
    required double lon,
    required int radiusMeters,
    required MeetingFormat format,
  }) async {
    try {
      final places = await _places.findPlacesNearby(
        lat: lat,
        lon: lon,
        format: format,
        radius: radiusMeters,
      );
      return Ok(places);
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.placesSearchFailed));
    }
  }

  @override
  Future<Result<void>> setNextStep({
    required String roomId,
    required String name,
    String? address,
    required double lat,
    required double lon,
    required String hostUid,
  }) => _remote.setNextStep(
    roomId: roomId,
    name: name,
    address: address,
    lat: lat,
    lon: lon,
    hostUid: hostUid,
  );

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
