import 'dart:math' show pi, sin, cos, sqrt, asin;

class PlaceViewData {
  const PlaceViewData({
    required this.name,
    required this.lat,
    required this.lon,
    this.address,
    this.type,
    this.types = const {},
  });

  final String name;
  final double lat;
  final double lon;
  final String? address;
  final String? type;
  final Set<String> types;

  double distanceTo(double targetLat, double targetLon) {
    const earthRadius = 6371000.0;
    final dLat = _toRadians(targetLat - lat);
    final dLon = _toRadians(targetLon - lon);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat)) *
            cos(_toRadians(targetLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  bool matchesType(String? wantedType) {
    if (wantedType == null || wantedType.isEmpty) return true;
    final wanted = wantedType.trim().toLowerCase();
    if (types.contains(wanted)) return true;
    if (wanted == 'swimming_pool' && types.contains('sports_centre')) {
      return true;
    }
    return false;
  }

  double _toRadians(double degrees) => degrees * pi / 180;
}

class ScenarioStepViewData {
  const ScenarioStepViewData({required this.title, this.etaMinutes});

  final String title;
  final int? etaMinutes;
}

class ScenarioViewData {
  const ScenarioViewData({
    required this.title,
    required this.description,
    required this.totalDurationMinutes,
    required this.steps,
    this.anchorPlace,
  });

  final String title;
  final String description;
  final int totalDurationMinutes;
  final List<ScenarioStepViewData> steps;
  final PlaceViewData? anchorPlace;
}

enum MeetingFormatView { food, culture, walkOnly, active }

extension MeetingFormatViewLabels on MeetingFormatView {
  String get wireValue => switch (this) {
    MeetingFormatView.food => 'food',
    MeetingFormatView.culture => 'culture',
    MeetingFormatView.walkOnly => 'walk_only',
    MeetingFormatView.active => 'active',
  };

  String get label => switch (this) {
    MeetingFormatView.food => 'Кофе или ужин',
    MeetingFormatView.culture => 'Культура и впечатления',
    MeetingFormatView.walkOnly => 'Просто прогулка',
    MeetingFormatView.active => 'Активный формат',
  };
}

enum SessionStatusView { active, completed, expired }

extension SessionStatusViewX on SessionStatusView {
  bool get isActive => this == SessionStatusView.active;
  bool get isCompleted => this == SessionStatusView.completed;
  bool get isExpired => this == SessionStatusView.expired;
  bool get isClosed => isCompleted || isExpired;
}

enum RevoteRequestStatusView { pending }

extension RevoteRequestStatusViewX on RevoteRequestStatusView {
  bool get isPending => this == RevoteRequestStatusView.pending;
}
