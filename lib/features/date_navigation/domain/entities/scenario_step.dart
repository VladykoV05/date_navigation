class ScenarioStep {
  const ScenarioStep({
    required this.title,
    required this.description,
    this.etaMinutes,
    this.placeName,
  });

  final String title;
  final String description;
  final int? etaMinutes;
  final String? placeName;
}
