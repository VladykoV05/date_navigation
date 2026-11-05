import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../entities/open_plan.dart';
import '../entities/place.dart';
import '../repositories/open_plan_repository.dart';

class WatchPlaceSuggestions {
  const WatchPlaceSuggestions(this._repo);
  final OpenPlanRepository _repo;

  Stream<List<PlaceSuggestion>> call(String roomId) =>
      _repo.watchSuggestions(roomId);
}

class SuggestPlace {
  const SuggestPlace(this._repo);
  final OpenPlanRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required String name,
    String? address,
    required double lat,
    required double lon,
  }) {
    return _repo.suggestPlace(
      roomId: roomId,
      userId: userId,
      name: name,
      address: address,
      lat: lat,
      lon: lon,
    );
  }
}

class ChooseSuggestion {
  const ChooseSuggestion(this._repo);
  final OpenPlanRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required String suggestionId,
    required String placeName,
    String? placeAddress,
    required double lat,
    required double lon,
    required String hostUid,
  }) {
    return _repo.chooseSuggestion(
      roomId: roomId,
      suggestionId: suggestionId,
      placeName: placeName,
      placeAddress: placeAddress,
      lat: lat,
      lon: lon,
      hostUid: hostUid,
    );
  }
}

class SetPlanRadius {
  const SetPlanRadius(this._repo);
  final OpenPlanRepository _repo;

  Future<Result<void>> call({required String roomId, required int meters}) {
    return _repo.setPlanRadius(roomId: roomId, meters: meters);
  }
}

class SearchNearbyPlaces {
  const SearchNearbyPlaces(this._repo);
  final OpenPlanRepository _repo;

  Future<Result<List<Place>>> call({
    required double lat,
    required double lon,
    required int radiusMeters,
    required MeetingFormat format,
  }) {
    return _repo.searchNearbyPlaces(
      lat: lat,
      lon: lon,
      radiusMeters: radiusMeters,
      format: format,
    );
  }
}

class SetNextStep {
  const SetNextStep(this._repo);
  final OpenPlanRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required String name,
    String? address,
    required double lat,
    required double lon,
    required String hostUid,
  }) {
    return _repo.setNextStep(
      roomId: roomId,
      name: name,
      address: address,
      lat: lat,
      lon: lon,
      hostUid: hostUid,
    );
  }
}
