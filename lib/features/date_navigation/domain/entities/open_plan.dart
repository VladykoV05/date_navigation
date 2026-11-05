/// Следующее место плана открытой сессии (выбирает хост).
class NextStep {
  const NextStep({
    required this.name,
    required this.lat,
    required this.lon,
    this.address,
    this.chosenBy,
  });

  final String name;
  final String? address;
  final double lat;
  final double lon;
  final String? chosenBy;
}

enum SuggestionStatus {
  suggested('suggested'),
  chosen('chosen'),
  rejected('rejected');

  const SuggestionStatus(this.wireValue);
  final String wireValue;

  static SuggestionStatus fromWireValue(Object? value) {
    return switch (value) {
      'chosen' => SuggestionStatus.chosen,
      'rejected' => SuggestionStatus.rejected,
      _ => SuggestionStatus.suggested,
    };
  }
}

/// Предложение места участником; выбирает хост.
class PlaceSuggestion {
  const PlaceSuggestion({
    required this.id,
    required this.placeName,
    required this.lat,
    required this.lon,
    required this.proposedBy,
    required this.status,
    this.placeAddress,
    this.createdAt,
  });

  final String id;
  final String placeName;
  final String? placeAddress;
  final double lat;
  final double lon;
  final String proposedBy;
  final SuggestionStatus status;
  final DateTime? createdAt;
}

/// Лимит предложений на участника в час (design 11.1).
const int suggestionsPerHourLimit = 5;

/// Допустимый радиус поиска от площадки события (design 11.1, rules 300..3000).
const int planRadiusMinMeters = 300;
const int planRadiusMaxMeters = 3000;
const int planRadiusDefaultMeters = 1000;
