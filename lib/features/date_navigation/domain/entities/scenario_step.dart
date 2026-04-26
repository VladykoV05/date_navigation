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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      if (etaMinutes != null) 'etaMinutes': etaMinutes,
      if (placeName != null && placeName!.isNotEmpty) 'placeName': placeName,
    };
  }

  factory ScenarioStep.fromMap(Map<String, dynamic> raw) {
    return ScenarioStep(
      title: (raw['title'] ?? '').toString(),
      description: (raw['description'] ?? '').toString(),
      etaMinutes: (raw['etaMinutes'] as num?)?.toInt(),
      placeName: raw['placeName']?.toString(),
    );
  }
}
