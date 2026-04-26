enum MeetingFormat {
  food,
  culture,
  walkOnly,
  active;

  String get wireValue => switch (this) {
    MeetingFormat.food => 'food',
    MeetingFormat.culture => 'culture',
    MeetingFormat.walkOnly => 'walk_only',
    MeetingFormat.active => 'active',
  };

  static MeetingFormat fromWireValue(String raw) {
    return switch (raw) {
      'food' => MeetingFormat.food,
      // Backward compatibility for existing room docs.
      'coffee' => MeetingFormat.food,
      'dinner' => MeetingFormat.food,
      'walk_and_coffee' => MeetingFormat.culture,
      'culture' => MeetingFormat.culture,
      'walk_only' => MeetingFormat.walkOnly,
      'active' => MeetingFormat.active,
      _ => MeetingFormat.food,
    };
  }
}
