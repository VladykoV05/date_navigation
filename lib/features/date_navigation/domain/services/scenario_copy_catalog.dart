import '../entities/date_vibe.dart';

abstract class ScenarioCopyCatalog {
  String title({
    required MeetingFormat format,
    required int variant,
    required String placeName,
  });

  String description(MeetingFormat format);

  (String title, String description) step({
    required MeetingFormat format,
    required int stepIndex,
  });
}
