import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../entities/open_plan.dart';
import '../entities/place.dart';

abstract interface class OpenPlanRepository {
  Stream<List<PlaceSuggestion>> watchSuggestions(String roomId);

  /// Участник предлагает место. Лимит 5 в час проверяется в транзакции.
  Future<Result<void>> suggestPlace({
    required String roomId,
    required String userId,
    required String name,
    String? address,
    required double lat,
    required double lon,
  });

  /// Хост выбирает предложение: оно становится следующим местом плана.
  Future<Result<void>> chooseSuggestion({
    required String roomId,
    required String suggestionId,
    required String placeName,
    String? placeAddress,
    required double lat,
    required double lon,
    required String hostUid,
  });

  /// Места рядом с площадкой события по формату (существующий поиск мест).
  Future<Result<List<Place>>> searchNearbyPlaces({
    required double lat,
    required double lon,
    required int radiusMeters,
    required MeetingFormat format,
  });

  /// Хост задаёт следующее место сразу (без предложения).
  Future<Result<void>> setNextStep({
    required String roomId,
    required String name,
    String? address,
    required double lat,
    required double lon,
    required String hostUid,
  });

  Future<Result<void>> setPlanRadius({
    required String roomId,
    required int meters,
  });
}
