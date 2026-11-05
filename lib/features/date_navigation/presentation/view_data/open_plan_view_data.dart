class NextStepViewData {
  const NextStepViewData({required this.name, this.address});

  final String name;
  final String? address;
}

class PlanSuggestionViewData {
  const PlanSuggestionViewData({
    required this.id,
    required this.placeName,
    required this.proposedBy,
    required this.isChosen,
    required this.isSuggested,
    this.placeAddress,
    this.lat = 0,
    this.lon = 0,
  });

  final String id;
  final String placeName;
  final String? placeAddress;
  final String proposedBy;
  final bool isChosen;
  final bool isSuggested;
  final double lat;
  final double lon;
}
